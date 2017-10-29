//
//  Date++.swift
//  carryonex
//
//  Created by Xin Zou on 10/1/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

// https://stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
extension Date {
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    // https://stackoverflow.com/questions/30083756/ios-nsdate-returns-incorrect-time/30084248#30084248
    func getCurrentLocalizedDate() -> Date {
        var now = self //Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year      = Calendar.current.component(.year, from: now)
        nowComponents.month     = Calendar.current.component(.month, from: now)
        nowComponents.day       = Calendar.current.component(.day, from: now)
        nowComponents.hour      = Calendar.current.component(.hour, from: now)
        nowComponents.minute    = Calendar.current.component(.minute, from: now)
        nowComponents.second    = Calendar.current.component(.second, from: now)
        nowComponents.timeZone  = TimeZone(abbreviation: "GMT")!
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
    
    static func getTimestampNow() -> Int {
        return Int(NSDate.timeIntervalSinceReferenceDate)
    }
}

/* usage:
 
 let date1 = DateComponents(calendar: .current, year: 2014, month: 11, day: 28, hour: 5, minute: 9).date!
 let date2 = DateComponents(calendar: .current, year: 2015, month: 8, day: 28, hour: 5, minute: 9).date!
 
 let years = date2.years(from: date1)     // 0
 let months = date2.months(from: date1)   // 9
 let weeks = date2.weeks(from: date1)     // 39
 let days = date2.days(from: date1)       // 273
 let hours = date2.hours(from: date1)     // 6,553
 let minutes = date2.minutes(from: date1) // 393,180
 let seconds = date2.seconds(from: date1) // 23,590,800
 
 let timeOffset = date2.offset(from: date1) // "9M"
 
 let date3 = DateComponents(calendar: .current, year: 2014, month: 11, day: 28, hour: 5, minute: 9).date!
 let date4 = DateComponents(calendar: .current, year: 2015, month: 11, day: 28, hour: 5, minute: 9).date!
 
 let timeOffset2 = date4.offset(from: date3) // "1y"
 
 let date5 = DateComponents(calendar: .current, year: 2017, month: 4, day: 28).date!
 let now = Date()
 let timeOffset3 = now.offset(from: date5) // "1w"
 */
