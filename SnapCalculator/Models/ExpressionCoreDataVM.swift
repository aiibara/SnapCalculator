//
//  ExpressionCoreDataVM.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import Foundation

struct ExpressionCoreDataVM: ExpressionVMProtocol {
    let expression: ExpressionCoreData
    
    var id: UUID {
        expression.id ?? UUID()
    }
    
    var detail: String {
        expression.detail ?? ""
    }
    
    var createdDate: Date {
        expression.createdDate ?? Date()
    }
    
    var result: String {
        expression.result ?? "0"
    }
    
    var storage: Storage {
        Storage(rawValue: expression.storage ?? "cd") ?? .cd
    }
}
