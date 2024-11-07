//
//  CoinImageService.swift
//  MyCrypto
//
//  Created by Marco on 2024-11-07.
//

import Foundation
import Combine
import UIKit

class CoinImageService {
    @Published var coinImage: UIImage? = nil
    
    private var imageSubscribtion: AnyCancellable?
    private let coin: Coin
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let coinName: String
    
    init(coin: Coin) {
        self.coin = coin
        coinName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedCoinImage = fileManager.getImage(folderName: folderName, imageName: coinName) {
            coinImage = savedCoinImage
        } else {
            downloadCoinImage(coin: coin)
        }
    }
    
    private func downloadCoinImage(coin: Coin) {
        guard let url = URL(string: coin.image) else {return}
        
        let request = URLRequest(url: url)
        
        imageSubscribtion = NetworkManager.download(request: request)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] returnedImage in
                    guard let self = self,
                          let downloadedImage = returnedImage else {return}
                    self.coinImage = downloadedImage
                    self.imageSubscribtion?.cancel()
                    self.fileManager.saveImage(image: downloadedImage, folderName: self.folderName, imageName: self.coinName)
            })
    }
    
}
