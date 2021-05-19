//
//  TranslationPersistenceManager.swift
//  Traductor
//
//  Created by Zara Davtyan on 12.05.21.
//  Copyright © 2021 Traductor. All rights reserved.
//

import UIKit
import CoreData

class TranslationPersistenceManager {

    let translationEntity = "TranslationItem"
    
    static let shared = TranslationPersistenceManager()
    
    private init() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Translation")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("persistent container error - \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch  {
                let nserror = error as NSError
                print("error while saving data to CoreData - \(nserror)")
            }
        }
    }
    
    func addTranslationItem(item: TranslationModel) {
        if checkIfItemExists(model: item) == true {
            return
        }
        
        if let translationEntity = NSEntityDescription.entity(forEntityName: translationEntity, in: persistentContainer.viewContext) {
            let translation = NSManagedObject(entity: translationEntity, insertInto: persistentContainer.viewContext)
            translation.setValue(item.original, forKey: "original")
            translation.setValue(item.translation, forKey: "translation")
            translation.setValue(item.isFavorite, forKey: "isFavorite")
            
           saveContext()
        }
    }
    
    private func checkIfItemExists(model: TranslationModel) -> Bool {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: translationEntity)
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@", argumentArray:["original", model.original, "translation", model.translation])
        
        var data = [NSManagedObject]()
        do {
            data = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if data.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func fetchTranslationItems() -> [TranslationModel] {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: translationEntity)
        var data = [NSManagedObject]()
        
        do {
            data = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        // parse dataItems
        var items = [TranslationModel]()
        for dataItem in data {
            guard let original = dataItem.value(forKey: "original") as? String else {
                return [TranslationModel]()
            }
            
            guard let translation = dataItem.value(forKey: "translation") as? String else {
                return [TranslationModel]()
            }
        
            guard let isFavorite = dataItem.value(forKey: "isFavorite") as? Bool else {
                return [TranslationModel]()
            }
            
            let item = TranslationModel(original: original, translation: translation, isFavorite: isFavorite)
            items.append(item)
        }
        return items
    }
    
    func setFavorite(model: TranslationModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: translationEntity)
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@", argumentArray:["original", model.original, "translation", model.translation])
        
        var data = [NSManagedObject]()
        do {
            data = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if let item = data.first {
            item.setValue(model.isFavorite, forKey: "isFavorite")
        } else {
            addTranslationItem(item: model)
        }
        
        saveContext()
        
    }
    
    
    func checkIfFavorite(model: TranslationModel) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: translationEntity)
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@", argumentArray:["original", model.original, "translation", model.translation])
        
        var data = [NSManagedObject]()
        do {
            data = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if let item = data.first, let isFavorite = item.value(forKey: "isFavorite") as? Bool {
            return isFavorite
        }
        
        return false
    }

    func removeItem(item: TranslationModel) -> Bool {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: translationEntity)
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@", argumentArray:["original", item.original, "translation", item.translation])
        
        var data = [NSManagedObject]()
        do {
            data = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        if let itemToDelete = data.first {
            persistentContainer.viewContext.delete(itemToDelete)
            saveContext()
            return true
        } else {
            return false
        }
    }

}
