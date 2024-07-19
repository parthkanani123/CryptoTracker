//
//  PortfolioView.swift
//  Crypto
//
//  Created by parth kanani on 10/07/24.
//

import SwiftUI

struct PortfolioView: View 
{
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolioView: Bool
    @State private var selectedCoin: Coin? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    
    var body: some View
    {
        NavigationStack
        {
            ScrollView
            {
                VStack(alignment: .leading, spacing: 0)
                {
                    SearchBarView(searchText: $vm.searchText)
                    
                    coinLogoList
                    
                    if selectedCoin != nil 
                    {
                        portfolioInputSection
                    }
                }
            }
            .background(
                Color.theme.background
                    .ignoresSafeArea()
            )
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showPortfolioView.toggle()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    trailingToolBarButtons
                }
            }
            .onChange(of: vm.searchText, initial: true) { oldValue, newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

#Preview {
    PortfolioView(showPortfolioView: .constant(false))
        .environmentObject(HomeViewModel())
}

extension PortfolioView
{
    private var coinLogoList: some View {
        ScrollView(.horizontal)
        {
            LazyHStack(spacing: 10)
            {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelcetedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ?
                                        Color.theme.green : Color.clear,
                                        lineWidth: 1.0)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
        .scrollIndicators(.hidden)
    }
    
    private func updateSelcetedCoin(coin: Coin)
    {
        selectedCoin = coin
        
        // if selectedCoin is inside portfolioCoins than we want to show currentHoldings of selected coin in textfield
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id}) {
            if let amount = portfolioCoin.currentHoldings {
                quantityText = "\(amount)"
            }
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double
    {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        
        return 0
    }
    
    private var portfolioInputSection: some View
    {
        VStack(spacing: 20)
        {
            HStack
            {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()
            
            HStack
            {
                Text("Amount holding")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack
            {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .font(.headline)
        .animation(.none, value: UUID())
        .padding()
    }
    
    private var trailingToolBarButtons: some View
    {
        HStack(spacing: 10)
        {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("save".uppercased())
            })
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
            )
        }
        .font(.headline)
    }
    
    private func saveButtonPressed()
    {
        guard let coin = selectedCoin, let amount = Double(quantityText) else {
            return
        }
        
        // save to portfoilo
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // show checkmark
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectedCoin()
    {
        selectedCoin = nil
        vm.searchText = ""
    }
}
