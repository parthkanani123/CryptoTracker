//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by parth kanani on 12/07/24.
//

import Foundation
import CoreData

class PortfolioDataService
{
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() 
    {
        container = NSPersistentContainer(name: containerName)
        
        // Loads all the data from the container
        container.loadPersistentStores { (_, error) in
            if let error {
                print("DEBUG: Error loading Core Data. \(error)")
            }
        }
        
        self.getPortfolio()
    }
    
    // MARK: - Public
    
    func updatePortfolio(coin: Coin, amount: Double)
    {
        // we can also write below thing as
        /*
        if let entity = savedEntities.first(where: { savedEntity in
            return savedEntity.coinID == coin.id
        }) {
            
        }*/
        
        // check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                // our amount is never be less than 0 but if it's zero so we are deleting it.
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: - Private
    
    private func getPortfolio()
    {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("DEBUG: Error fetching Portfolio Entities. \(error)")
        }
    }
    
    private func add(coin: Coin, amount: Double)
    {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    // if we already have entity than we are not going to create new one to change amount
    private func update(entity: PortfolioEntity, amount: Double)
    {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity)
    {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save()
    {
        do {
            try container.viewContext.save()
        } catch let error {
            print("DEBUG: Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges()
    {
        save()
        
        /* after creating new enitity or updating entity or deleting entity we have to update savedEntities array. so let's say there are thousands of coin then appending newEntity to savedEntities array is efficient but for our purpose there are not that many number of coin so we are refetching the entities. */
        getPortfolio()
    }
}
