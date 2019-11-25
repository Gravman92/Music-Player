//
//  CoreDataManager.swift
//  Player_v3
//
//  Created by Gravman on 9/7/19.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import Foundation
import CoreData


class CoreDataSingleton {
    
    static let shared = CoreDataSingleton()
    
    let persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Player")
        
        container.loadPersistentStores(completionHandler: { (storePersist, error) in
            if let error = error {
                fatalError("store failed with \(error)")
            }
          
        })
          return container
    }()
    
}
