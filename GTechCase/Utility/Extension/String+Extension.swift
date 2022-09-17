//
//  String+Extension.swift
//  GTechCase
//
//  Created by Erhan on 15.09.2022.
//

import Foundation

extension String {
    func formattedDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: self) { 
            return date.formatted(.dateTime.day().month(.wide).year())
        }else{
            return self
        }
    }
}
