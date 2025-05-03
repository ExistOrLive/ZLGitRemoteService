//
//  ZLGithubHttpClientV2.swift
//  ZLGitRemoteService
//
//  Created by 朱猛 on 2023/4/6.
//

import Foundation
import Alamofire
import WebKit

typealias ZLGithubHttpClientBlock = (Bool, Any?,  ZLGithubRequestErrorModel?) -> Void

@objc public class ZLGithubHttpClientV2: NSObject {
    
    @objc public static let defaultClient: ZLGithubHttpClientV2 = {
        let client = ZLGithubHttpClientV2()
        return client
    }()
    
    let sessionConfiguration: URLSessionConfiguration
    
    let session: Session
    
    let completionQueue: DispatchQueue
    
    var token: String = ""
    
    override init() {
        
        sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 30
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        session = Session(configuration: sessionConfiguration,
                          startRequestsImmediately: false)
        
        completionQueue = ZLBaseServiceModel.serviceOperationQueue()
        
        super.init()
        
        token = ZLSharedDataManager.sharedInstance().githubAccessToken ?? ""
    }
    
    func requestGithubAPI(api: ZLGithubAPISwift,
                          serialNumber: String,
                          responseBlock: @escaping GithubResponseSwift) {
        
        let successResponse: ZLGithubHttpClientSuccessBlock = { api, response, data in
            
            switch api.resultType {
            case .data:
                responseBlock(true, data, serialNumber)
            case .string:
                let str = String(data: data, encoding: .utf8)
                responseBlock(true, str, serialNumber)
            case .jsonObject:
                if let jsonObject = try? JSONSerialization.jsonObject(with: data) {
                    responseBlock(true, jsonObject, serialNumber)
                } else {
                    responseBlock(true, data, serialNumber)
                }
            case .custom(let wrapper):
                let resultData = wrapper.parseData(api: api,response: response, data: data)
                responseBlock(true, resultData, serialNumber)
            case .object(let wrapper):
                let resultData = wrapper.parseData(api: api,response: response, data: data)
                responseBlock(true, resultData, serialNumber)
            }
            
        }
        
        
        let commonHeaders: [String: String] = ["Authorization": "Bearer \(token)",
                                               "Accept": "application/vnd.github.v3+json"]
        
        var httpHeaders = HTTPHeaders(commonHeaders)
        for header in api.headers {
            httpHeaders.update(name: header.key, value: header.value)
        }
        
        let request = session.request(api.url,
                                      method:api.method,
                                      parameters: api.params,
                                      encoding: api.paramsEncoding,
                                      headers: httpHeaders)
        
        request.responseData(queue: completionQueue,
                             completionHandler: { (dataResponse : AFDataResponse<Data>) in
            
            switch dataResponse.result {
            case .success(let data):
                if  let response = dataResponse.response,
                    let statusCode = dataResponse.response?.statusCode {
                    
//                    if statusCode == 401 {
//                        ZLMainThreadDispatch({
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ZLGithubTokenInvalid_Notification"), object: nil)
//                        })
//                    }
                    
                    if api.successStatusCodes.contains(statusCode) {
                        
                        successResponse(api, response, data)
                        
                    } else {
                        
                        var message: String = ""
                        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String:Any?] {
                            message = jsonObject["message"] as? String ?? ""
                        }
                        let errorModel = ZLGithubRequestErrorModel()
                        errorModel.statusCode = statusCode
                        errorModel.message = message
                        responseBlock(false,errorModel,serialNumber)
                        
                    }
                    
                } else {
                    let errorModel = ZLGithubRequestErrorModel()
                    errorModel.statusCode = 0
                    errorModel.message = "No Status Code"
                    responseBlock(false,errorModel,serialNumber)
                }
                
            case .failure(let error):
                let errorModel = ZLGithubRequestErrorModel()
                errorModel.statusCode = dataResponse.response?.statusCode ?? 0
                errorModel.message = error.errorDescription ?? ""
                responseBlock(false, errorModel, serialNumber)
            }
            
        })
        
        request.resume()
    }
}


// MARK: -  OAuth
public extension ZLGithubHttpClientV2 {

    @objc dynamic func checkTokenIsValid(token: String,
                                         serialNumber: String,
                                         responseBlock:@escaping GithubResponseSwift) {
        
        let headers: [String:String] = ["Authorization": "Bearer \(token)",
                                        "Accept": "application/vnd.github.v3+json"]
        let httpHeaders = HTTPHeaders(headers)
        let request = Session.default.request("https://api.github.com/user",
                                              method:.head,
                                              parameters: [:],
                                              encoding: URLEncoding.default,
                                              headers: httpHeaders)
        
        request.responseData(queue: completionQueue,
                             completionHandler: { [weak self] (dataResponse : AFDataResponse<Data>) in
            
            switch dataResponse.result {
            case .success(let data):
                if  let response = dataResponse.response,
                    let statusCode = dataResponse.response?.statusCode {
                    
                    if Set(200...299).contains(statusCode) {
                        responseBlock(true, nil, serialNumber)
                        self?.token = token
                    } else {
                        var message: String = ""
                        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String:Any?] {
                            message = jsonObject["message"] as? String ?? ""
                        }
                        let errorModel = ZLGithubRequestErrorModel()
                        errorModel.statusCode = statusCode
                        errorModel.message = message
                        responseBlock(false,errorModel,serialNumber)
                    }
                  
                } else {
                    let errorModel = ZLGithubRequestErrorModel()
                    errorModel.statusCode = 0
                    errorModel.message = "No Status Code"
                    responseBlock(false,errorModel,serialNumber)
                }
                
            case .failure(let error):
                let errorModel = ZLGithubRequestErrorModel()
                errorModel.statusCode = dataResponse.response?.statusCode ?? 0
                errorModel.message = error.errorDescription ?? ""
                responseBlock(false, errorModel, serialNumber)
            }
            
        })
        
    }

    @objc dynamic func logout(serialNumber: String,
                              responseBlock:@escaping GithubResponseSwift) {
        let set = Set([WKWebsiteDataTypeCookies,WKWebsiteDataTypeSessionStorage])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: set, modifiedSince: date, completionHandler: {})
        
        if let url = URL(string: "https://github.com"),
           let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            for cookie in  cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        self.token = ""
        
        responseBlock(true, nil, serialNumber)
    }
}
