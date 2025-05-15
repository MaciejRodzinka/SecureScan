import Foundation

class SMSAnalyzerService {
    
    static let shared = SMSAnalyzerService()
    
    private init() {}
    
    // Database of known scam senders (would be updated regularly in production)
    private let knownScamSenders = [
        "+48123456789",
        "INFO-BANK",
        "DOSTAWA",
        "Info-Paczka"
    ]
    
    // Suspicious keywords in SMS messages
    private let suspiciousKeywords = [
        "pilne", "weryfikacja", "kliknij", "potwierdź", "konto", "hasło", "bank", "zabezpieczenie",
        "link", "nagroda", "wygrałeś", "płatność", "wygasa", "dostęp", "zablokowany", "karta"
    ]
    
    // Analyze SMS for potential smishing
    func analyzeSMS(sender: String, content: String) -> SMSMessage {
        let now = Date()
        var riskLevel: SMSRiskLevel = .safe
        
        // Check if sender is in known scam list
        if knownScamSenders.contains(where: { sender.contains($0) }) {
            riskLevel = .dangerous
            return SMSMessage(sender: sender, content: content, receivedDate: now, riskLevel: riskLevel)
        }
        
        // Count suspicious keywords present in the message
        var suspiciousCount = 0
        let lowercaseContent = content.lowercased()
        for keyword in suspiciousKeywords {
            if lowercaseContent.contains(keyword.lowercased()) {
                suspiciousCount += 1
            }
        }
        
        // Check for URLs
        let containsURL = content.range(of: "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+",
                                      options: .regularExpression) != nil
        
        // Check for shortened URLs like bit.ly, t.co etc., which are common in scams
        let containsShortenedURL = content.range(of: "\\b(bit\\.ly|tinyurl\\.com|is\\.gd|t\\.co|tiny\\.cc)\\S*",
                                              options: .regularExpression) != nil
        
        // Determine risk level based on multiple factors
        if containsShortenedURL {
            suspiciousCount += 2  // Shortened URLs are a big red flag
        } else if containsURL {
            suspiciousCount += 1
        }
        
        // Check for urgency indicators
        let urgencyIndicators = ["natychmiast", "teraz", "pilne", "w ciągu 24h", "dzisiaj", "zaraz"]
        for indicator in urgencyIndicators {
            if lowercaseContent.contains(indicator.lowercased()) {
                suspiciousCount += 1
                break
            }
        }
        
        // Set risk level based on number of suspicious elements
        if suspiciousCount >= 3 {
            riskLevel = .dangerous
        } else if suspiciousCount >= 1 {
            riskLevel = .suspicious
        }
        
        return SMSMessage(sender: sender, content: content, receivedDate: now, riskLevel: riskLevel)
    }
    
    // Store SMS history
    private var smsHistory: [SMSMessage] = []
    
    func addToHistory(_ message: SMSMessage) {
        smsHistory.append(message)
        // In a real app, this would be persisted using Core Data or similar
    }
    
    func getMessageHistory() -> [SMSMessage] {
        return smsHistory.sorted(by: { $0.receivedDate > $1.receivedDate })
    }
    
    func clearHistory() {
        smsHistory.removeAll()
        // In a real app, this would clear the persistent storage
    }
    
    // Function to prepare reporting to 8080 (Polish anti-smishing number)
    func prepareReport(for message: SMSMessage) -> String {
        return "Treść zgłoszenia do numeru 8080:\n\(message.content)"
    }
    
    // Report message to 8080
    func reportMessage(_ message: inout SMSMessage) {
        // In a real app, this would handle the actual SMS sending to 8080
        // For now, we'll just mark it as reported
        var updatedMessage = message
        updatedMessage.isReported = true
        
        // Update in history
        if let index = smsHistory.firstIndex(where: { $0.sender == message.sender && $0.content == message.content }) {
            smsHistory[index] = updatedMessage
        }
        
        message = updatedMessage
    }
}
