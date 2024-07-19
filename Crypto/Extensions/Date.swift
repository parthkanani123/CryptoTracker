//
//  Date.swift
//  Crypto
//
//  Created by parth kanani on 16/07/24.
//

import Foundation

extension Date
{
    // "2021-03-13T20:49:26.606Z"
    // we are converting above string into Date object
    init(coinGeckoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGeckoString) ?? Date() // if can't get date than we use today's date
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String
    {
        return shortFormatter.string(from: self)
    }
}
