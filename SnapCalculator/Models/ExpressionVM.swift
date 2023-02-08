//
//  ExpressionVM.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import Foundation

struct ExpressionVM: ExpressionVMProtocol {
    let expression: Expression
    
    var id: UUID {
        expression.id
    }
    
    var detail: String {
        expression.detail
    }
    
    var createdDate: Date {
        expression.createdDate
    }
    
    var result: String {
        expression.result
    }
    
    var storage: Storage {
        expression.storage
    }
}
