//
//  JsonUtil.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

class JsonUtil {
    
    open func encode<T>(_ value: T) throws -> Data where T : Encodable {
        do {
            let encoder = JSONEncoder()
            
            let encodeData = try encoder.encode(value)
            return encodeData
        } catch {
            throw error
        }
    }
    
    open func encodeWithSerialization<T>(_ value: T, options: JSONSerialization.ReadingOptions = []) throws -> Any where T : Encodable {
        do {
            let encodeData = try encode(value)
            let serializationData = try JSONSerialization.jsonObject(with: encodeData, options: options)
            return serializationData
        } catch {
            throw error
        }
    }
    
    open func encodeToString<T>(_ value: T, options: JSONSerialization.WritingOptions = []) throws -> String? where T : Encodable {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: value, options: options)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            return jsonString
        } catch {
            throw error
        }
    }
    
    open func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw error
        }
    }
    
    open func decodeWithSerialization<T>(_ type: T.Type, _ value: Any, options: JSONSerialization.WritingOptions = []) throws -> T where T : Decodable {
        do {
            let serializationData = try JSONSerialization.data(withJSONObject: value, options: options)
            return try decode(type, from: serializationData)
        } catch {
            throw error
        }
    }
    
    open func convertToDictionary(value: Any) throws -> [String: Any]? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
            guard let jsonToDic = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else { return nil }
            return jsonToDic
        } catch {
            return nil
        }
    }
    
}
