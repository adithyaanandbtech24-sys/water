import SwiftUI

struct StarFieldView: View {
    @State private var stars: [Star] = []
    
    struct Star: Identifiable {
        let id = UUID()
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let duration: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "fff0f3"), Color(hex: "ffe4ec")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ForEach(stars) { star in
                    StarView(star: star)
                }
            }
            .onAppear {
                generateStars(in: geometry.size)
            }
        }
    }
    
    func generateStars(in size: CGSize) {
        stars = (0..<30).map { _ in
            Star(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height),
                size: CGFloat.random(in: 2...4),
                duration: Double.random(in: 2...5)
            )
        }
    }
}

struct StarView: View {
    let star: StarFieldView.Star
    @State private var isAnimating = false
    
    var body: some View {
        Text("★")
            .font(.system(size: star.size * 3)) // Adjusting size relative to font
            .foregroundColor(.white)
            .position(x: star.x, y: star.y)
            .scaleEffect(isAnimating ? 1.4 : 1.0)
            .opacity(isAnimating ? 1.0 : 0.3)
            .rotationEffect(Angle(degrees: isAnimating ? 10 : 0))
            .onAppear {
                withAnimation(Animation.easeInOut(duration: star.duration).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
    }
}
