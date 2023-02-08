//
//  CoreDataManager.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import Foundation

class CoreDataDataManager: DataManagerProtocol {
    static let shared = CoreDataDataManager()
    let context = PersistenceController.shared.container.viewContext
    
    func save(expression: Expression) -> Result<String, Error> {
        let expData = ExpressionCoreData(context: context)
        expData.convertExpression(expression: expression)
        guard save() == true else {
            return .failure(DataError.saveError)
        }
        return .success("success save to CoreData")
    }
    
    func getData() -> Result<[Expression], Error> {
        do {
            let req = ExpressionCoreData.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
            let datas: [ExpressionCoreData] = try context.fetch(req)
            let result = datas.map({ $0.convertExpressionCoreData() })
            return .success(result)
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
    }
    
    func removeData() -> Result<String, Error> {
        return .success("success remove from CoreData")
    }
    
    func save() -> Bool {
        do {
            try context.save()
            return true
        }catch {
            context.rollback()
            print(error)
            return false
        }
    }
}

extension ExpressionCoreData {
    
    func convertExpression(expression: Expression) {
        self.createdDate = expression.createdDate
        self.storage = expression.storage.rawValue
        self.detail = expression.detail
        self.id = expression.id
        self.result = expression.result
    }
    
    func convertExpressionCoreData() -> Expression {
        var expression = Expression(detail: self.detail ?? "", createdDate: self.createdDate ?? Date(), result: self.result ?? "0", storage: Storage(rawValue: self.storage ?? "cd") ?? .cd)
        expression.id = self.id ?? UUID()
        return expression
    }
}
