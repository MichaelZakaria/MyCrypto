//
//  MarketDataService.swift
//  MyCrypto
//
//  Created by Micheal on 05/12/2024.
//

import Foundation
import Combine

class MarketDataService {
    @Published var marketData: MarketData? = nil
    
    var marketDataSubscribtion: AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json"
        ]
        
        marketDataSubscribtion = NetworkManager.download(request: request)
            .decode(type: MarketDataResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] marketDataResponse in
                    self?.marketData = marketDataResponse.data
                    self?.marketDataSubscribtion?.cancel()
            })
    }
}
