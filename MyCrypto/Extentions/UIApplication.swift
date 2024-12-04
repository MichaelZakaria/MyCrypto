//
//  UIApplication.swift
//  MyCrypto
//
//  Created by Micheal on 04/12/2024.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
