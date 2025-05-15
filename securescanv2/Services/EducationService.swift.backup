import Foundation

class EducationService {
    
    static let shared = EducationService()
    
    private init() {}
    
    private var educationalContent: [EducationalContent] = []
    
    // Load educational content - in a real app, this would fetch from a server or local database
    func loadContent(completion: @escaping ([EducationalContent]) -> Void) {
        // Generate sample educational content
        let content = generateSampleContent()
        self.educationalContent = content
        completion(content)
    }
    
    // Generate sample content for the app
    private func generateSampleContent() -> [EducationalContent] {
        
        // Articles
        let article1 = EducationalContent(
            id: "art1",
            title: "Jak rozpoznać phishing?",
            description: "5 kluczowych oznak, które pomogą Ci rozpoznać próby phishingu",
            contentType: .article,
            createdDate: Date(),
            content: """
            <h2>Jak rozpoznać phishing?</h2>
            <p>Phishing to popularna metoda oszustwa polegająca na podszywaniu się pod zaufane instytucje. Oto jak go rozpoznać:</p>
            <ol>
                <li><strong>Sprawdź adres nadawcy</strong> - prawdziwe firmy używają oficjalnych domen, nie prywatnych adresów email</li>
                <li><strong>Pilność i presja</strong> - oszuści często wywierają presję, aby zmusić do szybkiego działania</li>
                <li><strong>Błędy językowe</strong> - legalne firmy rzadko wysyłają wiadomości z błędami gramatycznymi</li>
                <li><strong>Sprawdź URL</strong> - przed kliknięciem zawsze sprawdź, dokąd prowadzi link</li>
                <li><strong>Prośby o dane osobowe</strong> - zaufane firmy nie proszą o poufne dane przez email</li>
            </ol>
            <p>W razie wątpliwości, zawsze kontaktuj się z daną firmą przez oficjalną stronę, nie klikając w linki z wiadomości.</p>
            """,
            quizQuestions: nil
        )
        
        let article2 = EducationalContent(
            id: "art2",
            title: "Bezpieczne zakupy online",
            description: "Jak bezpiecznie robić zakupy w internecie",
            contentType: .article,
            createdDate: Date(),
            content: """
            <h2>Bezpieczne zakupy online</h2>
            <p>Internet oferuje wygodne zakupy, ale niesie też ryzyko. Oto zasady bezpieczeństwa:</p>
            <ol>
                <li><strong>Sprawdź sklep</strong> - szukaj opinii, danych kontaktowych i regulaminu</li>
                <li><strong>Bezpieczne płatności</strong> - wybieraj płatności kartą lub PayPal oferujące ochronę kupującego</li>
                <li><strong>Unikaj ofert "zbyt dobrych, by były prawdziwe"</strong> - wyjątkowo niskie ceny mogą sygnalizować oszustwo</li>
                <li><strong>Sprawdź HTTPS</strong> - upewnij się, że strona ma szyfrowanie (symbol kłódki w przeglądarce)</li>
                <li><strong>Używaj silnych haseł</strong> - dla każdego sklepu stosuj inne, złożone hasło</li>
            </ol>
            <p>Zachowaj potwierdzenia zamówień i śledź swoje przesyłki, aby szybko wychwycić nieprawidłowości.</p>
            """,
            quizQuestions: nil
        )
        
        let article3 = EducationalContent(
            id: "art3",
            title: "Smishing - oszustwa SMS",
            description: "Jak rozpoznać fałszywe wiadomości SMS",
            contentType: .article,
            createdDate: Date(),
            content: """
            <h2>Smishing - oszustwa SMS</h2>
            <p>Smishing to phishing realizowany przez SMS. Oto jak się chronić:</p>
            <ol>
                <li><strong>Bądź sceptyczny wobec nieznanych nadawców</strong> - zwłaszcza gdy proszą o pilną akcję</li>
                <li><strong>Nie klikaj w linki w SMS-ach</strong> - zamiast tego odwiedź oficjalną stronę instytucji</li>
                <li><strong>Zweryfikuj nadawcę</strong> - banki czy urzędy mają oficjalne numery, nie prywatne</li>
                <li><strong>Zgłaszaj podejrzane SMS-y</strong> - w Polsce możesz przesłać je na numer 8080</li>
                <li><strong>Nie odpowiadaj</strong> - ignoruj podejrzane wiadomości i nie odpisuj na nie</li>
            </ol>
            <p>Pamiętaj, że instytucje finansowe nigdy nie proszą o poufne dane przez SMS!</p>
            """,
            quizQuestions: nil
        )
        
        // Quizzy
        let quiz1 = EducationalContent(
            id: "quiz1",
            title: "Quiz: Podstawy phishingu",
            description: "Sprawdź swoją wiedzę na temat rozpoznawania phishingu",
            contentType: .quiz,
            createdDate: Date(),
            content: "",
            quizQuestions: [
                QuizQuestion(
                    question: "Co z poniższych jest najsilniejszą oznaką phishingu?",
                    options: [
                        "Email od znanej firmy",
                        "Prośba o aktualizację danych",
                        "Adres email różniący się od oficjalnego",
                        "Kolorowe logo firmy"
                    ],
                    correctAnswerIndex: 2
                ),
                QuizQuestion(
                    question: "Która z tych wiadomości jest najbardziej podejrzana?",
                    options: [
                        "Twoja paczka dotrze jutro",
                        "Twoje konto zostanie zablokowane. Kliknij link, aby je odblokować",
                        "Twoja faktura jest dostępna w panelu klienta",
                        "Zapraszamy do skorzystania z promocji w naszym sklepie"
                    ],
                    correctAnswerIndex: 1
                ),
                QuizQuestion(
                    question: "Co powinieneś zrobić, gdy otrzymasz podejrzany email z banku?",
                    options: [
                        "Kliknąć w link i sprawdzić stronę",
                        "Od razu podać swoje dane logowania",
                        "Skontaktować się z bankiem przez oficjalną infolinię",
                        "Odpowiedzieć na email i zapytać, czy jest prawdziwy"
                    ],
                    correctAnswerIndex: 2
                )
            ]
        )
        
        let quiz2 = EducationalContent(
            id: "quiz2",
            title: "Quiz: Bezpieczne hasła",
            description: "Sprawdź, czy wiesz jak tworzyć bezpieczne hasła",
            contentType: .quiz,
            createdDate: Date(),
            content: "",
            quizQuestions: [
                QuizQuestion(
                    question: "Które z tych haseł jest najbezpieczniejsze?",
                    options: [
                        "password123",
                        "Imię psa + rok urodzenia",
                        "Kr0lik@4Marchew!2",
                        "qwerty"
                    ],
                    correctAnswerIndex: 2
                ),
                QuizQuestion(
                    question: "Jak często powinieneś zmieniać swoje hasła?",
                    options: [
                        "Tylko gdy dojdzie do wycieku danych",
                        "Co 2-3 miesiące",
                        "Raz w roku",
                        "Nigdy, jeśli hasło jest silne"
                    ],
                    correctAnswerIndex: 1
                )
            ]
        )
        
        // Video content
        let video1 = EducationalContent(
            id: "video1",
            title: "Jak działają oszuści internetowi?",
            description: "Film edukacyjny o metodach oszustów",
            contentType: .video,
            createdDate: Date(),
            content: "https://www.youtube.com/watch?v=example_video_id",
            quizQuestions: nil
        )
        
        // Combine all content
        return [article1, article2, article3, quiz1, quiz2, video1].sorted(by: { $0.title < $1.title })
    }
    
