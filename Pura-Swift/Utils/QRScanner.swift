//
//  QRScanner.swift
//  Pura-Swift
//
//  Created by Rama Eka Hartono on 04/03/25.
//
import Foundation
func extractKode(from urlString: String) -> String? {
    guard let url = URL(string: urlString) else { return nil }
    let pathComponents = url.pathComponents
    if let kodeIndex = pathComponents.firstIndex(of: "kode"), kodeIndex + 1 < pathComponents.count {
        return pathComponents[kodeIndex + 1]
    }
    return nil
}
