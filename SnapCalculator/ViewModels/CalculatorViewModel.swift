//
//  CalculatorViewModel.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 07/02/23.
//

import Foundation

class CalculatorViewModel : ObservableObject {
    @Published var detail: String = ""
    @Published var result: String = "0"
    private var detailArray: [String] = [] {
        didSet {
            detail = detailArray.joined()
            result = countResult()
        }
    }
    
    @Published var savedExpressionsList: [Expression] = []
    
    var fmManager = FileManagerDataManager.shared
    var cdManager = CoreDataDataManager.shared
    
    init() {
        getSavedExpressions()
    }
    
    func typing(button: KeyboardKey) {
        switch(button){
        case .C:
            detailArray.removeAll()
        case .plus, .minus, .multiply, .division:
            guard let lastElem = detailArray.last else { return }
            
            if lastElem != KeyboardKey.plus.rawValue &&
                lastElem != KeyboardKey.minus.rawValue &&
                lastElem != KeyboardKey.multiply.rawValue &&
                lastElem != KeyboardKey.division.rawValue
            {
                detailArray.append(button.rawValue)
            } else {
                detailArray[detailArray.endIndex-1] = button.rawValue
            }
        case .comma:
            if let lastElem = detailArray.last, let _ = Double(lastElem) {
                if !lastElem.contains(/\./) {
                    detailArray[detailArray.endIndex-1] = lastElem.appending(button.rawValue)
                }
            } else {
                detailArray.append("0\(button.rawValue)")
            }
        default:
            if let lastElem = detailArray.last {
                detailArray[detailArray.endIndex-1] = lastElem.appending(button.rawValue)
            } else {
                detailArray.append(button.rawValue)
            }
        }
    }
    
    func countResult() -> String {
        var stringDetail = detail
        var multiplyAndDivide = true
        var plusAndMinus = true
        
        while multiplyAndDivide {
            if let match = stringDetail.firstMatch(of: /([\d\.]+)([\*\/])([\d\.]+)/) {
                
                let left = Double(match.1) ?? 0.0
                let right = Double(match.3) ?? 0.0
                let op = KeyboardKey(rawValue: String(match.2))
                var res: Double = 0
                
                switch (op) {
                case .division:
                    res = left / right
                case .multiply:
                    res = left * right
                default:
                    break
                }
                if let range = stringDetail.range(of:match.0) {
                    stringDetail = stringDetail.replacingCharacters(in: range, with:String(res))
                }
//                print(stringDetail)
            } else {
                multiplyAndDivide = false
            }
        }
        
        while plusAndMinus {
            if let match = stringDetail.firstMatch(of: /([\d\.]+)([\-\+])([\d\.]+)/) {
                
                let left = Double(match.1) ?? 0.0
                let right = Double(match.3) ?? 0.0
                let op = KeyboardKey(rawValue: String(match.2))
                var res: Double = 0
                
                switch (op) {
                case .plus:
                    res = left + right
                case .minus:
                    res = left - right
                default:
                    break
                }
                
                if let range = stringDetail.range(of:match.0) {
                    stringDetail = stringDetail.replacingCharacters(in: range, with:String(res))
                }
//                print(stringDetail)
            } else {
                plusAndMinus = false
            }
        }
        
        stringDetail = stringDetail.replacingOccurrences(of: "[\\+\\-\\*\\/]", with: "", options: .regularExpression)
        
        return stringDetail.isEmpty ? "0" : stringDetail
    }
    
    func prepareExpression(storage: Storage) -> Expression? {
        let expression = Expression(detail: self.detail, createdDate: Date(), result: self.result, storage: storage)
        return expression
    }
    
    func saveExpression(storage: Storage) {
        guard !detail.isEmpty,
              let expression = prepareExpression(storage: storage)
        else { return }

        let manager: DataManagerProtocol = storage == .fm ? fmManager : cdManager;
        let result = manager.save(expression: expression)

        switch(result) {
        case .success(let message):
            print(message)
            detailArray.removeAll()
            savedExpressionsList.append(expression)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func getSavedExpressions() {
        let fmResult = fmManager.getData()
        let cdResult = cdManager.getData()
        
        var list: [Expression] = []
        switch(fmResult) {
        case .success(let data):
            list.append(contentsOf: data)
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        switch(cdResult) {
        case .success(let data):
            list.append(contentsOf: data)
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        self.savedExpressionsList = list.sorted(by:{ $0.createdDate < $1.createdDate})
    }
    
    func removeExpression(item: Expression, index: Int) {
        savedExpressionsList.remove(at: index)
    }
    
}
