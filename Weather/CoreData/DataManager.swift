//
//  DataManager.swift
//  Weather
//
//  Created by Арсений Кухарев on 02.09.2023.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GeoModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func delete<T>(_ object: T) {
        let context = persistentContainer.viewContext
        guard let object = object as? NSManagedObject else {return}
   
        context.delete(object)
        saveContext()
    }
    
    
    //MARK: - Create Entity
    func createGeoEntity(geo: GeoResponce) {
        let entity = GeoResponceCD(context: persistentContainer.viewContext)
        entity.nameOfLocation = geo.nameOfLocation
        entity.state = geo.state
        entity.lon = geo.lon
        entity.lat = geo.lat
        entity.country = geo.country
        saveContext()
    }
    
    
    // MARK: - Fetch Entity
    func fetchSavedCities() -> [GeoResponce] {
        let request: NSFetchRequest<GeoResponceCD> = GeoResponceCD.fetchRequest()
        var geoEntities: [GeoResponceCD] = []
        
        do {
           try geoEntities = persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Не удалось fetch from CD 😢 \n \(error)")
        }
        
        var geoResponces: [GeoResponce] = geoConverter(geoEntities: geoEntities)
        return geoResponces
    }
    
    private func geoConverter(geoEntities: [GeoResponceCD]) -> [GeoResponce] {
        var geoResponces: [GeoResponce] = []
        
        for entity in geoEntities {
            let geo = GeoResponce(nameOfLocation: entity.nameOfLocation,
                                  localizedNames: nil,
                                  lat: entity.lat, lon: entity.lon,
                                  country: entity.country,
                                  state: entity.state)
            geoResponces.append(geo)
        }
        return geoResponces
    }
    
    
}
