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
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                HomeView()
            }
            .environmentObject(vm)
        }
    }
}
