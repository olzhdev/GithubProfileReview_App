//
//  Date+Ext.swift
//  GHFollowers Application
//
//  Created by MAC on 06.07.2022.
//

import Foundation

extension Date {
    func convertToMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
}
