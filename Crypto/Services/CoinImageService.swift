//
//  CoinImageService.swift
//  Crypto
//
//  Created by parth kanani on 07/07/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService
{
    @Published var image:UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let coin: Coin
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: Coin)
    {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage()
    {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            // print("Retrived image from file manager")
        }
        else {
            downloadCoinImage()
            // print("Downloading image now")
        }
    }
    
    private func downloadCoinImage()
    {
        guard let url = URL(string: coin.image) else {
            return
        }
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                NetworkManager.handleCompletion(completion: completion)
            }, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else {
                    return
                }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: imageName, folderName: folderName)
            })
    }
}
