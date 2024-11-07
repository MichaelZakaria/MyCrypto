//
//  CoinDataService.swift
//  MyCrypto
//
//  Created by Marco on 2024-11-06.
//

import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [Coin] = []
    
    var coinSubscribtion: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "x-cg-api-key": "CG-iKCS9F8eECLjAnWvZZBPi71C"
        ]
        
        coinSubscribtion = NetworkManager.download(request: request)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] returnedCoins in
                    self?.allCoins = returnedCoins
                    self?.coinSubscribtion?.cancel()
            })
    }
}
