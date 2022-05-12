//
//  CoreDataManager.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/11.
//

import Foundation
import CoreData
import Then
import RxSwift
import RxCocoa

final class CoreDataManager {
    
    private lazy var coreDataContainer = NSPersistentContainer(name: "UserDefaultData").then {
        $0.loadPersistentStores { _, error in
            print(error?.localizedDescription ?? "")
        }
    }
    
    var coreDataObj : NSManagedObjectContext {
        coreDataContainer.viewContext
    }
    
    func getCoreDataAllData<T: NSManagedObject>() -> Observable<[T]> {
        return Observable.create { [weak self] observer in
            do {
                let core_Req = NSFetchRequest<T>(entityName: "\(T.self)")
                if let coreDataObject = try self?.coreDataObj.fetch(core_Req) {
                    observer.onNext(coreDataObject)
                }
            } catch {
                print("😰😰😰😰😰\(error)😩😩😩😩😩 \(#line)")
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
}
