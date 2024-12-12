//
//  PotofolioCoinsService.swift
//  MyCrypto
//
//  Created by Micheal on 05/12/2024.
//

import CoreData

class PortofolioCoinsService {
    let container: NSPersistentContainer
    let containerName: String = "PortofolioCoin"
    let entityName: String = "PortofolioCoin"
    
    @Published var savedEntities: [PortofolioCoin] = []
    
    init() {
        self.container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading core data \(error.localizedDescription)")
            }
            self.getPortofolio()
        }
    }
    
    func updatePortofolio(coin: Coin, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity, amount: amount)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    private func getPortofolio() {
        let request = NSFetchRequest<PortofolioCoin>(entityName: entityName)
        
        do {
            savedEntities =  try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portofolio entities \(error)")
        }
    }
    
    func add(coin: Coin, amount: Double) {
        let entity = PortofolioCoin(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        
        applyChanges()
    }
    
    func update(entity: PortofolioCoin, amount: Double) {
        entity.amount = amount
        
        applyChanges()
    }
    
    func delete(entity: PortofolioCoin, amount: Double) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving core data \(error)")
        }
    }
    
    func applyChanges() {
        save()
        getPortofolio()
    }
    
}
