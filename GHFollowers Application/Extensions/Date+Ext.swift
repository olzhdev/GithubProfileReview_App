//
//  Date+Ext.swift
//  GHFollowers Application
//
//  
//

import Foundation

extension Date {
    
    /// Converts date to "MMMM yyyy" string
    /// - Returns: <#description#>
    func convertToMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
