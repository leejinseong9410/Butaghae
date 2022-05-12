//
//  Storage.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/11.
//
import RxSwift
import FirebaseStorage

extension Reactive where Base: StorageObservableTask {

    public func observe(_ status: StorageTaskStatus) -> Observable<StorageTaskSnapshot> {
        return Observable.create { observer in
            let handle = self.base.observe(status) { snapshot in
                observer.onNext(snapshot)
            }
            return Disposables.create {
                self.base.removeObserver(withHandle: handle)
            }
        }
    }
}

extension Reactive where Base: StorageReference {

    public func putData(_ uploadData: Data, metadata: StorageMetadata? = nil) -> Observable<StorageMetadata> {
        return Observable.create { observer in
            let task = self.base.putData(uploadData, metadata: metadata) { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        observer.onNext(metadata)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }

    public func putFile(from url: URL, metadata: StorageMetadata? = nil) -> Observable<StorageMetadata> {
        return Observable.create { observer in
            let task = self.base.putFile(from: url, metadata: metadata) { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        observer.onNext(metadata)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }

    public func getData(maxSize: Int64) -> Observable<Data> {
        return Observable.create { observer in
            let task = self.base.getData(maxSize: maxSize) { data, error in
                guard let error = error else {
                    if let data = data {
                        observer.onNext(data)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }

    public func downloadURL() -> Observable<URL> {
        return Observable.create { observer in
            self.base.downloadURL { url, error in
                guard let error = error else {
                    if let url = url {
                        observer.onNext(url)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    public func write(toFile url: URL) -> Observable<URL> {
        return Observable.create { observer in
            let task = self.base.write(toFile: url) { url, error in
                guard let error = error else {
                    if let url = url {
                        observer.onNext(url)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    public func getMetadata() -> Observable<StorageMetadata> {
        return Observable.create { observer in
            self.base.getMetadata { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        observer.onNext(metadata)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    public func updateMetadata(_ metadata: StorageMetadata) -> Observable<StorageMetadata> {
        return Observable.create { observer in
            self.base.updateMetadata(metadata) { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        observer.onNext(metadata)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    public func delete() -> Observable<Void> {
        return Observable.create { observer in
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
}
