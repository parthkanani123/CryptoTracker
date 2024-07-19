//
//  SettingsView.swift
//  Crypto
//
//  Created by parth kanani on 17/07/24.
//

import SwiftUI

struct SettingsView: View 
{
    @Binding var showSettingsView: Bool
    @AppStorage("isDarkMode") private var isDarkMode = false
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let cryptoAppGithubURL = URL(string: "https://github.com/parthkanani123/CryptoTracker")!
    let personalGithubURL = URL(string: "https://github.com/parthkanani123")!
    
    var body: some View
    {
        NavigationStack
        {
            ZStack
            {
                // background
                Color.theme.background
                    .ignoresSafeArea()
   
                // content
                List
                {
                    changeModeSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    applicationSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    coinGeckoSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    developerSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showSettingsView.toggle()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundStyle(Color.theme.accent)
                    })
                }
            }
        }
    }
}

#Preview {
    SettingsView(showSettingsView: .constant(true))
}

extension SettingsView
{
    private var changeModeSection: some View
    {
        Section
        {
            VStack(alignment: .leading)
            {
                Toggle(isOn: $isDarkMode, label: {
                    Text("Dark Appearance")
                })
            }
            
        } header: {
            Text("Appearance")
        }
    }
    
    private var applicationSection: some View
    {
        Section
        {
            VStack(alignment: .leading)
            {
                Image("logo")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("Crpto Tracker App uses SwiftUI and is written in 100% in Swift. you can sort CoinList according price, rank and holding. You can edit your portfoliio. You can see detail of coin, adaptive in light and dark mode.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Visit Code 👨🏻‍💻", destination: cryptoAppGithubURL)
                .foregroundStyle(.blue)
        } header: {
            Text("about")
        }
    }
    
    private var coinGeckoSection: some View
    {
        Section
        {
            VStack(alignment: .leading)
            {
                Image("coingecko")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Visit CoinGecko 🦎", destination: coingeckoURL)
                .foregroundStyle(.blue)
        } header: {
            Text("Coin Gecko")
        }
    }
    
    private var developerSection: some View
    {
        Section
        {
            VStack(alignment: .leading)
            {
                Image("developerImage")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was developed by Parth Kanani.  By this project i learned more about publishers & subscribers, data persistance, MVVM Architecture, Combine and Core Data.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Visit My GitHub 🤙🏻", destination: personalGithubURL)
                .foregroundStyle(.blue)
        } header: {
            Text("Developer")
        }
    }
}
