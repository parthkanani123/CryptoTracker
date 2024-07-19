//
//  StatisticModel.swift
//  Crypto
//
//  Created by parth kanani on 09/07/24.
//

import Foundation

struct Statistic: Identifiable
{
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}

struct MockDataForStatistic
{
    static let sampleStat1 = Statistic(title: "Market Cap", value: "$12.58n", percentageChange: 25.34)
    static let sampleStat2 = Statistic(title: "Total Volume", value: "$1.23Tr")
    static let sampleStat3 = Statistic(title: "Portfolio", value: "$54.4k", percentageChange: -12.34)
}
