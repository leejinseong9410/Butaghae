//
//  FIRDatabaseQuery+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 08/04/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseDatabase

public typealias PreviousSiblingKeyDataSnapshot = (snapshot: DataSnapshot, prevKey: String?)

extension Reactive where Base: DatabaseQuery {

    public func observeEvent(_ eventType: DataEventType) -> Observable<DataSnapshot> {
        return Observable.create { observer in
            let handle = self.base.observe(eventType, with: { snapshot in
                observer.onNext(snapshot)
            }, withCancel: { error in
                observer.onError(error)
            })
            return Disposables.create {
                self.base.removeObserver(withHandle: handle)
            }
        }
    }
    
    public func observeEventAndPreviousSiblingKey(_ eventType: DataEventType) -> Observable<PreviousSiblingKeyDataSnapshot> {
        return Observable.create { observer in
            let handle = self.base.observe(eventType, andPreviousSiblingKeyWith: { snapshot, prevKey in
                observer.onNext(PreviousSiblingKeyDataSnapshot(snapshot, prevKey))
            }, withCancel: { error in
                observer.onError(error)
            })
            return Disposables.create {
                self.base.removeObserver(withHandle: handle)
            }
        }
    }

    public func observeSingleEvent(_ eventType: DataEventType) -> Single<DataSnapshot> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.observeSingleEvent(of: eventType, with: { (snapshot) in
                singleEventListener(.success(snapshot))
            }, withCancel: { (error) in
                singleEventListener(.failure(error))
            })
            return Disposables.create()
        })
    }
    
    public func observeSingleEventAndPreviousSiblingKey(_ eventType: DataEventType) -> Single<PreviousSiblingKeyDataSnapshot> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.observeSingleEvent(of: eventType, andPreviousSiblingKeyWith: { (snapshot, prevKey) in
                singleEventListener(.success(PreviousSiblingKeyDataSnapshot(snapshot, prevKey)))
            }, withCancel: { (error) in
                singleEventListener(.failure(error))
            })
            return Disposables.create()
        })
    }
}
