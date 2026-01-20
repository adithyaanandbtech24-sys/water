import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var player: AVPlayer?
    
    let meowURL = URL(string: "https://assets.mixkit.co/active_storage/sfx/951/951-preview.mp3")!
    let barkURL = URL(string: "https://assets.mixkit.co/active_storage/sfx/1815/1815-preview.mp3")!
    
    func playMeow() {
        play(url: meowURL)
    }
    
    func playBark() {
        play(url: barkURL)
    }
    
    private func play(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
}
