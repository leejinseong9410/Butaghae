//
//  User.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/11.
//

import Foundation
//
//  FIRUser+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 09/09/2018.
//

import FirebaseAuth
import RxSwift

extension Reactive where Base: User {
    
    public func updateEmail(to email: String) -> Observable<Void> {
        return Observable.create { observer in
            self.base.updateEmail(to: email) { error in
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
    
    public func updatePassword(to password: String) -> Observable<Void> {
        return Observable.create { observer in
            self.base.updatePassword(to: password) { error in
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
    
    #if os(iOS)
    public func updatePhoneNumber(_ credential: PhoneAuthCredential) -> Observable<Void> {
        return Observable.create { observer in
            self.base.updatePhoneNumber(credential) { error in
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
    #endif
    
    public func reload() -> Observable<Void> {
        return Observable.create { observer in
            self.base.reload { error in
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
    
   
    public func reauthenticateAndRetrieveData(with credential: AuthCredential) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.reauthenticate(with: credential) { result, error in
                if let error = error {
                    observer.onError(error)
                } else if let result = result {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    public func getIDTokenResult() -> Observable<AuthTokenResult> {
        return Observable.create { observer in
            self.base.getIDTokenResult { result, error in
                if let error = error {
                    observer.onError(error)
                } else if let result = result {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func getIDTokenResult(forcingRefresh: Bool) -> Observable<AuthTokenResult> {
        return Observable.create { observer in
            self.base.getIDTokenResult(forcingRefresh: forcingRefresh) { result, error in
                if let error = error {
                    observer.onError(error)
                } else if let result = result {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func getIDToken() -> Observable<String> {
        return Observable.create { observer in
            self.base.getIDToken { token, error in
                if let error = error {
                    observer.onError(error)
                } else if let token = token {
                    observer.onNext(token)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func getIDTokenForcingRefresh(_ forceRefresh: Bool) -> Observable<String> {
        return Observable.create { observer in
            self.base.getIDTokenForcingRefresh(forceRefresh) { token, error in
                if let error = error {
                    observer.onError(error)
                } else if let token = token {
                    observer.onNext(token)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    public func linkAndRetrieveData(with credential: AuthCredential) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.link(with: credential) { result, error in
                if let error = error {
                    observer.onError(error)
                } else if let result = result {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func unlink(fromProvider provider: String) -> Observable<User> {
        return Observable.create { observer in
            self.base.unlink(fromProvider: provider) { user, error in
                if let error = error {
                    observer.onError(error)
                } else if let user = user {
                    observer.onNext(user)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func sendEmailVerification() -> Observable<Void> {
        return Observable.create { observer in
            self.base.sendEmailVerification { error in
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
  
    public func sendEmailVerification(with settings: ActionCodeSettings) -> Observable<Void> {
        return Observable.create { observer in
            self.base.sendEmailVerification(with: settings) { error in
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
