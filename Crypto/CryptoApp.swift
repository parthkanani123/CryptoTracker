//
//  CryptoApp.swift
//  Crypto
//
//  Created by parth kanani on 04/07/24.
//

import SwiftUI

@main
struct CryptoApp: App 
{
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = true
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    init() {

        // color of navigationstack title
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        
        // in detailView back button color does not change according to background for that we have write below line.
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        
        // all the list derived from UITableView, so our list is not adapting backgroundColor, for that we have write below line.
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene
    {
        WindowGroup 
        {
            ZStack
            {
                NavigationStack {
                    HomeView()
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                        .toolbar(.hidden)
                }
                .environmentObject(vm)
                
                ZStack
                {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
