//
//  Auth.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/11.
//

import FirebaseAuth
import RxSwift

extension Reactive where Base: Auth {
        
        public func updateCurrentUser(_ user: User) -> Observable<Void> {
            return Observable.create { observer in
                self.base.updateCurrentUser(user) { error in
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

        public func fetchProviders(forEmail email: String) -> Observable<[String]> {
            return Observable.create { observer in
                self.base.fetchSignInMethods(forEmail: email) { providers, error in
                    guard let error = error else {
                        observer.onNext(providers ?? [])
                        observer.onCompleted()
                        return
                    }
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        
        public func fetchSignInMethods(forEmail email: String) -> Observable<[String]> {
            return Observable.create { observer in
                self.base.fetchSignInMethods(forEmail: email) { methods, error in
                    guard let error = error else {
                        observer.onNext(methods ?? [])
                        observer.onCompleted()
                        return
                    }
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }

        public func signIn(withEmail email: String, password: String) -> Observable<AuthDataResult> {
            return Observable.create { observer in
                self.base.signIn(withEmail: email, password: password) { auth, error in
                    if let error = error {
                        observer.onError(error)
                    } else if let auth = auth {
                        observer.onNext(auth)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
        
    
        public func signIn(withEmail email: String, link: String) -> Observable<AuthDataResult> {
            return Observable.create { observer in
                self.base.signIn(withEmail: email, link: link) { auth, error in
                    if let error = error {
                        observer.onError(error)
                    } else if let auth = auth {
                        observer.onNext(auth)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
        
        public func signInAndRetrieveData(with credential: AuthCredential) -> Observable<AuthDataResult> {
            return Observable.create { observer in
                self.base.signIn(with: credential) { auth, error in
                    if let error = error {
                        observer.onError(error)
                    } else if let auth = auth {
                        observer.onNext(auth)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }

        public func signInAnonymously() -> Observable<AuthDataResult> {
            return Observable.create { observer in
                self.base.signInAnonymously { auth, error in
                    if let error = error {
                        observer.onError(error)
                    } else if let auth = auth {
                        observer.onNext(auth)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }

        public func signIn(withCustomToken token: String) -> Observable<AuthDataResult> {
            return Observable.create { observer in
                self.base.signIn(withCustomToken: token) { auth, error in
                    if let error = error {
                        observer.onError(error)
                    } else if let auth = auth {
                        observer.onNext(auth)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }

        public func createUser(withEmail email: String, password: String) -> Observable<AuthDataResult> {
            return Observable.create { observer in
                self.base.createUser(withEmail: email, password: password) { auth, error in
                    if let error = error {
                        observer.onError(error)
                    } else if let auth = auth {
                        observer.onNext(auth)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }

        public func confirmPasswordReset(withCode code: String, newPassword: String) -> Observable<Void> {
            return Observable.create { observer in
                self.base.confirmPasswordReset(withCode: code, newPassword: newPassword) { error in
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
        
        public func checkActionCode(_ code: String) -> Observable<ActionCodeInfo> {
            return Observable.create { observer in
                self.base.checkActionCode(code) { info, error in
                    if let error = error {
                        observer.onError(error)
                    } else if let info = info {
                        observer.onNext(info)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }

        public func verifyPasswordResetCode(_ code: String) -> Observable<String> {
            return Observable.create { observer in
                self.base.verifyPasswordResetCode(code) { result, error in
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

        public func applyActionCode(_ code: String) -> Observable<Void> {
            return Observable.create { observer in
                self.base.applyActionCode(code) { error in
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

        public func sendPasswordReset(withEmail email: String) -> Observable<Void> {
            return Observable.create { observer in
                self.base.sendPasswordReset(withEmail: email) { error in
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

        public func sendPasswordReset(withEmail email: String, actionCodeSettings: ActionCodeSettings) -> Observable<Void> {
            return Observable.create { observer in
                self.base.sendPasswordReset(withEmail: email, actionCodeSettings: actionCodeSettings) { error in
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

        public func sendSignInLink(toEmail email: String, actionCodeSettings: ActionCodeSettings) -> Observable<Void> {
            return Observable.create { observer in
                self.base.sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
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

        public var stateDidChange: Observable<User?> {
            return Observable.create { observer in
                let handle = self.base.addStateDidChangeListener { _, user in
                    observer.onNext(user)
                }
                return Disposables.create {
                    self.base.removeStateDidChangeListener(handle)
                }
            }
        }

        public var idTokenDidChange: Observable<User?> {
            return Observable.create { observer in
                let handle = self.base.addIDTokenDidChangeListener { _, user in
                    observer.onNext(user)
                }
                return Disposables.create {
                    self.base.removeIDTokenDidChangeListener(handle)
                }
            }
        }
    }
