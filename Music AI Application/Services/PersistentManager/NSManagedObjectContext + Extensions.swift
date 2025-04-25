//
//  NSManagedObjectContext + Extensions.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 08.03.2025.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveContext() {
        if self.hasChanges {
            do {
                try self.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
