//
//  main.swift
//  OSTestProject
//
//  Created by 黄穆斌 on 16/11/1.
//  Copyright © 2016年 Myron. All rights reserved.
//

import Foundation

// MARK: Calendar Infos

class CalendarInfo {
    
    // MARK: Value
    
    var calendar: Calendar
    var date: Date
    
    // MARK: Init
    
    init(identifier: Calendar.Identifier = Calendar.current.identifier, date: Date = Date()) {
        self.calendar = Calendar(identifier: identifier)
        self.date = date
    }
    
    init(identifier: Calendar.Identifier = Calendar.current.identifier, date: TimeInterval) {
        self.calendar = Calendar(identifier: identifier)
        self.date = Date(timeIntervalSince1970: date)
    }

    // MARK: Date
    
    var year: Int {
        return calendar.component(Calendar.Component.year, from: date)
    }
    var month: Int {
        return calendar.component(Calendar.Component.month, from: date)
    }
    var day: Int {
        return calendar.component(Calendar.Component.day, from: date)
    }
    /// Sunday is 1
    var weekday: Int {
        return calendar.component(Calendar.Component.weekday, from: date) - 1
    }
    var week: CalendarInfo.Week {
        return CalendarInfo.Week(rawValue: weekday)!
    }
    
    var hour: Int {
        return calendar.component(Calendar.Component.hour, from: date)
    }
    var minute: Int {
        return calendar.component(Calendar.Component.minute, from: date)
    }
    var second: Int {
        return calendar.component(Calendar.Component.second, from: date)
    }
    var weekOfMonth: Int {
        return calendar.component(Calendar.Component.weekOfMonth, from: date)
    }
    var weekOfYear: Int {
        return calendar.component(Calendar.Component.weekOfYear, from: date)
    }
    
    // MARK: Counts
    
    var daysInMonth: Int {
        return CalendarInfo.days(inMonth: month, inYear: year)
    }
    
    var daysInYear: Int {
        return CalendarInfo.days(inYear: year)
    }
    
    // MARK: First
    
    func firstDayInYear() -> Date? {
        return calendar.date(from: calendar.dateComponents([.year], from: date))
    }
    
    func firstDayInMonth() -> Date? {
        return calendar.date(from: calendar.dateComponents([.year, .month], from: date))
    }
    
    func firstTimeInDay() -> Date? {
        return calendar.date(from: calendar.dateComponents([.year, .month, .day], from: date))
    }
    
    // MARK: Advand
    
    func adding(time: TimeInterval) -> Date {
        return date.addingTimeInterval(time)
    }
    
}

// MARK: - Class Methods

extension CalendarInfo {
    
    // MARK: Days
    
    /// month = 0 ~ 11
    class func days(inMonth: Int, inYear: Int) -> Int {
        let total = inYear * 12 + inMonth
        let year = total / 12
        let month = total % 12
        switch month {
        case 2:
            return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) ? 29 : 28
        case 4, 6, 9, 11:
            return 30
        default:
            return 31
        }
    }
    
    class func days(inYear: Int) -> Int {
        return (inYear % 4 == 0 && inYear % 100 != 0) || (inYear % 400 == 0) ? 366 : 365
    }
    
}

// MARK: - Week and Timestamp enums

extension CalendarInfo {
    
    enum Week: Int {
        case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
        
        static func day(_ day: Int) -> Week {
            return Week(rawValue: abs(day % 7))!
        }
        
        init?(day: Int) {
            self.init(rawValue: abs(day % 7))
        }
    }
    
    enum Timestamp: TimeInterval {
        case minute = 60.0
        case hour   = 3600.0
        case day    = 86400.0
        case week   = 604800.0
    }
    
}

// MARK: - Chinese

extension CalendarInfo {
    
    static let Chinese: (Era: [String], CelestialStems: [String], EarthlyBranches: [String], Zodiacs: [String], Months: [String], Days: [String]) = (
        [
            "甲子", "乙丑", "丙寅", "丁卯", "午辰", "己巳", "庚午", "辛未", "壬申", "癸酉",
            "甲戌", "乙亥", "丙子", "丁丑", "午寅", "己卯", "庚辰", "辛巳", "壬午", "癸未",
            "甲申", "乙酉", "丙戌", "丁亥", "午子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳",
            "甲午", "乙未", "丙申", "丁酉", "午戌", "己亥", "庚子", "辛丑", "壬寅", "癸卯",
            "甲辰", "乙巳", "丙午", "丁未", "午申", "己酉", "庚戌", "辛亥", "壬子", "癸丑",
            "甲寅", "乙卯", "丙辰", "丁巳", "午午", "己未", "庚申", "辛酉", "壬戌", "癸亥"
        ],
        ["甲", "乙", "丙", "丁", "午", "己", "庚", "辛", "壬", "癸"],
        ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"],
        ["鼠", "牛", "虎", "兔", "龙", "色", "马", "羊", "猴", "鸡", "狗", "猪"],
        ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"],
        [
            "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
            "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
            "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"
        ]
    )
    
}


