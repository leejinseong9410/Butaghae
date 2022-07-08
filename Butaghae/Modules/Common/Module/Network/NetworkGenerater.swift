//
//  NetworkGenerater.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import RxSwift
import Alamofire

class NetworkGenerater {
    
    let af = AlamofireHelper()
    
    func makeApi<T, U>(baseUrl: String,
                       api: String,
                       method: HTTPMethod,
                       params: U,
                       headers: HTTPHeaders? = nil) -> Observable<T> where T: Decodable,
                                                                           U: Encodable {
        return Observable<T>.create { [weak self] observer in
            self?.af.getResponseApi(baseUrl: baseUrl,
                                    api: api,
                                    method: method,
                                    params: params,
                                    headers: headers) { decodeData, data, error in
                self?.handleResponseApi(observer: observer,
                                        decodeData: decodeData,
                                        data: data,
                                        error: error)
            }
            return Disposables.create()
        }
    }
    
    func handleResponseApi<T>(observer: AnyObserver<T>,
                              decodeData: T?,
                              data: Data?,
                              error: Any?) where T: Decodable {
        if let e = error as? Error {
            if let d = data,
               let msg = String(bytes: d, encoding: .utf8) {
                observer.onError(ApiError.RESPONSE_FAIL(msg))
            } else {
                let errorMsg = e.localizedDescription
                if errorMsg.contains("offline") {
                    observer.onError(ApiError.NETWORK_CONNECTION("네트워크 연결상태를 확인해 주세요."))
                } else {
                    observer.onError(ApiError.SERVER_ISSUE(errorMsg))
                }
            }
        } else if let _decodeData = decodeData {
            if let baseResponse = _decodeData as? BaseResponse,
               baseResponse.code == Targets.getTarget().getAccessDenindCode() {
                observer.onError(ApiError.ACCESS_TOKEN_DENIND)
            } else {
                observer.onNext(_decodeData)
            }
        } else {
            observer.onError(ApiError.DATA_IS_NULL([:], data))
        }
        
        observer.onCompleted()
    }
    
}

struct EmptyRequest: Codable {
    
}
