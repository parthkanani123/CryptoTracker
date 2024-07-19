//
//  MarketDataService.swift
//  Crypto
//
//  Created by parth kanani on 09/07/24.
//

import Foundation
import Combine

class MarketDataService
{
    @Published var marketData: MarketData? = nil
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData()
    {
        guard let url =  URL(string: "https://api.coingecko.com/api/v3/global") else {
            return
        }
        
        marketDataSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                NetworkManager.handleCompletion(completion: completion)
            }, receiveValue: { [weak self] returnGlobalData in
                self?.marketData = returnGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
