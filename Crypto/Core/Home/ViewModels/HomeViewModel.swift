//
//  HomeViewModel.swift
//  Crypto
//
//  Created by parth kanani on 06/07/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject
{
    @Published var statistics: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: sortOptions = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    enum sortOptions {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubcribers()
    }
    
    func addSubcribers() 
    {
    
        // updates allCoins 
        /* Anytime searchText or allCoins changes, we are going to update filtercoins and than we get that returnedCoins and set self?.allCoins = returnedCoins */
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) /* this timer is starts when the value published and wait for 0.5 second than allow to run line of code below debounce. so if i type one character in textfield than it wait for 0.5 seconds and in that 0.5 second if i again type another character than timer start again and wait for 0.5 seconds. when it does not get any published value for 0.5 seconds interval than and than only debounce allow lines of code bellow it to run */
            .map(filterAndSortCoins) // we are not passing the parameters in the filterCoins because they are exactly same as we are getting from subscribers
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        // updates portfolioCoins
        $allCoins /* we can also write here  coinDataService.$allCoins. but it can't show portfolioCoins according to searchText. but if we use $allCoins then it is filtered array with search */
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else {
                    return
                }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // updates marketdata
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map({ (marketData, portfolioCoins) -> [Statistic] in
                self.mapGlobalData(data: marketData, portfolioCoins: portfolioCoins)
            })
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData()
    {
        isLoading = true 
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success) // vibration
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin], sort: sortOptions) -> [Coin]
    {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoin(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin]
    {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        let filterdCoins = coins.filter { coin in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
        
        return filterdCoins
    }
    
    private func sortCoin(sort: sortOptions, coins: inout [Coin])
    {
        // inout -> to make sort inplace / pass by reference. for returning new array use funtion sorted(by: ) & for do sorting inplace use sort(by: )
        switch sort {
        case .rank:
             coins.sort { coin1, coin2 in
                 coin1.rank < coin2.rank
            }
        case .rankReversed:
             coins.sort(by: {$0.rank > $1.rank})
        case .price:
             coins.sort(by: {$0.currentPrice < $1.currentPrice})
        case .priceReversed:
             coins.sort(by: {$0.currentPrice > $1.currentPrice})
        default:
            return
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin]
    {
        // will only sort by holdings or holdingsReversed if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioEntities: [PortfolioEntity]) -> [Coin]
    {
        allCoins
            .compactMap { (coin) -> Coin? in
            guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else {
                return nil // we dont have this coin in our portfolio
            }
            
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalData(data: MarketData?, portfolioCoins: [Coin]) -> [Statistic]
    {
        var stats: [Statistic] = []
        
        guard let data = data else {
            return stats
        }
        
        let marketCap = Statistic(title: "MarketCap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue =
        portfolioCoins
            .map({ $0.currentHoldingsValue})
            .reduce(0, +) // sum of all the currentHoldingsValue
        
        
        /*
         - let's say previousValue is 100 and 10% increase than currentValue is 110
         - now we are trying to get previous value from currentValue
         - previousValue = currentValue / (1 + percentChange)
                         = 110 / (1 + 0.1)
                         = 100
         */
        let previousValue =
        portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100  // 25 -> 0.25
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +) // sum of all the previousValue
        
        /*
         - let's say portfolioValue is 110 and previousValue is 100 than we are trying to get percentageChange which is 10%
         - percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
                            = ((110 - 100) / 100) * 100
                            = (10 / 100 ) * 100
                            = 0.1 * 100
         */
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
}
