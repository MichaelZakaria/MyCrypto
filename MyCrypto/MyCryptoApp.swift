//
//  MyCryptoApp.swift
//  MyCrypto
//
//  Created by Marco on 2024-10-29.
//

import SwiftUI

@main
struct MyCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                HomeView()
            }
            .environmentObject(vm)
        }
    }
}
