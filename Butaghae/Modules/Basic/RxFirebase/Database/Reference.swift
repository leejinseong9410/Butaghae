//  FIRDatabaseReference+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 03/05/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxSwift
import FirebaseDatabase

public typealias DatabaseReferenceTransactionResult = (committed: Bool, snapshot: DataSnapshot?)

extension Reactive where Base: DatabaseReference {

    public func setValue(_ value: Any?, andPriority priority: Any? = nil) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.setValue(value, andPriority: priority, withCompletionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.failure(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }

    public func removeValue() -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.removeValue(completionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.failure(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }

    public func setPriority(_ priority: Any?) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.setPriority(priority, withCompletionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.failure(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }
    
    public func updateChildValues(_ values: [AnyHashable: Any]) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.failure(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }

    public func onDisconnectSetValue(_ value: Any?, andPriority priority: Any? = nil) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.onDisconnectSetValue(value, andPriority: priority, withCompletionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.failure(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }

    public func onDisconnectRemoveValue() -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.onDisconnectRemoveValue(completionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.failure(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }

    public func onDisconnectUpdateChildValues(_ values: [AnyHashable: Any]) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.onDisconnectUpdateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.failure(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }

    public func cancelDisconnectOperations() -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.cancelDisconnectOperations(completionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.failure(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }

    public func runTransactionBlock(_ block: @escaping (MutableData) -> TransactionResult, withLocalEvents: Bool) -> Single<DatabaseReferenceTransactionResult> {
        
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.runTransactionBlock(block, andCompletionBlock: { (error, committed, snapshot) in
                if let error = error {
                    singleEventListener(.failure(error))
                }
                else {
                    singleEventListener(.success(DatabaseReferenceTransactionResult(committed, snapshot)))
                }
            })
            return Disposables.create()
        })
    }

    public func runTransactionBlock(_ block: @escaping (MutableData) -> TransactionResult) -> Single<DatabaseReferenceTransactionResult> {
        return self.runTransactionBlock(block, withLocalEvents: true)
    }
}
