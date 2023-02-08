//
//  ExpressionVMProtocol.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import Foundation

protocol ExpressionVMProtocol {
    var id : UUID { get }
    var detail: String { get }
    var createdDate: Date { get }
    var result: String { get }
    var storage: Storage { get }
}
