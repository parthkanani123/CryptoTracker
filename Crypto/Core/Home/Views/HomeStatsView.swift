//
//  HomeStatsView.swift
//  Crypto
//
//  Created by parth kanani on 09/07/24.
//

import SwiftUI

struct HomeStatsView: View
{
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View
    {
        HStack
        {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, 
               alignment: showPortfolio ? .trailing : .leading
        )
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(true))
        .environmentObject(HomeViewModel())
}
