import Foundation

enum SMSRiskLevel {
    case safe
    case suspicious
    case dangerous
}

struct SMSMessage {
    let sender: String
    let content: String
    let receivedDate: Date
    let riskLevel: SMSRiskLevel
    var isReported: Bool = false
    
    // Helper properties
    var containsURL: Bool {
        // Basic URL detection
        return content.range(of: "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+",
                             options: .regularExpression) != nil
    }
    
    var containsSuspiciousWords: Bool {
        // List of commonly used words in scam messages
        let suspiciousWords = ["wygrałeś", "nagroda", "pilne", "kliknij", "hasło", "weryfikacja", 
                              "bank", "konto", "blokada", "natychmiast", "płatność"]
        
        let lowercaseContent = content.lowercased()
        return suspiciousWords.contains { lowercaseContent.contains($0.lowercased()) }
    }
    
    static func example() -> SMSMessage {
        return SMSMessage(
            sender: "+48123456789",
            content: "Twoja paczka czeka na odbiór. Kliknij w link aby sprawdzić status: hxxp://fake-link.com",
            receivedDate: Date(),
            riskLevel: .suspicious
        )
    }
}
