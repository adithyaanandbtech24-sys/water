import SwiftUI

#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif

class DrawingData: ObservableObject {
    @Published var savedImage: PlatformImage?
    
    private let fileName = "hita_pet_v5.png"
    
    init() {
        self.savedImage = loadImage()
    }
    
    func saveImage(image: PlatformImage) {
        var data: Data?
        
        #if canImport(UIKit)
        data = image.pngData()
        #elseif canImport(AppKit)
        if let tiff = image.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: tiff) {
            data = bitmap.representation(using: .png, properties: [:])
        }
        #endif
        
        if let data = data {
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            try? data.write(to: url)
            self.savedImage = image
            
            // Allow views to update immediately
            objectWillChange.send()
        }
    }
    
    func loadImage() -> PlatformImage? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        if let data = try? Data(contentsOf: url) {
            return PlatformImage(data: data)
        }
        return nil
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
