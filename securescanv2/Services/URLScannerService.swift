import Foundation
import CoreML

class URLScannerService {
    
    static let shared = URLScannerService()
    
    private init() {}
    
    
    private let knownPhishingDomains = [
        "fake-bank.com",
        "login-secure-verify.com",
        "account-verification-required.net",
        "secure-payment-confirm.com"
    ]
    
    
    private let suspiciousKeywords = [
        "login", "verify", "secure", "account", "password", "bank", 
        "update", "alert", "confirm", "pay", "weryfikacja", "konto", 
        "haslo", "bank", "platnosc"
    ]
    
    
    private let contentCategoryKeywords: [ContentCategory: [String]] = [
        .adult: [
            "porn", "sex", "xxx", "adult", "nude", "naked", "pornografia", "erotyka",
            "для взрослых", "erotica", "erotic", "porno", "dorosli", "dla dorosłych"
        ],
        .gambling: [
            "casino", "bet", "poker", "slots", "roulette", "gambling", "hazard", "kasyno",
            "zakłady", "bukmacher", "ruletka", "blackjack", "lottery", "lotto"
        ],
        .gore: [
            "gore", "death", "brutal", "violence", "morbid", "blood", "wound", "injury",
            "кровь", "насилие", "brutal", "przemoc", "krew", "drastyczne", "makabryczne"
        ],
        .malware: [
            "malware", "virus", "trojan", "worm", "ransomware", "spyware", "botnet", 
            "exploit", "backdoor", "rootkit", "keylogger", "cracked", "crack", "keygen"
        ],
        .phishing: [
            "phishing", "scam", "fraud", "fake", "suspicious", "verify", "confirm", "login",
            "account", "password", "bank", "кража", "данных", "oszustwo", "weryfikacja"
        ],
        .scam: [
            "scam", "fraud", "fake", "free money", "lottery winner", "prize", "won", 
            "inheritance", "oszustwo", "wygrałeś", "nagroda", "dziedzictwo", "obietnica"
        ],
        .drugs: [
            "drugs", "narcotics", "cocaine", "heroin", "marijuana", "cannabis", "steroids",
            "pills", "lsd", "mdma", "ecstasy", "narkotyki", "dopalacze", "psychodeliki"
        ],
        .weapons: [
            "weapons", "guns", "ammo", "ammunition", "firearms", "rifle", "pistol", "bomb",
            "explosive", "missile", "broń", "amunicja", "karabin", "pistolet", "bomba"
        ],
        .extremism: [
            "terrorism", "extremism", "radical", "nazi", "jihad", "hate", "propaganda",
            "supremacist", "extremist", "terrorist", "ekstremizm", "terroryzm", "radykalny"
        ]
    ]
    
    
    func scanURL(_ urlString: String, sourceType: SourceType = .manual, completion: @escaping (ScanResult) -> Void) {
        
        guard let url = URL(string: urlString), let host = url.host?.lowercased() else {
            let result = ScanResult(
                url: urlString,
                resultType: .suspicious,
                scanDate: Date(),
                details: "Nieprawidłowy format URL",
                isPhishing: false,
                contentCategory: .none,
                sourceType: sourceType,
                educationalTip: "Prawidłowe adresy URL zaczynają się od http:// lub https://"
            )
            completion(result)
            return
        }
        
        
        var detectedCategory: ContentCategory = .none
        var categoryDetails = ""
        var resultType: ScanResultType = .safe
        var educationalMessage = ""
        
        
        let fullURL = urlString.lowercased()
        
        
        func checkCategory(category: ContentCategory) -> Bool {
            guard let keywords = contentCategoryKeywords[category] else { return false }
            return keywords.contains { keyword in 
                fullURL.contains(keyword) || host.contains(keyword)
            }
        }
        
        
        if checkCategory(category: .phishing) {
            detectedCategory = .phishing
            resultType = .dangerous
            categoryDetails = "Ten URL może być próbą wyłudzenia danych (phishing)"
            educationalMessage = "Nigdy nie podawaj swoich danych logowania ani osobowych na stronach, do których trafiłeś przez podejrzane linki"
        } 
        else if checkCategory(category: .malware) {
            detectedCategory = .malware
            resultType = .dangerous
            categoryDetails = "Ten URL może zawierać złośliwe oprogramowanie"
            educationalMessage = "Nigdy nie pobieraj plików z niezaufanych źródeł. Mogą one zawierać wirusy lub inne złośliwe oprogramowanie"
        }
        else if checkCategory(category: .adult) {
            detectedCategory = .adult
            resultType = .suspicious
            categoryDetails = "Ten URL może zawierać treści dla dorosłych (pornograficzne)"
            educationalMessage = "Strony z treściami dla dorosłych mogą zawierać złośliwe oprogramowanie lub być wykorzystywane do ataków phishingowych"
        }
        else if checkCategory(category: .gambling) {
            detectedCategory = .gambling
            resultType = .suspicious
            categoryDetails = "Ten URL może zawierać treści związane z hazardem"
            educationalMessage = "Strony hazardowe mogą być nielegalne w Twoim kraju, a także często wykorzystują techniki manipulacji psychologicznej"
        }
        else if checkCategory(category: .gore) {
            detectedCategory = .gore
            resultType = .suspicious
            categoryDetails = "Ten URL może zawierać drastyczne treści (makabryczne obrazy/filmy)"
            educationalMessage = "Strony z drastycznymi treściami mogą prezentować treści nieodpowiednie dla osób wrażliwych i nieletnich"
        }
        else if checkCategory(category: .scam) {
            detectedCategory = .scam
            resultType = .dangerous
            categoryDetails = "Ten URL może być oszustwem"
            educationalMessage = "Bądź ostrożny wobec ofert, które wydają się zbyt dobre, aby były prawdziwe - zwykle są oszustwem"
        }
        else if checkCategory(category: .drugs) {
            detectedCategory = .drugs
            resultType = .suspicious
            categoryDetails = "Ten URL może zawierać treści związane z narkotykami"
            educationalMessage = "Strony związane z narkotykami mogą promować nielegalne substancje i narażać Cię na konsekwencje prawne"
        }
        else if checkCategory(category: .weapons) {
            detectedCategory = .weapons
            resultType = .suspicious
            categoryDetails = "Ten URL może zawierać treści związane z bronią"
            educationalMessage = "Strony związane z bronią mogą zawierać nielegalne treści lub narażać Cię na konsekwencje prawne"
        }
        else if checkCategory(category: .extremism) {
            detectedCategory = .extremism
            resultType = .dangerous
            categoryDetails = "Ten URL może zawierać treści ekstremistyczne"
            educationalMessage = "Strony z treściami ekstremistycznymi mogą zawierać nielegalne, szkodliwe materiały propagujące nienawiść"
        }
        
        
        if knownPhishingDomains.contains(where: { host.contains($0) }) {
            detectedCategory = .phishing
            resultType = .dangerous
            categoryDetails = "Ten adres URL został zidentyfikowany jako phishing"
            educationalMessage = "Nigdy nie podawaj swoich danych osobowych na podejrzanych stronach"
        }
        
        
        var suspiciousCount = 0
        
        
        if !urlString.starts(with: "https://") {
            suspiciousCount += 1
        }
        
        
        for keyword in suspiciousKeywords {
            if host.contains(keyword) {
                suspiciousCount += 1
            }
        }
        
        
        let subdomainCount = host.components(separatedBy: ".").count
        if subdomainCount > 3 {
            suspiciousCount += 1
        }
        
        
        if detectedCategory == .none && suspiciousCount >= 3 {
            resultType = .suspicious
            categoryDetails = "Ten URL zawiera podejrzane elementy"
            educationalMessage = "Bądź ostrożny wobec adresów URL z wieloma domenami lub podejrzanymi słowami kluczowymi"
        }
        
        
        if detectedCategory == .none && resultType == .safe {
            categoryDetails = "Ten URL wydaje się być bezpieczny"
            educationalMessage = "Nawet jeśli URL wydaje się bezpieczny, zawsze zachowuj ostrożność przy podawaniu danych osobowych"
        }
        
        let result = ScanResult(
            url: urlString,
            resultType: resultType,
            scanDate: Date(),
            details: categoryDetails,
            isPhishing: detectedCategory == .phishing,
            contentCategory: detectedCategory,
            sourceType: sourceType,
            educationalTip: educationalMessage
        )
        
        completion(result)
    }
    
    
    func extractAndScanURLs(from text: String, completion: @escaping ([ScanResult]) -> Void) {
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        if matches.isEmpty {
            completion([])
            return
        }
        
        var results: [ScanResult] = []
        let group = DispatchGroup()
        
        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            let urlString = String(text[range])
            
            group.enter()
            scanURL(urlString) { result in
                results.append(result)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(results)
        }
    }
    
    
    
