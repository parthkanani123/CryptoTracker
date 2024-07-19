//
//  StatisticView.swift
//  Crypto
//
//  Created by parth kanani on 09/07/24.
//

import SwiftUI

struct StatisticView: View 
{
    let stat: Statistic
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 4)
        {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            HStack(spacing: 4)
            {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180 )
                    )
                
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0 : 1)
        }
    }
}

#Preview {
    StatisticView(stat: MockDataForStatistic.sampleStat1)
}
