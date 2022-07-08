//
//  AlamofireHelper.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import Alamofire

typealias voidRequestCompletionBlock<T> = (_ decodeData: T?, _ data: Data?, _ error: Any?) -> (Void)

class AlamofireHelper {
    
    var session: Session!
    
    init() {
        sessionSetup()
    }
    
    private func sessionSetup() {
        let rootQueue = DispatchQueue(label: "org.alamofire.customQueue")
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = Int.max
        queue.underlyingQueue = rootQueue
        
        let sd = SessionDelegate()
        let configuration = URLSessionConfiguration.af.default
        let urlSession = URLSession(configuration: configuration,
                                    delegate: sd,
                                    delegateQueue: queue)
        session = Session(session: urlSession, delegate: sd, rootQueue: rootQueue)
    }
    
    func getResponseApi<T, U>(baseUrl: String,
                              api: String,
                              method: HTTPMethod,
                              params: U,
                              headers: HTTPHeaders? = nil,
                              block: @escaping (_ response: T?,
                                                _ data: Data?,
                                                _ error: Any?) -> ()) where T: Decodable,
                                                                            U: Encodable {
        let dataBlock: voidRequestCompletionBlock = block
        
        let url: String = baseUrl.appending(api)
        LogUtil.d("URL : \(url)\nparams : \(String(describing: params))")
        
        var request: DataRequest
        switch method {
        case .get, .delete:
            request = session.request(url,
                                      method: method,
                                      parameters: try? params.asDictionary(),
                                      encoding: ArrayEncoding(),
                                      headers: makeHTTPHeaders(headers: headers, by: url))
        default:
            request = session.request(url,
                                      method: method,
                                      parameters: params,
                                      encoder: JSONParameterEncoder.default,
                                      headers: makeHTTPHeaders(headers: headers, by: url))
        }
        
        request
            .validate(statusCode: 200..<500)
            .cURLDescription(calling: { LogUtil.d($0) })
            .responseDecodable(of: T.self) { [weak self] response in
                switch response.result {
                case .success(let decodeData):
                    dataBlock(decodeData, response.data, response.error)
                case .failure:
                    if Targets.getTarget().isUseJWT {
                        self?.handlingHttpStatusCode(statusCode: response.response?.statusCode) {
                            (isSuccess, data, error) in
                            if isSuccess {
                                self?.getResponseApi(baseUrl: baseUrl,
                                                     api: api,
                                                     method: method,
                                                     params: params,
                                                     headers: headers,
                                                     block: block)
                            } else {
                                dataBlock(nil, data, error)
                            }
                        }
                    } else {
                        dataBlock(nil, response.data, response.error)
                    }
                }
            }
    }
}

// MARK: - Support
extension AlamofireHelper {
    
    //    "App-Info": "OStype,AppVersion,OSVersion"
    func getAppInfo() -> String {
        let commonUtil = CommonUtil()
        
        let os = "iOS"
        let appVersion = commonUtil.getVersion()
        let osVersion = commonUtil.getSystemVersion()
        let buildVersion = commonUtil.getBundleVersion()
        
        return "\(os),\(appVersion),\(buildVersion),\(osVersion)"
    }
    
    func makeHTTPHeaders(headers: HTTPHeaders? = nil,
                         by api: String) -> HTTPHeaders? {
        var _headers = headers == nil
            ? ["Content-Type": "application/json",
               "Accept": "*/*"]
            : headers
        
        guard api.contains(PrefixManager.MOBILE_SERVER_BASE_URL) else {
            return _headers
        }
        
        _headers?.add(name: "App-Info", value: getAppInfo())
        _headers?.add(name: "App-Id", value: Targets.getTarget().getAppId())
        
        if Targets.getTarget().isUseJWT {
            guard JwtStorage.shared.accessToken.isNotEmpty else {
                return _headers
            }
            _headers?.add(name: "Access-Token", value: JwtStorage.shared.accessToken)
        } else {
            guard let accessToken = UserdefaultsManager.shared.accessToken,
                  accessToken.isNotEmpty else {
                return headers
            }
            _headers?.add(name: "Access-Token", value: accessToken)
        }
        
        return _headers
    }
    
    private func handlingHttpStatusCode(statusCode: Int?,
                                        _ completion: @escaping JwtResponse) {
        guard let _statusCode = statusCode else {
            completion(false, nil, nil)
            return
        }
        
        switch HttpStatusCode(rawValue: _statusCode) {
        case .AuthorizationFailed:
            reissueJWT { (isSuccess, data, error) in
                completion(isSuccess, data, error)
            }
        case .none:
            completion(false, nil, nil)
        }
    }
    
    private func reissueJWT(_ completion: @escaping JwtResponse) {
        let endPoint = ""
        let url = PrefixManager.MOBILE_SERVER_BASE_URL + endPoint
        let params = [
            "accessToken": JwtStorage.shared.accessToken,
            "refreshToken": JwtStorage.shared.refreshToken
        ]
        let request = session.request(url,
                                      method: .post,
                                      parameters: params,
                                      encoder: JSONParameterEncoder.default,
                                      headers: makeHTTPHeaders(by: url))

        request
            .validate(statusCode: 200..<500)
            .cURLDescription(calling: { LogUtil.d($0) })
            .responseDecodable(of: JwtReissue.self) { response in
                switch response.result {
                case .success(let decodeData):
                    guard decodeData.code == 0 else {
                        completion(false, response.data, response.error)
                        return
                    }
                    
                    JwtStorage.shared.accessToken = decodeData.accessToken ?? ""
                    JwtStorage.shared.refreshToken = decodeData.refreshToken ?? ""
                    completion(true, nil, nil)
                case .failure:
                    completion(false, response.data, response.error)
                }
            }
    }
}
