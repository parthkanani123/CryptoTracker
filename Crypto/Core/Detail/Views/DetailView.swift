//
//  DetailView.swift
//  Crypto
//
//  Created by parth kanani on 15/07/24.
//

import SwiftUI


struct detailLoadingView: View 
{
    @Binding var coin: Coin?
    @Binding var showDetailView: Bool
    
    var body: some View
    {
        ZStack
        {
            if let coin = coin {
                DetailView(coin: coin, showDetailView: $showDetailView)
            }
        }
    }
}

struct DetailView: View 
{
    @StateObject private var vm: DetailViewModel
    @State private var showFullDescription: Bool = false
    @Binding var showDetailView: Bool
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let spacing: CGFloat = 30
    
    init(coin: Coin, showDetailView: Binding<Bool>) {
        _showDetailView = showDetailView
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View
    {
        ScrollView
        {
            VStack
            {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20)
                {
                    overViewTitle
                    
                    Divider()
                    
                    descriptionSection
                    
                    overViewGrid
                    
                    additionalTitle
                    
                    Divider()
                    
                    additionalGrid
                    
                    websiteSection
                }
                .padding()
            }
        }
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
        .navigationTitle(vm.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    showDetailView.toggle()
                }, label: {
                    HStack(spacing: 5)
                    {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.body)
                    .foregroundStyle(Color.theme.accent)
                })
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: MockDataForCoin.coin, showDetailView: .constant(true))
    }
}

extension DetailView
{
    private var navigationBarTrailingItems: some View
    {
        HStack
        {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overViewTitle: some View
    {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View
    {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View
    {
        ZStack
        {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                
                VStack(alignment: .leading)
                {
                    Text(coinDescription)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                        .lineLimit(showFullDescription ? nil : 3)
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    })
                    .foregroundStyle(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var overViewGrid: some View
    {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            
            ForEach(vm.overViewStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
        
    }
    
    private var additionalGrid: some View
    {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
    }
    
    private var websiteSection: some View 
    {
        VStack(alignment: .leading, spacing: 20)
        {
            if let websiteString = vm.websiteURL, let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            
            if let redditString = vm.redditURL, let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
        }
        .tint(.blue)
        .font(.headline)
        .frame(maxWidth: .infinity,alignment: .leading)
    }
}
