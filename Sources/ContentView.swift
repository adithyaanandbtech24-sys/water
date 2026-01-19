import SwiftUI

struct ContentView: View {
    @StateObject private var hitaModel = HitaModel()
    @StateObject private var drawingData = DrawingData()
    @State private var showingDrawSheet = false
    
    var body: some View {
        ZStack {
            // Background
            StarFieldView()
            
            // Notification Banner (conditionally shown if permission needed logic was here, but we just show text for now ideally)
            
            // Main App Card
            VStack(spacing: 0) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("HITA")
                            .font(.system(size: 48, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "ff4d94"))
                        Text(hitaModel.levelText)
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .tracking(1)
                            .foregroundColor(Color(hex: "ff85a2"))
                    }
                    Spacer()
                    Button(action: { showingDrawSheet = true }) {
                        Text("🌈")
                            .font(.system(size: 30))
                    }
                }
                .padding(.bottom, 10)
                
                // Pet Image
                Button(action: {
                    hitaModel.talkToIt()
                }) {
                    ZStack {
                        if let image = drawingData.savedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 220)
                                .scaleEffect(hitaModel.growthScale)
                        } else {
                            // Placeholder or prompt to draw
                            Text("TAP 🌈 TO DRAW HITA!")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "ff85a2"))
                                .frame(height: 200)
                        }
                        
                        if hitaModel.showMessage {
                            Text(hitaModel.currentMessage)
                                .font(.system(size: 14, weight: .bold))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .offset(y: -100)
                                .transition(.scale)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(height: 250)
                
                // Timer Section
                VStack(spacing: 5) {
                    Text("THIRSTY COUNTDOWN...")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(Color.pink.opacity(0.6))
                        .textCase(.uppercase)
                    
                    Text(hitaModel.timeString)
                        .font(.system(size: 40, weight: .black, design: .monospaced))
                        .foregroundColor(Color(hex: "ff4d94"))
                    
                    // Progress Bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white)
                            Capsule().fill(Color(hex: "ff4d94"))
                                .frame(width: geo.size.width * hitaModel.progress)
                                .animation(.linear(duration: 1.0), value: hitaModel.progress)
                        }
                    }
                    .frame(height: 12)
                }
                .padding()
                .background(Color(hex: "fff0f3"))
                .cornerRadius(35)
                .overlay(RoundedRectangle(cornerRadius: 35).stroke(Color.white, lineWidth: 2))
                .padding(.bottom, 15)
                
                // Buttons
                VStack(spacing: 12) {
                    Button(action: { hitaModel.hydrate() }) {
                        Text(hitaModel.isHydrated ? "DRINK WATER (LOCKED)" : "CLICK TO DRINK! 💧")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(hitaModel.isHydrated ? Color(hex: "e0e0e0") : Color(hex: "4db8ff"))
                            .foregroundColor(hitaModel.isHydrated ? Color(hex: "9e9e9e") : .white)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(hitaModel.isHydrated ? Color(hex: "bdbdbd") : Color(hex: "007acc"), lineWidth: 0)
                            )
                            .shadow(color: hitaModel.isHydrated ? .clear : Color(hex: "007acc"), radius: 0, x: 0, y: 4)
                    }
                    .disabled(hitaModel.isHydrated)
                    
                    Button(action: { hitaModel.talkToIt() }) {
                        Text("TALK TO IT 💬")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "ff4d94"))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(color: Color(hex: "c2185b"), radius: 0, x: 0, y: 4)
                    }
                }
            }
            .padding(25)
            .background(Material.ultraThinMaterial)
            .cornerRadius(55)
            .overlay(
                RoundedRectangle(cornerRadius: 55)
                    .stroke(Color.white, lineWidth: 8)
            )
            .padding()
            .shadow(color: Color(hex: "ff4d94").opacity(0.2), radius: 20, x: 0, y: 20)
            
            if showingDrawSheet {
                DrawingView(isPresented: $showingDrawSheet, drawingData: drawingData)
                    .transition(.opacity)
                    .zIndex(100)
            }
        }
    }
}
