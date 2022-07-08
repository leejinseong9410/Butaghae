import RxCocoa
import RxSwift
import FirebaseFirestore

extension Reactive where Base: CollectionReference {

    public func addDocument(data: [String: Any]) -> Observable<DocumentReference> {
        return Observable<DocumentReference>.create { observer in
            var ref: DocumentReference?
            ref = self.base.addDocument(data: data) { error in
                if let error = error {
                    observer.onError(error)
                } else if let ref = ref {
                    observer.onNext(ref)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

extension Reactive where Base: DocumentReference {
    
    public func setData(_ documentData: [String: Any]) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.setData(documentData) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    public func setData(_ documentData: [String: Any], merge: Bool) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.setData(documentData, merge: merge) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    public func updateData(_ fields: [AnyHashable: Any]) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.updateData(fields) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    public func delete() -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.delete { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    public func getDocument() -> Observable<DocumentSnapshot> {
        return Observable.create { observer in
            self.base.getDocument { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot, snapshot.exists {
                    observer.onNext(snapshot)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }

    public func getDocument(source: FirestoreSource) -> Observable<DocumentSnapshot> {
        return Observable.create { observer in
            self.base.getDocument(source: source) { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot, snapshot.exists {
                    observer.onNext(snapshot)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }

    public func listen(includeMetadataChanges: Bool) -> Observable<DocumentSnapshot> {
        return Observable<DocumentSnapshot>.create { observer in
            let listener = self.base.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }

    public func listen() -> Observable<DocumentSnapshot> {
        return Observable<DocumentSnapshot>.create { observer in
            let listener = self.base.addSnapshotListener() { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }
}

extension Reactive where Base: Firestore {

    public func disableNetwork() -> Observable<Void> {
        return Observable.create { observer in
            self.base.disableNetwork(completion: { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
    
    public func enableNetwork() -> Observable<Void> {
        return Observable.create { observer in
            self.base.enableNetwork(completion: { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
    
    public func runTransaction(_ updateBlock: @escaping (Transaction) throws -> Any?) -> Observable<Any?> {
        return self.runTransaction(type: Any.self, updateBlock)
    }
    
    public func runTransaction<T>(type: T.Type, _ updateBlock: @escaping (Transaction) throws -> T?) -> Observable<T?> {
        return Observable.create { observer in
            self.base.runTransaction({ transaction, errorPointer in
                do {
                    return try updateBlock(transaction)
                } catch {
                    errorPointer?.pointee = error as NSError
                    return nil
                }
            }, completion: { value, error in
                guard let error = error else {
                    observer.onNext(value as? T)
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
}

extension Reactive where Base: Query {

    public func getDocuments() -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            self.base.getDocuments { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    public func getDocuments(source: FirestoreSource) -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            self.base.getDocuments(source: source) { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    public func getFirstDocument() -> Observable<QueryDocumentSnapshot> {
        return self.base.limit(to: 1)
            .rx
            .getDocuments()
            .map { snapshot in
                guard let document = snapshot.documents.first(where: { $0.exists }) else {
                    throw NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil)
                }
                return document
            }
    }

    public func listen() -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            let listener = self.base.addSnapshotListener { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }
    
    public func listen(includeMetadataChanges: Bool) -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            let listener = self.base.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }
}

extension Reactive where Base: WriteBatch {
    
    public func commit() -> Observable<Void> {
        return Observable.create { observer in
            self.base.commit { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}

