//
//  DismissButton.swift
//  MyCrypto
//
//  Created by Micheal on 05/12/2024.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
        }
    }
}

#Preview {
    DismissButton()
}
