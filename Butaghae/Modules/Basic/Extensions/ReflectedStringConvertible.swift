//
//  das.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation

public protocol ReflectedStringConvertible : CustomStringConvertible { }

extension ReflectedStringConvertible {
    
    public var description: String {
        let mirror = Mirror(reflecting: self)
        
        var str = "\(mirror.subjectType)("
        var first = true
        for (label, value) in mirror.children {
            if let label = label {
                if first {
                    first = false
                } else {
                    str += ", "
                }
                str += label
                str += ": "
                str += "\(value)"
            }
        }
        str += ")"
        
        return str
    }
    
}
