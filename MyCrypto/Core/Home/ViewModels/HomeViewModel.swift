//
//  HomeViewModel.swift
//  MyCrypto
//
//  Created by Marco on 2024-11-06.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portofolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let coinService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portofolioCoinsService = PortofolioCoinsService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest(coinService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portofolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] statistics in
                self?.statistics = statistics
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portofolioCoinsService.$savedEntities)
            .map { (coins, savedCoins) -> [Coin] in
                coins.compactMap { coin -> Coin? in
                    guard let entity = savedCoins.first(where: {$0.coinId == coin.id}) else {
                        return nil
                    }
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .sink { [weak self] returnedCoins in
                self?.portofolioCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    func updatePortofolio(coin: Coin, amount: Double) {
        portofolioCoinsService.updatePortofolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func mapGlobalMarketData(marketData: MarketData?, portofolioCoins: [Coin]) -> [Statistic] {
        var statistics: [Statistic] = []
        
        guard let data = marketData else {return statistics}
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        let profileValue = portofolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        let previousValue = portofolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((profileValue - previousValue) / previousValue)
        
        let profile = Statistic(title: "Profile", value: profileValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        statistics.append(contentsOf: [marketCap,volume,btcDominance,profile])
        
        return statistics
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        if text.isEmpty {return coins}
        
        let lowerCasedText = text.lowercased()
        
        return coins.filter {
            $0.name.lowercased().contains(lowerCasedText) ||
            $0.symbol.lowercased().contains(lowerCasedText) ||
            $0.id.lowercased().contains(lowerCasedText)
        }
    }
}