    // Get all educational content
    func getAllContent() -> [EducationalContent] {
        return educationalContent
    }
    
    // Get content by type
    func getContent(ofType type: ContentType) -> [EducationalContent] {
        return educationalContent.filter { $0.contentType == type }
    }
    
    // Get content by ID
    func getContent(withId id: String) -> EducationalContent? {
        return educationalContent.first { $0.id == id }
    }
    
    // Mark content as completed
    func markAsCompleted(contentId: String, score: Int? = nil) {
        if let index = educationalContent.firstIndex(where: { $0.id == contentId }) {
            var content = educationalContent[index]
            content.isCompleted = true
            content.userScore = score
            educationalContent[index] = content
        }
    }
    
    // Get completed content
    func getCompletedContent() -> [EducationalContent] {
        return educationalContent.filter { $0.isCompleted }
    }
    
    // Get recommended content based on user history and activity
    func getRecommendedContent() -> [EducationalContent] {
        // In a real app, this would use more sophisticated recommendation algorithms
        let notCompleted = educationalContent.filter { !$0.isCompleted }
        
        // If we have some not completed content, return up to 3 items
        if !notCompleted.isEmpty {
            let shuffled = notCompleted.shuffled()
            return Array(shuffled.prefix(3))
        }
        
        // Otherwise return random content for review
        let shuffled = educationalContent.shuffled()
        return Array(shuffled.prefix(3))
    }
}
