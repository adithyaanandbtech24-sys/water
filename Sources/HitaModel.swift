import SwiftUI
import UserNotifications

class HitaModel: ObservableObject {
    @Published var timeLeft: Int = 7200
    @Published var isHydrated: Bool = true
    @Published var levelText: String = "CALCULATING LEVEL..."
    @Published var growthScale: CGFloat = 1.0
    @Published var currentMessage: String = ""
    @Published var showMessage: Bool = false
    
    private var timer: Timer?
    private let startDateKey = "hita_start_time"
    
    // Messages array from the original code
    private let messages: [String] = [
        "HITA, I love you! 💕", "HITA, ADITHYA SAYS HI!!! ✨", "HITA, ADITHYA SAYS MWAHH.. 💋",
        "HITA, I missed you so much!! 🌸", "HITA, say HI to ADITHYA! 👋", "You look like a pink princess today, HITA!",
        "Adithya told me to tell you you're the best! 💖", "HITA, stop being so cute! 🎀", "A hug from me to HITA! 🤗",
        "HITA, you're the star of my galaxy!", "Drink up, HITA-baby! 💧", "Adithya is proud of you, HITA!"
    ] + (1...50).flatMap { i in
        ["HITA: Adithya sent kiss #\(i)! 💋", "HITA, you are glowing! ✨", "Adithya says: HITA is my #1! 💖"]
    }
    
    init() {
        requestNotificationPermission()
        startTimer()
        updateGrowth()
        
        // Check if start date exists, if not set it
        if UserDefaults.standard.object(forKey: startDateKey) == nil {
            UserDefaults.standard.set(Date(), forKey: startDateKey)
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notifications granted")
            }
        }
    }
    
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeLeft > 0 {
                self.timeLeft -= 1
            } else {
                if self.isHydrated {
                    self.isHydrated = false
                    self.sendNotification(title: "HITA - THIRSTY!", body: "Time to drink water! 💧")
                    AudioManager.shared.playBark()
                }
            }
        }
    }
    
    func hydrate() {
        timeLeft = 7200
        isHydrated = true
        sendNotification(title: "Success!", body: "Great job HITA! We are both hydrated! 💧")
        AudioManager.shared.playBark()
    }
    
    func talkToIt() {
        let randomMessage = messages.randomElement() ?? "Hi Hita!"
        currentMessage = randomMessage
        showMessage = true
        currentMessage = randomMessage
        showMessage = true
        sendNotification(title: "Companion Message", body: randomMessage)
        AudioManager.shared.playMeow()
        updateGrowth()
        
        // Auto hide message after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showMessage = false
        }
    }
    
    func updateGrowth() {
        guard let startDate = UserDefaults.standard.object(forKey: startDateKey) as? Date else { return }
        let now = Date()
        let daysPassed = Calendar.current.dateComponents([.day], from: startDate, to: now).day ?? 0
        
        let currentLevel = daysPassed + 1
        levelText = "LEVEL \(currentLevel) COMPANION"
        growthScale = min(1.4, 1.0 + (CGFloat(daysPassed) * 0.02))
    }
    
    var timeString: String {
        let hrs = timeLeft / 3600
        let mins = (timeLeft % 3600) / 60
        let secs = timeLeft % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
    
    var progress: CGFloat {
        return CGFloat(timeLeft) / 7200.0
    }
}
