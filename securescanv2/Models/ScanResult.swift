import Foundation

enum ScanResultType {
    case safe
    case suspicious
    case dangerous
    case unknown
}

enum ContentCategory {
    case none
    case adult         // Treści dla dorosłych/pornografia
    case gambling      // Hazard
    case gore          // Drastyczne treści
    case malware       // Złośliwe oprogramowanie
    case phishing      // Próby wyłudzenia danych
    case scam          // Oszustwa
    case drugs         // Treści związane z narkotykami
    case weapons       // Broń
    case extremism     // Treści ekstremistyczne
}

enum SourceType {
    case manual        // Ręcznie wprowadzony URL
    case qrCode        // URL z kodu QR
}

struct ScanResult {
    let url: String
    let resultType: ScanResultType
    let scanDate: Date
    let details: String
    let isPhishing: Bool
    let contentCategory: ContentCategory
    let sourceType: SourceType
    
    // Additional info for educational purposes
    var educationalTip: String?
    
    // Inicjalizator z wartością domyślną dla sourceType
    init(url: String, resultType: ScanResultType, scanDate: Date, details: String, isPhishing: Bool,
         contentCategory: ContentCategory, sourceType: SourceType = .manual, educationalTip: String? = nil) {
        self.url = url
        self.resultType = resultType
        self.scanDate = scanDate
        self.details = details
        self.isPhishing = isPhishing
        self.contentCategory = contentCategory
        self.sourceType = sourceType
        self.educationalTip = educationalTip
    }
    
    static func example() -> ScanResult {
        return ScanResult(
            url: "https://example.com",
            resultType: .safe,
            scanDate: Date(),
            details: "To jest legalna strona internetowa",
            isPhishing: false,
            contentCategory: .none,
            sourceType: .manual,
            educationalTip: "Zawsze sprawdzaj, czy URL zaczyna się od https"
        )
    }
}
