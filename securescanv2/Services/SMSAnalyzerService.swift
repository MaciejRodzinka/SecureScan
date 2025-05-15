import Foundation

class SMSAnalyzerService {
    
    static let shared = SMSAnalyzerService()
    
    private init() {}
    
    
    private let knownScamSenders = [
        "+48123456789",
        "INFO-BANK",
        "DOSTAWA",
        "Info-Paczka"
    ]
    
    
    private let suspiciousKeywords = [
        "pilne", "weryfikacja", "kliknij", "potwierdź", "konto", "hasło", "bank", "zabezpieczenie",
        "link", "nagroda", "wygrałeś", "płatność", "wygasa", "dostęp", "zablokowany", "karta"
    ]
    
    
    func analyzeSMS(sender: String, content: String) -> SMSMessage {
        let now = Date()
        var riskLevel: SMSRiskLevel = .safe
        
        
        if knownScamSenders.contains(where: { sender.contains($0) }) {
            riskLevel = .dangerous
            return SMSMessage(sender: sender, content: content, receivedDate: now, riskLevel: riskLevel)
        }
        
        
        var suspiciousCount = 0
        let lowercaseContent = content.lowercased()
        for keyword in suspiciousKeywords {
            if lowercaseContent.contains(keyword.lowercased()) {
                suspiciousCount += 1
            }
        }
        
        
        let containsURL = content.range(of: "http[s]?://.*",
                                      options: .regularExpression) != nil
        
        
        let containsShortenedURL = content.range(of: "\\b(bit\\.ly|tinyurl\\.com|is\\.gd|t\\.co|tiny\\.cc)\\S*\\b",
                                              options: .regularExpression) != nil
        
        
        if containsShortenedURL {
            suspiciousCount += 2  
        } else if containsURL {
            suspiciousCount += 1
        }
        
        
        let urgencyIndicators = ["natychmiast", "teraz", "pilne", "w ciągu 24h", "dzisiaj", "zaraz"]
        for indicator in urgencyIndicators {
            if lowercaseContent.contains(indicator.lowercased()) {
                suspiciousCount += 1
                break
            }
        }
        
        
        if suspiciousCount >= 3 {
            riskLevel = .dangerous
        } else if suspiciousCount >= 1 {
            riskLevel = .suspicious
        }
        
        return SMSMessage(sender: sender, content: content, receivedDate: now, riskLevel: riskLevel)
    }
    
    
    private var smsHistory: [SMSMessage] = []
    
    func addToHistory(_ message: SMSMessage) {
        smsHistory.append(message)
        
    }
    
    func getMessageHistory() -> [SMSMessage] {
        return smsHistory.sorted(by: { $0.receivedDate > $1.receivedDate })
    }
    
    func clearHistory() {
        smsHistory.removeAll()
        
    }
    
    
    func prepareReport(for message: SMSMessage) -> String {
        return "Treść zgłoszenia do numeru 8080:\n\(message.content)"
    }
    
    
    func reportMessage(_ message: inout SMSMessage) {
        
        
        var updatedMessage = message
        updatedMessage.isReported = true
        
        
        if let index = smsHistory.firstIndex(where: { $0.sender == message.sender && $0.content == message.content }) {
            smsHistory[index] = updatedMessage
        }
        
        message = updatedMessage
    }
}
