//
//  SignModel.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa
import CoreData

class SignModel {

    let generater: NetworkGenerater
    init(generater: NetworkGenerater = NetworkGenerater()) {
        self.generater = generater
    }
    
    func getUserInfo(req: BaseGetRequest<UserInfo_Req>) -> Observable<UserInfoRes> {
        return generater.makeApi(baseUrl: PrefixManager.MOBILE_SERVER_BASE_URL,
                                 api: PrefixManager.MOBILE_USER + req.getPath(),
                                 method: .get,
                                 params: req.getQuery())
            .retry(3, delay: .constant(milliseconds: 1000))
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
}
