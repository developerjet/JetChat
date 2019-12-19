//
//  HttpRequestManager.swift
//  FY-IMChat
//
//  Created by fisker.zhang on 2019/3/9.
//  Copyright © 2019 development. All rights reserved.
//  网络请求结构体

import UIKit
import Moya
import SwiftyJSON
import RxSwift
import RxCocoa
import CleanJSON
import Result

enum HTTPServiceError: Error {
    // 逻辑错误，例如已经注册，返回带code码
    case logic(error: ErrorResponse)
}


// MARK: - Configuration

struct HttpRequestManager {
    
    static let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
        do {
            var request: URLRequest = try endpoint.urlRequest()
            
            // request timeout
            request.timeoutInterval = 30
            // config httpHeaderField
            request.addValue("Basic aW9zc2Jsb2NrOnNibG9jayFAIw==", forHTTPHeaderField: "Authorization")
            request.addValue("ios", forHTTPHeaderField: "mobileType")
            request.addValue(majorVersion, forHTTPHeaderField: "version")
            done(.success(request))
            
            
            var path = request.url?.absoluteString.replacingOccurrences(of: HttpApiConfig.baseURL, with: "") ?? ""
            printLog("request path：\(path)")
            
        } catch {
            
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    static let endpointClosure = { (target: MultiTarget) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        return defaultEndpoint
    }
    
    /// 单利
    static let provider = MoyaProvider<MultiTarget>(endpointClosure: HttpRequestManager.endpointClosure, requestClosure: HttpRequestManager.requestClosure)
}


// MARK: - Observable JSONCodable

// 为了将网络请求返回的数据直接转化成Model（写了一个ModelTool扩展）
extension ObservableType where E == Response {

    public func filterSuccess(showHud: Bool) -> Observable<E> {
        
        return flatMapLatest { (response) -> Observable<E> in
            guard let json = try? JSON(response.mapJSON()) else {
                //无法解析，服务器异常
                //MBConfiguredHUD.showError(Lca.tip_e_error_show_data.rLocalized())
                //LWProgressHUD.showError("\(Lcatip_e_error_show.rLocalized())\n无法解析)")
                return Observable.error(MoyaError.jsonMapping(response))
            }

            
            if json.dictionaryValue["code"]?.intValue == 200 {
                // code为200，表示成功
                printLog("json response：\(json)")
                return Observable.just(response)
            }
            
            if var errorModel = ErrorResponse.deserialize(from: json.dictionaryValue) {
                errorModel.type = ErrorResponseType.Logic
                do {
                    // try bug, catch
                    errorModel.data = try json.dictionaryValue["data"]?.rawData()
                }catch {
                    errorModel.data = "{}".data(using: String.Encoding.utf8)!
                }
                
                
                if errorModel.code == "1003" {
                    // token失效
                    MBHUD.showMessage(String.getErrorMessage(code: "1003"))
                    // 退到登入主界面
                    self.loginInvalid()
                }else {
                    if showHud {
                        //10075 没设置支付密码
                        if errorModel.code == "10072" || errorModel.code == "10075" {
                            MBConfiguredHUD.hide()
                        }else {
                            let errorMessage = String.getErrorMessage(code: errorModel.code, message: errorModel.msg)
                            MBHUD.showMessage(errorMessage)
                        }
                    }else {
                        
                        MBConfiguredHUD.hide()
                    }
                }
                
                return Observable.error(HTTPServiceError.logic(error: errorModel))
            }
            
            return  Observable.error(MoyaError.jsonMapping(response))
        }

    }
    
    public func filterBaiduSuccess() -> Observable<E> {
        
        return flatMap { (response) -> Observable<E> in
            let json = try JSON(response.mapJSON())
            printLog(json)
            if json.dictionaryValue["err_no"]?.intValue == 0{
                //code为0，表示成功
                return Observable.just(response)
            }
            if json.dictionaryValue["error_code"]?.intValue == 0{
                //code为0，表示成功
                return Observable.just(response)
            }
            if json.dictionaryValue["error_code"]?.intValue != 17 {//流量超标
                //MBConfiguredHUD.showError(Lca.k_face_verify_error_tip.rLocalized())
            }
            return  Observable.error(MoyaError.jsonMapping(response))
        }
        
    }
    
    /// 强制退出登入
    fileprivate func loginInvalid() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            
            UserInfoManager.shared.clearChaches()
        }
    }
}


extension HttpRequestManager {
    
    /// 默认rx请求
    ///
    /// - Parameters:
    ///   - api: api
    ///   - type: 解析类型
    /// - Returns: 返回数据或错误
    static func rxRequest<T:Codable>(_ api: MultiTarget,
                                     isNeedshowHud: Bool = true,
                                     type:T.Type) -> Single<T>{

        let decoder = CleanJSONDecoder()

        return self.provider.rx.request(api)
            .asObservable()
            .take(1)
            .filterSuccess(showHud: isNeedshowHud)
            .map(type, using: decoder)
            .observeOn(MainScheduler.instance) 
            .asSingle()
    }
    
    
    
    /// rx请求
    ///
    /// - Parameters:
    ///   - keypath: 更深路径 默认data
    ///   - api: api
    ///   - type: 传入的解析类型
    /// - Returns: 单信号（返回的数据，或错误信息）
    static func rxRequestData<T:Codable>(with keypath: String = "data",
                                         isNeedshowHud: Bool = true,
                                         _ api: MultiTarget,
                                         type: T.Type) -> Single<T>{
        
        let decoder = CleanJSONDecoder()
        
        return self.provider.rx.request(api).do(onSuccess: { (response) in
            
            printLog("onSuccess->response   \(try response.mapString())")

        }, onError: { (error) in
            printLog("onError->error  \(error)\(error.localizedDescription)")
            switch error{
            case MoyaError.underlying:
                printLog(">>>>>接口超时 ")
                MBConfiguredHUD.hideWithDelay(delay: 0.5)
            default:
                break
            }
            
        })
            .asObservable()
            .take(1)
            .filterSuccess(showHud: isNeedshowHud)
            .map(type, atKeyPath: keypath, using: decoder)
            .observeOn(MainScheduler.instance)
            .asSingle()
    }

    
    /// rx请求
    ///
    /// - Parameter api: api
    /// - Returns: 返回整个Response数据
    static func rxRequestResponse(_ api: MultiTarget,
                                  isNeedshowHud: Bool = true) -> Single<JSON>{
        
        return self.provider.rx.request(api)
            .asObservable()
            .take(1)
            .filterSuccess(showHud: isNeedshowHud)
            .map({ (response) ->JSON in
                return try JSON(response.mapJSON())
            })
            .observeOn(MainScheduler.instance)
            .asSingle()
    }

}
