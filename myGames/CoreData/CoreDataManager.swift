//
//  CoreDataManager.swift
//  myGames
//
//  Created by YILDIRIM on 23.01.2023.
//

import Foundation
import CoreData
import UIKit

enum EntityEnum{
    
    case mygames
    case notes
    
    var string : String {
        switch self {
        case .mygames:
            return "MyGames"
        case .notes:
            return "MyGamesNotes"
        }
    }
}

class CoreDataManager {

    public static var shared = CoreDataManager()

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Save to core data
    func saveToCoreData(dataID: Int,likedButton:Bool,comment:String, date:Date, entity: EntityEnum = .mygames) {
        let context = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: entity.string, in: context) {
        let listObject = NSManagedObject(entity: entity, insertInto: context)
          listObject.setValue(String(dataID), forKey: "id")
          listObject.setValue(likedButton, forKey: "like")
          listObject.setValue(comment, forKey: "commentText")
          listObject.setValue(date, forKey: "commentDate")
        do {
          try context.save()
            print("Saved successfully")
        } catch {
          print("ERROR while saving data to CoreData")
        }
      }
    }
    
    //Fetch
    func retrieveFromCoreData() -> [MyGames] {
       var idArr : [MyGames] = []
     let context = appDelegate.persistentContainer.viewContext
     
     let request = NSFetchRequest<MyGames>(entityName: "MyGames")
     
     do {
         let results = try context.fetch(request)
         if results.count > 0 {
                 idArr = results
         }
     } catch {
       print("ERROR while fetching data from CoreData")
     }
       return idArr
   }
    
    //Delete from coredata
     func deleteFromCoreData(dataID: Int){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyGames")
        let idString = String(dataID)
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        do {
        let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let id = result.value(forKey: "id")  {
                        
                        if id as! String == idString {
                            context.delete(result)
                            do {
                                try context.save()
                                
                            } catch {
                                print("error")
                            }
                            break
                        }
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    
    //Update
    func updateCoreData(_ dataID: Int,likedButton:Bool,comment:String,date:Date){
        
       let context = appDelegate.persistentContainer.viewContext
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyGames")
       let idString = String(dataID)
       fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
       fetchRequest.returnsObjectsAsFaults = false
       
       do {
       let results = try context.fetch(fetchRequest)
           if results.count > 0 {
               for result in results as! [NSManagedObject] {
                   if let id = result.value(forKey: "id")  {
                       if id as! String == idString {
                           
                           context.setValue(comment, forKey: "commentText")
                           context.setValue(date, forKey: "commentDate")
                           context.setValue(likedButton, forKey: "like")
                           do {
                               try context.save()
                               
                           } catch {
                               print("error")
                           }
                           break
                       }else {
                           print("no data")
                       }
                   }
               }
           }
       } catch {
           print("error")
       }
   } 
}
