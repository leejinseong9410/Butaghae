//
//  PhoneProvider.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/11.
//

import Foundation
import RxSwift
import FirebaseAuth

#if os(iOS)
extension Reactive where Base: PhoneAuthProvider {

  public func verifyPhoneNumber(_ phoneNumber: String, uiDelegate: AuthUIDelegate? = nil) -> Observable<String> {
    return Observable.create { observer in
      self.base.verifyPhoneNumber(phoneNumber, uiDelegate: uiDelegate) { result, error in
        if let result = result {
          observer.onNext(result)
          observer.onCompleted()
        } else if let error = error {
          observer.onError(error)
        }
      }
      return Disposables.create()
    }
  }
}
#endif
