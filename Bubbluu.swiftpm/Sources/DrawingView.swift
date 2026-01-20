import SwiftUI

struct DrawingView: View {
    @Binding var isPresented: Bool
    @ObservedObject var drawingData: DrawingData
    
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    
    struct Line {
        var points: [CGPoint] = []
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack {
                Text("DRAW YOUR FRIEND! 🎨")
                    .font(.custom("Bubblegum Sans", size: 30)) // Fallback to system if font not allowed
                    .foregroundColor(Color(hex: "ff4d94"))
                    .padding(.bottom, 5)
                
                Canvas { context, size in
                    // Draw saved lines
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(Color(hex: "ff4d94")), lineWidth: 6)
                    }
                    // Draw current line
                    var path = Path()
                    path.addLines(currentLine.points)
                    context.stroke(path, with: .color(Color(hex: "ff4d94")), lineWidth: 6)
                }
                .frame(width: 320, height: 320)
                .background(Color.white)
                .cornerRadius(35)
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(Color(hex: "ff85a2"), style: StrokeStyle(lineWidth: 4, dash: [10]))
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let newPoint = value.location
                            // Constrain to canvas size if possible, but for now allow drawing
                            currentLine.points.append(newPoint)
                        }
                        .onEnded { _ in
                            self.lines.append(currentLine)
                            self.currentLine = Line()
                        }
                )
                
                HStack(spacing: 20) {
                    Button(action: {
                        lines = []
                        currentLine = Line()
                    }) {
                        Text("ERASE")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    
                    Button(action: {
                        saveDrawing()
                        isPresented = false
                    }) {
                        Text("START DAY! ✨")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "ff4d94"))
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(hex: "c2185b"), lineWidth: 4)
                            )
                    }
                }
                .padding(.top, 20)
                .frame(width: 320)
            }
            .padding(30)
            .background(Color.white.opacity(0.95))
            .cornerRadius(50)
            .padding()
        }
    }
    
    func saveDrawing() {
        let renderer = ImageRenderer(content:
            Canvas { context, size in
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(Color(hex: "ff4d94")), lineWidth: 6)
                }
            }
            .frame(width: 320, height: 320)
            .background(Color.white)
        )
        
        #if os(iOS)
        if let uiImage = renderer.uiImage {
            drawingData.saveImage(image: uiImage)
        }
        #elseif os(macOS)
        if let nsImage = renderer.nsImage {
            drawingData.saveImage(image: nsImage)
        }
        #endif
    }
}
