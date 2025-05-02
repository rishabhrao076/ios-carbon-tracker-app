//
//  OCRService.swift
//  carbonTracker
//
//  Created by Rishabh Rao on 30/04/25.
//

import Foundation

import UIKit
import Vision

class OCRService {
    static func recognizeText(in image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil) // Failed to get CGImage
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("❌ OCR error: \(error)")
                completion(nil) // Actual error during recognition
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil) // Failed to parse observations
                return
            }

            let recognizedText = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
                .trimmingCharacters(in: .whitespaces)


            // Return empty string if no text found, instead of nil
            completion(recognizedText)
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                print("❌ Failed to perform OCR: \(error)")
                completion(nil) // Critical error
            }
        }
    }
}
