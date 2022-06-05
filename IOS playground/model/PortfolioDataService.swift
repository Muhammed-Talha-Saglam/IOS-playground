//
//  PortfolioDataService.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 4.05.2022.
//

import Foundation
import CoreData

// Core Data Manager Class

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading data: \(error)")
            }
            self.getPortfolio()
        }
    }
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching data: \(error)")
        }
    }
        
    func add() {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.counID = UUID().uuidString
        entity.amount = Double.random(in: 0...100)
        applyChanges()
    }
    
    func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    func remove(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving data: \(error)")
        }
    }
    
    func applyChanges() {
        save()
        getPortfolio()
    }
 }
