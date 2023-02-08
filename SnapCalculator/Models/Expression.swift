//
//  Expression.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 07/02/23.
//

import Foundation

struct Expression: Codable, Identifiable {
    var id = UUID()
    var detail: String
    var createdDate: Date
    var result: String
    var storage: Storage
    
}
