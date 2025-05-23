import Foundation

enum ContentType {
    case article
    case quiz
    case video
}

struct EducationalContent {
    let id: String
    let title: String
    let description: String
    let contentType: ContentType
    let createdDate: Date
    let content: String  
    let quizQuestions: [QuizQuestion]?
    var isCompleted: Bool = false
    var userScore: Int?
    
    static func exampleArticle() -> EducationalContent {
        return EducationalContent(
            id: "article-1",
            title: "Jak rozpoznać phishing?",
            description: "Poznaj 5 kluczowych oznak phishingu",
            contentType: .article,
            createdDate: Date(),
            content: "<p>Phishing to popularna forma oszustwa polegająca na podszywaniu się pod zaufane instytucje. Oto jak go rozpoznać:</p><ul><li>Sprawdź adres URL - zwróć uwagę na literówki</li><li>Bądź ostrożny wobec pilnych wezwań</li><li>Uważaj na błędy gramatyczne</li><li>Nie klikaj w podejrzane linki</li><li>Sprawdzaj dane nadawcy</li></ul>",
            quizQuestions: nil
        )
    }
    
    static func exampleQuiz() -> EducationalContent {
        return EducationalContent(
            id: "quiz-1",
            title: "Quiz: Bezpieczne Zakupy Online",
            description: "Sprawdź swoją wiedzę na temat bezpiecznych zakupów internetowych",
            contentType: .quiz,
            createdDate: Date(),
            content: "",
            quizQuestions: [
                QuizQuestion(
                    question: "Która z tych cech wskazuje na bezpieczny sklep internetowy?",
                    options: [
                        "Bardzo niskie ceny w porównaniu do innych sklepów",
                        "Brak danych kontaktowych",
                        "Symbol kłódki HTTPS w pasku adresu",
                        "Naleganie na płatność przelewem z góry"
                    ],
                    correctAnswerIndex: 2
                ),
                QuizQuestion(
                    question: "Co powinno wzbudzić Twoją czujność podczas zakupów online?",
                    options: [
                        "Sklep oferuje wiele metod płatności",
                        "Sklep ma regulamin i politykę prywatności",
                        "Sprzedawca prosi o przelanie pieniędzy na prywatne konto",
                        "Strona ma opinie użytkowników"
                    ],
                    correctAnswerIndex: 2
                )
            ]
        )
    }
}

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
}
