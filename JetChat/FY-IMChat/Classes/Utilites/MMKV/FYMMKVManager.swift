//
//  LWMMKVManager.swift
//  FY-IMChat
//
//  Created by fisker.zhang on 2019/4/3.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import CleanJSON

enum LWMMKVType {
    case BoolType
    case Int32Type
    case Uint32Type
    case Int64Type
    case Uint64Type
    case FloatType
    case DoubleType
    case StringType
    case DateType
    case DataType

    func type() -> String {
        switch self {
        case .BoolType:
            return "bool"
        case .Int32Type:
            return "int32"
        case .Uint32Type:
            return "uint32"
        case .Int64Type:
            return "int64"
        case .Uint64Type:
            return "uint64"
        case .FloatType:
            return "float"
        case .DoubleType:
            return "double"
        case .StringType:
            return "string"
        case .DateType:
            return "date"
        case .DataType:
            return "data"
        }
    }
}


class FYMMKVManager: NSObject {

    static let SecretKey = "MMKV-LWallet-AESkey".data(using: .utf8)
    
    static let manager = FYMMKVManager()
    
    
    /// 清除所有缓存
    public func clearMMKV(){
        MMKV.default().clearAll()
    }
    
    /// mmkv保存数据,保存的是data
    ///
    /// - Parameters:
    ///   - value: 需要保存的值
    ///   - key: mmkv存储key
    /// - Returns: 成功与否
    public func setMMKVDataValue<T:Codable>(value:T, key:String) -> Bool{
        guard let mmkv = MMKV(mmapID: key, cryptKey: FYMMKVManager.SecretKey) else{ return false }
        if let encodeData = try? JSONEncoder().encode(value){
            mmkv.set(encodeData, forKey:LWMMKVType.DataType.type())
            return true
        }

        return false
    }
    
    public func setMMKValue(value:Any, key:String, type:LWMMKVType){
        guard let mmkv = MMKV(mmapID: key, cryptKey: FYMMKVManager.SecretKey) else{ return }
        let typeStr = type.type()

        switch type {
        case .BoolType:
            mmkv.set(value as! Bool, forKey: typeStr)
        case .Int32Type:
            mmkv.set(value as! Int32, forKey: typeStr)
        case .Int64Type:
            mmkv.set(value as! Int64, forKey: typeStr)
        case .Uint32Type:
            mmkv.set(value as! UInt32, forKey: typeStr)
        case .Uint64Type:
            mmkv.set(value as! UInt64, forKey: typeStr)
        case .DateType:
            mmkv.set(value as! NSDate, forKey: typeStr)
        case .StringType:
            mmkv.set(value as! String, forKey: typeStr)
        case .FloatType:
            mmkv.set(value as! Float, forKey: typeStr)
        case .DoubleType:
            mmkv.set(value as! Double, forKey: typeStr)
        case .DataType:
            mmkv.set(value as! Data, forKey: typeStr)
        }
        
    }
    
    /// mmkv获取数据
    ///
    /// - Parameters:
    ///   - key:  mmkv存储key
    ///   - type: mmkv存储的类型，枚举值
    /// - Returns: 对应类型的值
    public func getMMKVValue(key:String, type:LWMMKVType) -> Any? {
        guard let mmkv = MMKV(mmapID: key, cryptKey: FYMMKVManager.SecretKey) else{ return nil }
        let typeStr = type.type()
        switch type {
        case .BoolType:
            return mmkv.bool(forKey: typeStr)
        case .Int32Type:
            return mmkv.int32(forKey: typeStr)
        case .Int64Type:
            return mmkv.int64(forKey: typeStr)
        case .Uint32Type:
            return mmkv.uint32(forKey: typeStr)
        case .Uint64Type:
            return mmkv.uint64(forKey: typeStr)
        case .DateType:
            return mmkv.date(forKey: typeStr)
        case .StringType:
            return mmkv.string(forKey: typeStr)
        case .FloatType:
            return mmkv.float(forKey: typeStr)
        case .DoubleType:
            return mmkv.double(forKey: typeStr)
        case .DataType:
            return mmkv.data(forKey: typeStr)
        }
    }
    
    
    /// 从缓存data中转model，遵循codable协议
    ///
    /// - Parameters:
    ///   - decodeType: codable 类型
    ///   - key: mmkv存储key
    ///   - type: mmkv存储的类型，枚举值
    /// - Returns: 返回codable model或者list
    public func mmkvDecode<T:Codable>(decodeType:T.Type,key:String, type:LWMMKVType) -> T? {
        
        guard let data = FYMMKVManager.manager.getMMKVValue(key: key, type: type) as? Data else{
            return nil
        }
        
        let decoder = CleanJSONDecoder()
        
        if let coda = try? decoder.decode(decodeType, from: data){
            return coda
        }
        
        return nil
    }
}
