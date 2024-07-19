//
//  CoinRowView.swift
//  Crypto
//
//  Created by parth kanani on 05/07/24.
//

import SwiftUI

struct CoinRowView: View 
{
    let coin: Coin
    let showHoldingsColumn: Bool
    
    var body: some View
    {
        HStack(spacing: 0)
        {
            leftColumn
            
            Spacer()
            
            if showHoldingsColumn
            {
                centerColumn
            }
            
            rightColumn
        }
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.001) // we are clicking on the coinRowView to navigate to detailView. but if we click on center we can't navigate because of spacer. so thats we have add background here.
        )
    }
}

#Preview {
    CoinRowView(coin: MockDataForCoin.coin, showHoldingsColumn: true)
}

extension CoinRowView
{
    private var leftColumn: some View 
    {
        HStack(spacing: 0)
        {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View
    {
        VStack(alignment: .trailing)
        {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var rightColumn: some View
    {
        VStack(alignment: .trailing)
        {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "0%")
                .foregroundStyle(
                    (coin.priceChange24H ?? 0) >= 0 ?
                    Color.theme.green :
                    Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