// MARK: - Chinese Calendar Info

class ChineseCalendar {
    
    var days: [ChineseCalendar.Day] = []
    
    var date: Date = Date() {
        didSet {
            calendar.date = date
            chinese.date  = date
        }
    }
    private let calendar: CalendarInfo
    private let chinese: CalendarInfo
    
    init() {
        calendar = CalendarInfo(date: date)
        chinese  = CalendarInfo(identifier: .chinese, date: date)
    }
    
    func append(month: Date) {
//        date = month
//        guard let firstDay = calendar.firstDayInMonth() else { return }
//        var isAppendInHead: Bool
//        if let daysFirst = days.first, let daysLast = days.last {
//            let max = Double(Int.max)
//            switch firstDay.timeIntervalSince1970 {
//            case -max ..< daysFirst.timestamp:
//                isAppendInHead = true
//            case daysFirst.timestamp ..< daysLast.timestamp + 86400:
//                return
//            default:
//                isAppendInHead = false
//            }
//        }
//        
//        
//        
//        
//        if isAppendInHead {
//            
//        } else {
//            
//        }
    }
    
    func months(date: Date) -> [ChineseCalendar.Day] {
        let calendar: CalendarInfo = CalendarInfo(date: date)
        let chinese: CalendarInfo  = CalendarInfo(identifier: .chinese, date: date)
        var date: Date {
            get { return calendar.date }
            set { calendar.date = newValue; chinese.date = newValue }
        }
        var days: [ChineseCalendar.Day] = []
        date = calendar.firstDayInMonth()!
        print(calendar.daysInMonth)
        for _ in 0 ..< calendar.daysInMonth {
            let day = ChineseCalendar.Day(year: calendar.year, month: calendar.month, day: calendar.day, weakday: calendar.weekday, cYear: chinese.year, cMonth: chinese.month, cDay: chinese.day, timestamp: date.timeIntervalSince1970)
            days.append(day)
            date = calendar.adding(time: 86400)
        }
        return days
    }
    
}

extension ChineseCalendar {
    
    /**
        01 甲子　	11 甲戌	21 甲申	31 甲午	41 甲辰	51 甲寅
        02 乙丑　	12 乙亥　	22 乙酉　	32 乙未　	42 乙巳　	52 乙卯
        03 丙寅　	13 丙子　	23 丙戌　	33 丙申　	43 丙午　	53 丙辰
        04 丁卯　	14 丁丑　	24 丁亥　	34 丁酉　	44 丁未　	54 丁巳
        05 戊辰　	15 戊寅　	25 戊子　	35 戊戌　	45 戊申　	55 戊午
        06 己巳　	16 己卯　	26 己丑　	36 己亥　	46 己酉　	56 己未
        07 庚午　	17 庚辰　	27 庚寅　	37 庚子　	47 庚戌　	57 庚申
        08 辛未　	18 辛巳　	28 辛卯　	38 辛丑　	48 辛亥　	58 辛酉
        09 壬申　	19 壬午　	29 壬辰　	39 壬寅　	49 壬子　	59 壬戌
        10 癸酉　	20 癸未　	30 癸巳　	40 癸卯　	50 癸丑　	60 癸亥
     */
    static let ChineseEra: [String] = [
        "甲子", "乙丑", "丙寅", "丁卯", "午辰", "己巳", "庚午", "辛未", "壬申", "癸酉",
        "甲戌", "乙亥", "丙子", "丁丑", "午寅", "己卯", "庚辰", "辛巳", "壬午", "癸未",
        "甲申", "乙酉", "丙戌", "丁亥", "午子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳",
        "甲午", "乙未", "丙申", "丁酉", "午戌", "己亥", "庚子", "辛丑", "壬寅", "癸卯",
        "甲辰", "乙巳", "丙午", "丁未", "午申", "己酉", "庚戌", "辛亥", "壬子", "癸丑",
        "甲寅", "乙卯", "丙辰", "丁巳", "午午", "己未", "庚申", "辛酉", "壬戌", "癸亥"
    ]
    
