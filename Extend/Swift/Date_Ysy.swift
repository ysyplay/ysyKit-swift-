//
//  Date_Ysy.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//
import UIKit
import Foundation

//这里单独写命名空间的原因：Date不是class而是struct，所以当拓展命名空间时，where只能配合 == 使用，而不能使用:（继承），这会造成代码提示无法根据target过滤，造成大量无关的代码提示（这里因该是xcode的bug),所以这里单独写一个命名空间避免污染
//另外计算属性的提示也无法过滤，为了避免提示污染尽量少用
extension Date {
    var ysy: YsyDate {
           set {}
           get {
               YsyDate(self)
           }
       }
       static var ysy:YsyDate.Type{
           set {}
           get {
               YsyDate.self
           }
       }
}
//前缀命名空间类
class YsyDate {
    let target:Date
    init(_ target:Date) {
        self.target = target
    }
}


// MARK: 只读计算属性
extension YsyDate {
    
    /// 年
    var year: Int {
        return Calendar.current.component(.year, from: target)
    }
    
    /// 月
    var month: Int {
        return Calendar.current.component(.month, from: target)
    }
    
    /// 日期
    var day: Int {
        return Calendar.current.component(.day, from: target)
    }
    
    /// 时
    var hour: Int {
        return Calendar.current.component(.hour, from: target)
    }
    
    /// 分
    var minute: Int {
        return Calendar.current.component(.minute, from: target)
    }
    
    /// 秒
    var second: Int {
        return Calendar.current.component(.second, from: target)
    }
    /// 纳秒
    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: target)
    }
    
    /// 季度
    var quarter: Int {
        return Calendar.current.component(.quarter, from: target)
    }
    
    /// 星期 1～7 默认第一天为星期天，可以在设置中进行设置修改
    var weekday: String  {
        var str = ""
        switch Calendar.current.component(.weekday, from: target) {
            case 1:
                str = "日"
            case 2:
                str = "一"
            case 3:
                str = "二"
            case 4:
                str = "三"
            case 5:
                str = "四"
            case 6:
                str = "五"
            case 7:
                str = "六"
            default:
                str = ""
        }
        return str
    }
    
    /// 当前月份的工作周第几周
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekdayOrdinal, from: target)
    }
    
    /// 当前月的第几周 1~5
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: target)
    }
    
    /// 当年的第几周 1~53
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: target)
    }
    /// 基于ISO week date
    /// https://en.wikipedia.org/wiki/ISO_week_date
    var yearForWeakOfYear: Int {
        return Calendar.current.component(.yearForWeekOfYear, from: target)
    }
    
    /// 是否闰月
    var isLeapMonth: Bool {
        return Calendar.current.dateComponents([.quarter], from: target).isLeapMonth ?? false
    }
    
    /// 是否是闰年
    var isLeapYear: Bool {
        return (year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0))
    }
    
    /// 是否是今天
    var isToday: Bool {
        if fabs(target.timeIntervalSinceNow) > 60 * 60 * 24 { return false }
        return Date().ysy.day == day
    }
    
    
    
    /// ISO 8601格式
    var isoFormat: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: target)
    }
}

// MARK: 对象方法
extension YsyDate{
    
    /// 返回增加指定年数后的日期
    ///
    /// - Parameter years: 年数
    /// - Returns: 如果年数增加后错误则返回当前日期
    func adding(years: Int) -> Date {
        var components = DateComponents()
        components.year = years
        return Calendar.current.date(byAdding: components, to: target) ?? target
    }
    
    /// 返回增加指定月数后的日期
    ///
    /// - Parameter months: 月数
    /// - Returns: 如果月数增加后错误则返回当前日期
    func adding(months: Int) -> Date {
        var components = DateComponents()
        components.month = months
        return Calendar.current.date(byAdding: components, to: target) ?? target
    }
    
    
    /// 返回增加指定周数后的日期
    ///
    /// - Parameter weaks: 周数
    /// - Returns: 如果周数增加后错误则返回当前日期
    func adding(weaks: Int) -> Date {
        var components = DateComponents()
        components.weekOfYear = weaks
        return Calendar.current.date(byAdding: components, to: target) ?? target
    }
    
    /// 返回增加指定天数后的日期
    ///
    /// - Parameter days: 天数
    /// - Returns: 如果天数增加后错误则返回当前日期
    func adding(days: Int) -> Date {
        var components = DateComponents()
        components.day = days
        return Calendar.current.date(byAdding: components, to: target) ?? target
    }
    
    /// 返回增加指定小时数后的日期
    ///
    /// - Parameter hours: 小时数
    /// - Returns: 如果小时数增加后错误则返回当前日期
    func adding(hours: Int) -> Date {
        var components = DateComponents()
        components.hour = hours
        return Calendar.current.date(byAdding: components, to: target) ?? target
    }
    
    /// 返回增加指定分钟数后的日期
    ///
    /// - Parameter minutes: 分钟数
    /// - Returns: 如果分钟数增加后错误则返回当前日期
    func adding(minutes: Int) -> Date {
        var components = DateComponents()
        components.minute = minutes
        return Calendar.current.date(byAdding: components, to: target) ?? target
    }
    
    /// 返回增加指定秒数后的日期
    ///
    /// - Parameter seconds: 秒数
    /// - Returns: 如果秒数增加后错误则返回当前日期
    func adding(seconds: Int) -> Date {
        var components = DateComponents()
        components.second = seconds
        return Calendar.current.date(byAdding: components, to: target) ?? target
    }
    
    /// 返回指定格式的字符串
    ///
    ///     date.string(format: "yyyy-MM-dd HH:mm:ss")
    ///
    /// - Parameters:
    ///   - format: 日期格式
    ///   - timeZone: 时区 默认当前时区
    ///   - locale: 地区 默认当前地区
    /// - Returns: 日期字符串
    func string(format: String, timeZone: TimeZone? = nil, locale: Locale? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let timeZone = timeZone { formatter.timeZone = timeZone } else { formatter.timeZone = .current }
        if let locale = locale { formatter.locale = locale } else { formatter.locale = .current }
        return formatter.string(from: target)
    }
    
    /// 时间戳
    func timeStamp() -> Int {
        let timeSp = target.timeIntervalSince1970
        return Int(timeSp)
    }
}

// MARK: 类方法
extension YsyDate {
    
    /// 将日期字符串根据指定格式转换为日期对象
    ///
    /// - Parameters:
    ///   - str: 日期字符串
    ///   - format: 日期格式
    ///   - timeZone: 时区
    ///   - locale: 地区
    /// - Returns: 日期对象
    static func date(for strDate: String, format: String, timeZone: TimeZone? = nil, locale: Locale? = nil) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let timeZone = timeZone { formatter.timeZone = timeZone }
        if let locale = locale { formatter.locale = locale }
        return formatter.date(from: strDate)
    }
    
    /// 将ISO 8601格式的字符串转换为日期对象
    ///
    /// - Parameter isoDate: ISO 8601格式日期字符串
    /// - Returns: 日期对象
    static func date(isoDate: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: isoDate)
    }
}
