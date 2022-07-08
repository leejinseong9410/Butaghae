//
//  Profile.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/11.
//

import Foundation
import RxSwift
import FirebaseAuth

extension Reactive where Base: UserProfileChangeRequest {

    public func commitChanges() -> Observable<Void> {
        return Observable.create { observer in
            self.base.commitChanges { error in
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