    /** 十天干：甲（jiǎ）、乙（yǐ）、丙（bǐng）、丁（dīng）、戊（wù）、己（jǐ）、庚（gēng）、辛（xīn）、壬（rén）、癸（guǐ）；其中甲、丙、戊、庚、壬为阳干，乙、丁、己、辛、癸为阴干。 */
    static let CelestialStems = ["甲", "乙", "丙", "丁", "午", "己", "庚", "辛", "壬", "癸"]
    
    /** 十二地支：子（zǐ）、丑（chǒu）、寅（yín）、卯（mǎo）、辰（chén）、巳（sì）、午（wǔ）、未（wèi）、申（shēn）、酉（yǒu）、戌（xū）、亥（hài）。其中子、寅、辰、午、申、戌为阳支，丑、卯、巳、未、酉、亥为阴支。 */
    static let EarthlyBranches = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
    
    /** 十二地支对应十二生肖——子-鼠（燕子），丑-牛，寅-虎，卯-兔，辰-龙，巳-蛇， 午-马，未-羊，申-猴，酉-鸡，戌-狗，亥-猪。 */
    static let ChineseZodiacs = ["鼠", "牛", "虎", "兔", "龙", "色", "马", "羊", "猴", "鸡", "狗", "猪"]
    
    /** 月份 */
    static let ChineseMonths = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"]
    
    /** 日期 */
    static let ChineseDays = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
}

// MARK: - Calendar List

protocol DayInfoProtocol { }
extension ChineseCalendar {
    
    class Year {
        var month: [Month] = []
        
        let year: Int
        let cYear: Int
        
        var sYear  : String { return ChineseCalendar.ChineseEra[cYear] }
        
        init(year: Int, cYear: Int) {
            self.year = year
            self.cYear = cYear
        }
    }
    
    class Month {
        var days: [Day] = []
        
        let month: Int
        let cMonth: Int
        
        init(month: Int, cMonth: Int) {
            self.month  = month
            self.cMonth = cMonth
        }
    }
    
    class Day {
        
        // MARK: Day Other
        
        var info: DayInfoProtocol?
        
        // MARK: Day Info
        
        let day     : Int
        let month   : Int
        let year    : Int
        let weakday : Int
        
        let cYear   : Int
        let cMonth  : Int
        let cDay    : Int
        let isIntercalayMonth : Bool
        
        let timestamp: TimeInterval
        
        var sYear  : String { return ChineseCalendar.ChineseEra[cYear] }
        var sMonth : String { return (isIntercalayMonth ? "润" : "") + ChineseCalendar.ChineseMonths[cMonth] }
        var sDay   : String { return ChineseCalendar.ChineseDays[cDay] }
        var sZodiac: String { return ChineseCalendar.ChineseZodiacs[cYear % 12] }
        
        
        init(year: Int, month: Int, day: Int, weakday: Int, cYear: Int, cMonth: Int, cDay: Int, timestamp: TimeInterval, isIntercalayMonth: Bool = false) {
            self.year    = year
            self.month   = month
            self.day     = day
            self.weakday = weakday
            
            self.cYear  = cYear - 1
            self.cMonth = cMonth - 1
            self.cDay   = cDay - 1
            
            self.timestamp = timestamp
            
            self.isIntercalayMonth = isIntercalayMonth
        }
        
    }
    
}



// MARK: - Test

let form = DateFormatter()
form.dateFormat = "yyyy-MM-dd HH"
let date = form.date(from: "2016-11-16 12")!
print(date.timeIntervalSince1970)
print(form.string(from: date))
//let cal = Calendar(identifier: Calendar.Identifier.chinese)
let cal = Calendar.current

var week: Date = Date()
var intervalu: TimeInterval = 0
let _ = cal.dateInterval(of: Calendar.Component.weekOfYear, start: &week, interval: &intervalu, for: date)
print(form.string(from: week))


//let ddd = cal.date(from: cal.dateComponents([.weekOfYear], from: date))
//var eeee = Date()
//var tttt = TimeInterval(0)
//print(cal.dateInterval(of: Calendar.Component.weekOfYear, start: &eeee, interval: &tttt, for: date))
//
//if #available(OSX 10.12, *) {
//    let inter = cal.dateIntervalOfWeekend(containing: date)
//    print(inter?.start ?? "nil")
//} else {
//    // Fallback on earlier versions
//}
//let time = Double(Int(date.timeIntervalSince1970 / 604800) * 604800)
//print(form.string(from: Date(timeIntervalSince1970: time)))
//
//
//print(form.string(from: eeee))
//print(tttt)
//print(ddd?.timeIntervalSince1970)
//print(form.string(from: ddd!))
//
//print(ddd!.timeIntervalSince1970 - date.timeIntervalSince1970)

