//
//  SearchBarView.swift
//  MyCrypto
//
//  Created by Micheal on 04/12/2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(searchText.isEmpty ? .secondaryText : .accent)
            
            TextField("Search...", text: $searchText)
                .foregroundStyle(.accent)
                .autocorrectionDisabled(true)
                .overlay(alignment: .trailing) {
                    Image(systemName: "x.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                            UIApplication.shared.endEditing()
                        }
                }
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(Color.theme.background)
                .shadow(color: .accent.opacity(0.2), radius: 10)
        )
        .padding()
    }
}

#Preview (traits: .sizeThatFitsLayout) {
    SearchBarView(searchText: .constant(""))
}
