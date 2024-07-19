//
//  HomeView.swift
//  Crypto
//
//  Created by parth kanani on 04/07/24.
//

import SwiftUI

struct HomeView: View 
{
    @EnvironmentObject private var vm: HomeViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showPortfolio: Bool = false // animate right
    @State private var showPortfolioView: Bool = false // new sheet
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView: Bool = false
    @State private var showSettingsView: Bool = false
    
    var body: some View
    {
        ZStack
        {
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .fullScreenCover(isPresented: $showPortfolioView, content: {
                    PortfolioView(showPortfolioView: $showPortfolioView)
                        .environmentObject(vm)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                })
            
            //content layer
            VStack
            {
                homeHeader
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                columnTitle
                
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    ZStack(alignment: .top)
                    {
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                            portfolioEmptyText
                        }
                        else {
                            portfolioCoinsList
                                .transition(.move(edge: .trailing))
                        }
                    }
                }
                
                Spacer()
            }
            .fullScreenCover(isPresented: $showSettingsView, content: {
                SettingsView(showSettingsView: $showSettingsView)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            })
        }
        .navigationDestination(isPresented: $showDetailView) {
            detailLoadingView(coin: $selectedCoin, showDetailView: $showDetailView)
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}

extension HomeView 
{
    private var homeHeader: some View 
    {
        HStack
        {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: UUID())
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                    else {
                        showSettingsView.toggle()
                    }
                }
                .background {
                    CircleButtonAnimationView(animate: $showPortfolio)
                }
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(.none, value: UUID())
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View
    {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin,
                            showHoldingsColumn: false)
                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                .onTapGesture {
                    segue(coin: coin)
                }
                .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList: some View 
    {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin,
                            showHoldingsColumn: true)
                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                .onTapGesture {
                    segue(coin: coin)
                }
                .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioEmptyText: some View
    {
        Text("You have not addded any coins to your portfolio yet. Clik the + button to get started! 🧐")
            .font(.callout)
            .foregroundStyle(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    private func segue(coin: Coin)
    {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columnTitle: some View 
    {
        HStack 
        {
            HStack(spacing: 4)
            {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            if showPortfolio {
                
                HStack(spacing: 4)
                {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            
            HStack(spacing: 4)
            {
                Text("Price")
                    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed: .price
                }
            }
            
            Button(action: {
                withAnimation(.linear(duration: 2)) {
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0))
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
