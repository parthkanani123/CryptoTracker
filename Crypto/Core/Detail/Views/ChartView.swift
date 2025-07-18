//
//  ChartView.swift
//  Crypto
//
//  Created by parth kanani on 16/07/24.
//

import SwiftUI

struct ChartView: View 
{
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: Coin) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChanege = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChanege > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60) // we are not getting startingDate from data, but we do know it is 7 days before endingDate. addingTimeInterval accepts seconds so we have passed seconds into it.
    }
    
    var body: some View
    {
        VStack
        {
            chartView
                .frame(height: 100)
                .background(chartBackground)
                .overlay (chartYAxis.padding(.horizontal, 4), alignment: .leading)
            
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

#Preview {
    ChartView(coin: MockDataForCoin.coin)
}

extension ChartView
{
    private var chartView: some View
    {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    
                    let xPosition = (geometry.size.width / CGFloat(data.count)) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    
                    // we do (1 -) because in phone (0,0) start from top left corner and end point is at bottom right cornor. but we want (0,0) on bottom left and end point at top right corner.
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    // start the path at the first data point.
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }
    }
    
    private var chartBackground: some View
    {
        VStack 
        {
            Divider()
            Spacer()
            
            Divider()
            Spacer()
            
            Divider()
        }
    }
    
    private var chartYAxis: some View
    {
        VStack
        {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View
    {
        HStack
        {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
