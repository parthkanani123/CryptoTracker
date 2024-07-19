//
//  NetworkManager.swift
//  Crypto
//
//  Created by parth kanani on 07/07/24.
//

import Foundation
import Combine

class NetworkManager
{
    enum NetworkError: LocalizedError
    {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL \(url)"
            case .unknown: return "[⚠️] Unknown error occoured"
            }
        }
    }
    
    /*
     - we are going to return publisher.
     - by storing URLSession into temp and then option click on temp, we can find the type of publisher which is Publishers.ReceiveOn<Publishers.TryMap<Publishers.SubscribeOn<URLSession.DataTaskPublisher, DispatchQueue>, Data>, DispatchQueue>
     - but this looks messy, so we convert the type into AnyPublisher<Data, any Error> by .eraseToAnyPublisher() and return that.
     
     */
    static func download(url: URL) -> AnyPublisher<Data, any Error>
    {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({
                try handleURLResponse(output: $0, url: url)
            })
            .retry(3) // it is going to retry 3 times, if publisher failed like bad response from publisher
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data
    {
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.badURLResponse(url: url)
        }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<any Publishers.Decode<AnyPublisher<Data, any Error>, [Coin], JSONDecoder>.Failure>) 
    {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
