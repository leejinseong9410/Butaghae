//
//  AppConfigApiModel.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import RxSwift

class AppConfigApiModel {
    
    let generater: NetworkGenerater
    init(generater: NetworkGenerater = NetworkGenerater()) {
        self.generater = generater
    }
    
    func postAppConfig() -> Observable<AppConfig> {
        return generater.makeApi(baseUrl: PrefixManager.MOBILE_SERVER_BASE_URL,
                                 api: "PrefixManager.APP_CONFIG",
                                 method: .post,
                                 params: AppConfig_Req())
            .retry(3, delay: .constant(milliseconds: 1000))
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    func getAppVersion(req: BaseGetRequest<AppVersion_Req>) -> Observable<AppVersion> {
        return generater.makeApi(baseUrl: PrefixManager.MOBILE_SERVER_BASE_URL,
                                 api: PrefixManager.APP_VERSION + req.getPath(),
                                 method: .get,
                                 params: req.getQuery())
            .retry(3, delay: .constant(milliseconds: 1000))
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    func postAppAddToken(req: AppAddToken_Req) -> Observable<AppAddToken> {
        return generater.makeApi(baseUrl: PrefixManager.MOBILE_SERVER_BASE_URL,
                                 api: PrefixManager.APP_ADDAPP,
                                 method: .post,
                                 params: req)
            .retry(3, delay: .constant(milliseconds: 1000))
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
}
