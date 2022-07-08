//
//  LogUtil.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

enum LogEvent: String {
    case e = "[‼️]" // error
    case i = "[ℹ️]" // info
    case d = "[💬]" // debug
    case v = "[🔬]" // verbose
    case w = "[⚠️]" // warning
    case s = "[🔥]" // severe
}

public class LogUtil {
    
    static let dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    
    
    // error
    public class func e( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString()) \(LogEvent.e.rawValue)
            [\(sourceFileName(filePath: filename))]
            Line:\(line)
            Column:\(column)
            Function:\(funcName) ->
            \(object)
            ------------------------------------------------------------------------------------
            """)
    }
    
    // info
    public class func i( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString()) \(LogEvent.i.rawValue)[\(sourceFileName(filePath: filename))]
            Line:\(line)
            Column:\(column)
            Function:\(funcName) ->
            \(object)
            ------------------------------------------------------------------------------------
            """)
    }
    
    // debug
    public class func d( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString()) \(LogEvent.d.rawValue)[\(sourceFileName(filePath: filename))]
            Line:\(line)
            Column:\(column)
            Function:\(funcName) ->
            \(object)
            ------------------------------------------------------------------------------------
            """)
    }
    
    // verbose
    public class func v( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString()) \(LogEvent.v.rawValue)[\(sourceFileName(filePath: filename))]
            Line:\(line)
            Column:\(column)
            Function:\(funcName) ->
            \(object)
            ------------------------------------------------------------------------------------
            """)
    }
    
    // warning
    public class func w( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString()) \(LogEvent.w.rawValue)[\(sourceFileName(filePath: filename))]
            Line:\(line)
            Column:\(column)
            Function:\(funcName) ->
            \(object)
            ------------------------------------------------------------------------------------
            """)
    }
    
    // severe
    public class func s( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString()) \(LogEvent.s.rawValue)[\(sourceFileName(filePath: filename))]
            Line:\(line)
            Column:\(column)
            Function:\(funcName) ->
            \(object)
            ------------------------------------------------------------------------------------
            """)
    }
    
    private class func print(_ object: Any) {
        // Only allowing in DEBUG mode
        #if DEBUG
        Swift.print(object)
        #endif
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
}

// MARK: - Date Extension - toString(dateFormatted)
extension Date {
    
    func toString() -> String {
        return LogUtil.dateFormatter.string(from: self)
    }
    
}
