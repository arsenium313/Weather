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
    
    private func saveContext () {
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
    public func delete<T>(_ object: T) {
        let context = persistentContainer.viewContext
        guard let object = object as? NSManagedObject else {return}
   
        context.delete(object)
        saveContext()
    }
    
    
    //MARK: - Create Entity
    /// Создает объект  CD идентичный указанному GeoResponce и сохраняет его
    public func createGeoEntity(geo: GeoResponce, index: Int) {
        let entity = GeoResponceCD(context: persistentContainer.viewContext)
        entity.nameOfLocation = geo.nameOfLocation
        entity.state = geo.state
        entity.lon = geo.lon
        entity.lat = geo.lat
        entity.country = geo.country
        entity.index = Int16(index)
        saveContext()
    }
    
    
    // MARK: - Fetch Entity
    /**
     Достаёт из CD все сохраненные объекты и конвертирует в UI объекты.
     Возвращает уже отсортированный по index массив.
     Если в CD пусто, выйдет из вызывающего замыкания
     - Parameter completionHandler: Массив GeoResponce
     */
    public func fetchSavedCities(_ completionHandler: ([GeoResponce]) -> Void) {
        let request: NSFetchRequest<GeoResponceCD> = GeoResponceCD.fetchRequest()
        let sort = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sort]
        var entities: [GeoResponceCD] = []
        
        do {
            try entities = persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Не удалось fetch from CD 😢 \n \(error)")
        }
        
        guard !entities.isEmpty else { return }
        
        let geoResponces: [GeoResponce] = geoConverter(geoEntities: entities)
        completionHandler(geoResponces)
    }
    
    
    /**
     Возвращает CD объект для указанного GeoResponce
     - Parameter geo: Объект который нужно найти в CD
     - Returns: CD объект для изменения или удаления
     - Note: т.к. UI не работает с моделями из CD, то нужно вручную конвертировать объекты из UI в CD
     */
    public func convertAndFetch(geo: GeoResponce) -> GeoResponceCD? {
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
        
        return entities.first 
    }

    
    // MARK: - Change Entity
    /// Измеяет индекс в CD для всего указанного массива
    public func changeIndex(geoArray: [GeoResponce]) {
        for (i, geo) in geoArray.enumerated() {
            if let entity = convertAndFetch(geo: geo) {
                entity.index = Int16(i)
                saveContext()
            }
        }
    }
    
    
    // MARK: - Work with isFirstToShow Flag
    /// Устанавливает флаг для указанного GeoResponce
    public func setIsFirstToShowFlag(geo: GeoResponce) {
        removeIsFirstToShowFlag()
        if let entity = convertAndFetch(geo: geo) {
            entity.isFirstToShow = true
            saveContext()
        }
    }
    
    
    /// Возвращает GeoResponce города который был выбран первым для показа
    public func fetchFirstToShow() -> GeoResponce? {
        guard let entities = fetchIsFirstToShowArray() else { return nil }
        let geoArray = geoConverter(geoEntities: entities)
        return geoArray.first
    }
    
    /// Возвращает массив объектов CD с флагом isFirstToShow
    private func fetchIsFirstToShowArray() -> [GeoResponceCD]? {
        let request: NSFetchRequest<GeoResponceCD> = GeoResponceCD.fetchRequest()
        let predicate = NSPredicate(format: "isFirstToShow == true")
        request.predicate = predicate
        
        var entities: [GeoResponceCD]?
        do {
            entities = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Не удалось fetch from CD 😢 \n \(error)")
        }
        return entities
    }
    
    /// Находит и удаляет флаг в сохрананнёныx объектах
    private func removeIsFirstToShowFlag() {
        if let entities = fetchIsFirstToShowArray() {
            entities.forEach { $0.isFirstToShow = false }
            saveContext()
        }
    }
    
    
    // MARK: - Entity Converter
    /**
     Возвращает отсортированный по индексу массив GeoResponce для указанного массива объектов CD
     - Parameter geoEntities: Массив объектов CD который нужно конвертировать
     - Returns: Массив объектов GeoResponce
     - Note: т.к. UI не работает с моделями из CD, то нужно вручную конвертировать объекты из CD в UI
     */
    private func geoConverter(geoEntities: [GeoResponceCD]) -> [GeoResponce] {
        var geoResponces: [GeoResponce] = []
        
        for entity in geoEntities.sorted(by: { $0.index < $1.index } ) {
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
