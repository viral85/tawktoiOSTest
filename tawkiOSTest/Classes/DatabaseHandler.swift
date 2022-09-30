//
//  DatabaseHandler.swift
//  tawkiOSTest
//
//  Created by Apple on 24/09/22.
//

import Foundation
import UIKit
import CoreData


class DatabaseHandler {
    
    let viewContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GithubUser")
    
    /// Get CoreData Object
    func getNewManageObject() -> NSManagedObject{
        let entity = NSEntityDescription.entity(forEntityName: "GithubUser", in: viewContext)!
        return NSManagedObject(entity: entity, insertInto: viewContext)
    }
    
    /// Save CoreData Object
    func save() {
        do {
            try viewContext.save() }
        catch {
            print(error.localizedDescription)
        }
    }
    
    /// Fetch All Data
    func fetchData() -> [NSManagedObject]{
      
        let request =  DatabaseHandler().request
        let managedContext = viewContext
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(request)
            return result as! [NSManagedObject]
        } catch {
            print("Couldn't fetch data")
        }
        
        return [NSManagedObject]()
    }
    
    /// Fetch Data from ID
    func fetchDataFromID(idValue: Int) -> NSManagedObject{
            let request = DatabaseHandler().request
            request.predicate = NSPredicate(format: "id = %d", idValue)

            let managedContext = viewContext
            request.returnsObjectsAsFaults = false
            do {
                let result = try managedContext.fetch(request) as? [NSManagedObject]
                if result?.count ?? 0 > 0{
                    return (result?[0])!
                }else{
                    return NSManagedObject()
                }
            } catch {
                print("Couldn't fetch data")
            }
        return NSManagedObject()
    }
}
