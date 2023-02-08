//
//  TextRecoqnizerViewModel.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import Foundation
import Vision
import UIKit


class TextRecoqnizerViewModel: ObservableObject {
    @Published var captureImage: Bool = false
    @Published var isShowAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    @Published var recoqnizedExpression: String = ""
    @Published var image : UIImage?
    
    var request : VNRecognizeTextRequest!
    
    func handleImage(image: UIImage) {
        self.image = image
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        
        request = VNRecognizeTextRequest(completionHandler: recoqnizeBarcodeHandler)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation.up, options: [:])
            
            do {
                try handler.perform([self.request])
            } catch {
                self.showAlert(withTitle: "Error Decoding Barcode", message: error.localizedDescription)
            }
        }
    }
    
    func recoqnizeBarcodeHandler(request: VNRequest, error: Error?) {
        guard error == nil else {
            self.showAlert(withTitle: "Barcode Error", message: error!.localizedDescription)
            return
        }
        
        if let observations = request.results as? [VNRecognizedTextObservation] {
            
            let payload = observations.compactMap({ $0.topCandidates(1).first?.string }).joined(separator: "\n")
            filterExpressionFromPayload(text: payload)
            
        } else {
            self.showAlert(withTitle: "Unable to extract results",
                           message: "Cannot extract barcode information from data.")
        }
        
    }
    
    private func showInfo(for payload: String) {
        showAlert(withTitle: "code", message: payload)
    }
    
    private func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.alertTitle = title
            self?.alertMessage = message
            self?.isShowAlert = true
        }
    }
    
    func filterExpressionFromPayload(text: String) {
        if let match = text.lowercased().firstMatch(of: /([\d\.]+)([×÷\*\/x\-\+])([\d\.]+)/){
            print(match.0)
        }
    }
}
