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

    /**
     Удаляет объект из CD
     - Important: Перед удалением UI объекта, его нужно конвертировать в CD объект
     */
    func delete<T>(_ object: T) {
        let context = persistentContainer.viewContext
        guard let object = object as? NSManagedObject else {return}
   
        context.delete(object)
        saveContext()
    }
    
    
    //MARK: - Create Entity
    /// Создает объект  CD идентичный указанному GeoResponce и сохраняет его
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
    /**
     Достаёт из CD все сохраненные объекты и конвертирует в UI объекты
     - Returns: Массив GeoResponce
     */
    func fetchSavedCities() -> [GeoResponce] {
        let request: NSFetchRequest<GeoResponceCD> = GeoResponceCD.fetchRequest()
        var entities: [GeoResponceCD] = []
        
        do {
           try entities = persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Не удалось fetch from CD 😢 \n \(error)")
        }
        
        let geoResponces: [GeoResponce] = geoConverter(geoEntities: entities)
        return geoResponces
    }
    
    
    func fetch(_ completionHandler: ([GeoResponce]) -> Void) {
        let request: NSFetchRequest<GeoResponceCD> = GeoResponceCD.fetchRequest()
        var entities: [GeoResponceCD] = []
        
        do {
           try entities = persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Не удалось fetch from CD 😢 \n \(error)")
        }
        
        let geoResponces: [GeoResponce] = geoConverter(geoEntities: entities)
        completionHandler(geoResponces)
    }
    
    
    /**
     Возвращает CD объект для указанного GeoResponce
     - Parameter geo: Объект который нужно найти в CD
     - Returns: CD объект для изменения или удаления
     - Note: т.к. UI не работает с моделями из CD, то нужно вручную конвертировать объекты из UI в CD
     */
    func convertAndFetch(geo: GeoResponce) -> GeoResponceCD {
        let request: NSFetchRequest<GeoResponceCD> = GeoResponceCD.fetchRequest()
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "lat == %@", NSNumber(floatLiteral: geo.lat)),
            NSPredicate(format: "lon == %@", NSNumber(floatLiteral: geo.lon))
        ])
        request.predicate = predicate
        
        var entities: [GeoResponceCD] = []
        do {
            entities = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Не удалось fetch from CD 😢 \n \(error)")
        }
        
        return entities.first!
    }
    
 
    
    // Индекс сделать от таблицы! tableview.row для последующего изменения порядка
    
    
    // MARK: - Work with isFirstToShow Flag
    /// Удаляет флаг в сохрананнёный объектах
    public func removeIsFirstToShowFlag() {
        let entities = fetchIsFirstToShowArray()
        entities.forEach { $0.isFirstToShow = false }
        saveContext()
    }
    
    /// Устанавливает флаг для указанного GeoResponce
    public func setIsFirstToShowFlag(geo: GeoResponce) {
        let entity = convertAndFetch(geo: geo)
        entity.isFirstToShow = true
        saveContext()
    }
    
    /**
     Возвращает GeoResponce города который был выбран для показа
     - Returns: Если есть сохранённых город с флагом, вернет его.
     Если нет (например выбрали город для показа и удалили его не выбрав другой), то вернет первый в списке сохранённых
     */
    public func fetchFirstToShow() -> GeoResponce {
        let entities = fetchIsFirstToShowArray()
        let geoArray = geoConverter(geoEntities: entities)
     
        // Нашли город с флагом
        if let geo = geoArray.first {
            return geo
            
            // Не нашли город с флагом
        } else {
            let geo = fetchSavedCities()
            return geo.first!
        }
    }
    
    /// Возвращает массив объектов CD с флагом isFirstToShow
    private func fetchIsFirstToShowArray() -> [GeoResponceCD] {
        let request: NSFetchRequest<GeoResponceCD> = GeoResponceCD.fetchRequest()
        let predicate = NSPredicate(format: "isFirstToShow == true")
        request.predicate = predicate
        
        var entities: [GeoResponceCD] = []
        do {
            entities = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Не удалось fetch from CD 😢 \n \(error)")
        }
        return entities
    }
    
    
    // MARK: - Converter
    /**
     Возвращает массив GeoResponce для указанного массива объектов CD
     - Parameter geoEntities: Массив объектов CD который нужно конвертировать
     - Returns: Массив объектов GeoResponce
     - Note: т.к. UI не работает с моделями из CD, то нужно вручную конвертировать объекты из CD в UI
     */
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