    func simulateCategoryDetection(url: String, category: ContentCategory, sourceType: SourceType = .manual, completion: @escaping (ScanResult) -> Void) {
        var resultType: ScanResultType = .suspicious
        var details = ""
        var educationalTip = ""
        
        switch category {
        case .adult:
            details = "Ten URL zawiera treści dla dorosłych (pornograficzne)"
            educationalTip = "Strony z treściami dla dorosłych mogą zawierać złośliwe oprogramowanie lub być wykorzystywane do ataków phishingowych"
        case .gambling:
            details = "Ten URL zawiera treści związane z hazardem"
            educationalTip = "Strony hazardowe mogą być nielegalne w Twoim kraju, a także często wykorzystują techniki manipulacji psychologicznej"
        case .gore:
            details = "Ten URL zawiera drastyczne treści (makabryczne obrazy/filmy)"
            educationalTip = "Strony z drastycznymi treściami mogą prezentować treści nieodpowiednie dla osób wrażliwych i nieletnich"
        case .malware:
            resultType = .dangerous
            details = "Ten URL zawiera złośliwe oprogramowanie"
            educationalTip = "Nigdy nie pobieraj plików z niezaufanych źródeł. Mogą one zawierać wirusy lub inne złośliwe oprogramowanie"
        case .phishing:
            resultType = .dangerous
            details = "Ten URL jest próbą wyłudzenia danych (phishing)"
            educationalTip = "Nigdy nie podawaj swoich danych logowania ani osobowych na stronach, do których trafiłeś przez podejrzane linki"
        case .scam:
            resultType = .dangerous
            details = "Ten URL jest oszustwem"
            educationalTip = "Bądź ostrożny wobec ofert, które wydają się zbyt dobre, aby były prawdziwe - zwykle są oszustwem"
        case .drugs:
            details = "Ten URL zawiera treści związane z narkotykami"
            educationalTip = "Strony związane z narkotykami mogą promować nielegalne substancje i narażać Cię na konsekwencje prawne"
        case .weapons:
            details = "Ten URL zawiera treści związane z bronią"
            educationalTip = "Strony związane z bronią mogą zawierać nielegalne treści lub narażać Cię na konsekwencje prawne"
        case .extremism:
            resultType = .dangerous
            details = "Ten URL zawiera treści ekstremistyczne"
            educationalTip = "Strony z treściami ekstremistycznymi mogą zawierać nielegalne, szkodliwe materiały propagujące nienawiść"
        case .none:
            resultType = .safe
            details = "Ten URL wydaje się być bezpieczny"
            educationalTip = "Nawet jeśli URL wydaje się bezpieczny, zawsze zachowuj ostrożność przy podawaniu danych osobowych"
        }
        
        let result = ScanResult(
            url: url,
            resultType: resultType,
            scanDate: Date(),
            details: details,
            isPhishing: category == .phishing,
            contentCategory: category,
            sourceType: sourceType,
            educationalTip: educationalTip
        )
        
        completion(result)
    }
    
    
    
    private struct HistoryItem {
        let url: String
        let resultType: ScanResultType
        let scanDate: Date
        let details: String
        let isPhishing: Bool
        let contentCategory: ContentCategory
        let educationalTip: String?
    }
    
    private var scanHistory: [HistoryItem] = []
    
    func addToHistory(_ result: ScanResult) {
        
        let historyItem = HistoryItem(
            url: result.url,
            resultType: result.resultType,
            scanDate: result.scanDate,
            details: result.details,
            isPhishing: result.isPhishing,
            contentCategory: result.contentCategory,
            educationalTip: result.educationalTip
        )
        scanHistory.append(historyItem)
        
    }
    
    func getScanHistory() -> [ScanResult] {
        
        return scanHistory.sorted(by: { $0.scanDate > $1.scanDate }).map { item in
            return ScanResult(
                url: item.url,
                resultType: item.resultType,
                scanDate: item.scanDate,
                details: item.details,
                isPhishing: item.isPhishing,
                contentCategory: item.contentCategory,
                sourceType: .manual, 
                educationalTip: item.educationalTip
            )
        }
    }
    
    func clearHistory() {
        scanHistory.removeAll()
    }
}
