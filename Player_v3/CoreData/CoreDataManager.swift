//
//  CoreDataManager.swift
//  Player_v3
//
//  Created by Gravman on 06.11.2019.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    func saveData(songName: String, isFavorite: Bool) {
        let context = CoreDataSingleton.shared.persistentContainer.viewContext
        
        let cont = NSEntityDescription.insertNewObject(forEntityName: "Songs", into: context)
        cont.setValue(songName, forKey: "songName")
        cont.setValue(isFavorite, forKey: "isFavorite")
        
        do {
            try context.save()
            
        } catch {
            print ("Error")
        }
    }
    
    func fetchData(songName: String, isFavorite: Bool) {
     
        let context = CoreDataSingleton.shared.persistentContainer.viewContext
        
        let cont: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Songs")
        cont.predicate = NSPredicate(format: "isFavorite")
        
        do {
            
           let cont1 = try context.fetch(cont)
            let favoriteUpdate = cont1[0] as! NSManagedObject
            favoriteUpdate.setValue("Favorite", forKey: "isFavorite")
            
            do {
                
                try context.save()
            
            } catch {
                
                print ("error")
            
            }
            
        } catch {
            
            print ("error")
            
        }
        
    }
}
