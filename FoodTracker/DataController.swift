//
//  DataController.swift
//  FoodTracker
//
//  Created by Elaine Reyes on 2/11/15.
//  Copyright (c) 2015 UlyssaElaine. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController{
    
    class func jsonUSDIdAndNameSearchResults (json: NSDictionary) -> [(name: String, idValue: String)]{
        
        var usdaItemsSearchResults:[(name: String, idValue: String)] = []
        var searchResult: (name: String, idValue: String)
        
        if json["hits"] != nil{
            let results:[AnyObject] = json["hits"]! as [AnyObject]
            
            for itemDictionary in results{
                
                if itemDictionary["_id"] != nil{
                    if itemDictionary["fields"] != nil{
                        let fieldsDictionary = itemDictionary["fields"] as NSDictionary
                        if fieldsDictionary["item_name"] != nil{
                            let idValue: String = itemDictionary["_id"]! as String
                            let name: String = fieldsDictionary["item_name"]! as String
                            searchResult = (name: name, idValue: idValue)
                            usdaItemsSearchResults += [searchResult]
                        }
                    }
                }
            }
        }
        
        return usdaItemsSearchResults
    }
    
    func saveUSDAItemForId(idValue: String, json: NSDictionary){
        
        if json["hits"] != nil {
            let results: [AnyObject] = json["hits"]! as [AnyObject]
            
            for itemDictionary in results {
                
                if itemDictionary["_id"] != nil && itemDictionary["_id"] as String == idValue{
                    
                    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
                    
                    var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
                    
                    let itemDictionaryId = itemDictionary["_id"]! as String
                    
                    let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)
                    requestForUSDAItem.predicate = predicate
                    
                    var error: NSError?
                    
                    var items = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
//                    var count = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
                    
                    if items?.count != 0{
                        //The item is already saved
                        println("The Item was already saved!")
                        return
                    }else{
                        println("Lets Save this to CoreData")
                        
                        let entityDescription = NSEntityDescription.entityForName("USDAItem",inManagedObjectContext:managedObjectContext!)
                        let usdaItem = USDAItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
                        usdaItem.idValue = itemDictionary["_id"]! as String
                        usdaItem.dateAdded = NSDate()
                        
                        if itemDictionary["fields"] != nil{
                            let fieldsDictionary = itemDictionary["fields"]! as NSDictionary
                            if fieldsDictionary["item_name"] != nil {
                                usdaItem.name = fieldsDictionary["item_name"]! as String
                            }
                            
                            if fieldsDictionary["usda_fields"] != nil {
                                let usdaFieldDictionary = fieldsDictionary["usda_fields"]! as NSDictionary
                                
                                if usdaFieldDictionary["CA"] != nil{
                                    let calciumDictionary = usdaFieldDictionary["CA"] as NSDictionary
                                    let calciumValue: AnyObject = calciumDictionary["value"]!
                                    usdaItem.calcium = "\(calciumValue)"
                                }else{
                                    usdaItem.calcium = "0"
                                }
                                
                                if usdaFieldDictionary["CHOCDF"] != nil{
                                    let carbohydrateDictionary = usdaFieldDictionary["CHOCDF"]! as NSDictionary
                                    if carbohydrateDictionary["value"] != nil{
                                        let carbohydrateValue: AnyObject = carbohydrateDictionary["value"]!
                                        usdaItem.carbohydrate = "\(carbohydrateValue)"
                                    }
                                }else{
                                    usdaItem.carbohydrate = "0"
                                }
                                
                                if usdaFieldDictionary["FAT"] != nil {
                                    let fatTotalDictionary = usdaFieldDictionary["Fat"]! as NSDictionary
                                    if fatTotalDictionary["value"] != nil{
                                        let fatTotalValue: AnyObject = fatTotalDictionary["value"]!
                                        usdaItem.fatTotal = "\(fatTotalValue)"
                                    }
                                }else{
                                    usdaItem.fatTotal = "0"
                                }
                                
                                if usdaFieldDictionary["CHOLE"] != nil {
                                    let cholesterolDictionary = usdaFieldDictionary["CHOLE"]! as NSDictionary
                                    if cholesterolDictionary["value"] != nil{
                                        let cholesterolValue: AnyObject = cholesterolDictionary["value"]!
                                        usdaItem.cholesterol = "\(cholesterolValue)"
                                    }
                                }else{
                                    usdaItem.cholesterol = "0"
                                }
                                
                                if usdaFieldDictionary["PROCNT"] != nil {
                                    let proteinDictionary = usdaFieldDictionary["PROCNT"]! as NSDictionary
                                    if proteinDictionary["value"] != nil{
                                        let proteinValue: AnyObject = proteinDictionary["value"]!
                                        usdaItem.protein = "\(proteinValue)"
                                    }
                                }else{
                                    usdaItem.protein = "0"
                                }
                                
                                if usdaFieldDictionary["SUGAR"] != nil {
                                    let sugarDictionary = usdaFieldDictionary["SUGAR"]! as NSDictionary
                                    if sugarDictionary["value"] != nil{
                                        let sugarValue: AnyObject = sugarDictionary["value"]!
                                        usdaItem.sugar = "\(sugarValue)"
                                    }
                                }else{
                                    usdaItem.sugar = "0"
                                }
                                
                                if usdaFieldDictionary["VITC"] != nil {
                                    let vitaminCDictionary = usdaFieldDictionary["VITC"]! as NSDictionary
                                    if vitaminCDictionary["value"] != nil{
                                        let vitaminCValue: AnyObject = vitaminCDictionary["value"]!
                                        usdaItem.vitaminC = "\(vitaminCValue)"
                                    }
                                }else{
                                    usdaItem.vitaminC = "0"
                                }
                                
                                if usdaFieldDictionary["ENERC_KCAL"] != nil {
                                    let energyDictionary = usdaFieldDictionary["ENERC_KCAL"]! as NSDictionary
                                    if energyDictionary["value"] != nil{
                                        let energyValue: AnyObject = energyDictionary["value"]!
                                        usdaItem.energy = "\(energyValue)"
                                    }
                                }else{
                                    usdaItem.energy = "0"
                                }
                                
                                (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
                            }
                        }
                    }
                }
                
            }
        }
        
    }
    
}