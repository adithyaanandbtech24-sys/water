import SwiftUI
import UIKit


class DrawingData: ObservableObject {
    @Published var savedImage: UIImage?
    
    private let fileName = "hita_pet_v5.png"
    
    init() {
        self.savedImage = loadImage()
    }
    
    func saveImage(image: UIImage) {
        if let data = image.pngData() {
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            try? data.write(to: url)
            self.savedImage = image
            
            // Allow views to update immediately
            objectWillChange.send()
        }
    }
    
    func loadImage() -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
