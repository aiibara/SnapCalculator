//
//  TextRecognizerViewModel.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import Foundation
import Vision
import UIKit


class TextRecognizerViewModel: ObservableObject {
    @Published var recognizedExpression: String = ""
    @Published var image : UIImage?
    
    var request : VNRecognizeTextRequest!
    
    init() {
        request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
    }
    
    func handleImage(image: UIImage) {
        self.image = image
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation.up, options: [:])
            
            do {
                try handler.perform([self.request])
            } catch {
                return
            }
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard error == nil else {
            return
        }
        
        if let observations = request.results as? [VNRecognizedTextObservation] {

            let payload = observations.compactMap({ $0.topCandidates(1).first?.string }).joined(separator: "\n")
            
            if !payload.isEmpty {
                print("payload,", payload)
            }
            
            guard let matchString = filterExpressionFromPayload(text: payload) else {
                return
            }
            
            DispatchQueue.main.async {
                self.recognizedExpression = String(matchString)
            }
        } else {
            return
        }
    }
    
    func filterExpressionFromPayload(text: String) -> String? {
        if let match = text.lowercased().firstMatch(of: /([\d\.]+)([×÷\*\/x\-\+:])([\d\.]+)/)  {
            return String(match.0)
        } else {
            return nil
        }
    }
}
