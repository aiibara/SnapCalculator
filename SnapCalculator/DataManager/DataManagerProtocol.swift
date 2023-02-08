//
//  DataManagerProtocol.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import Foundation

protocol DataManagerProtocol {
    func save(expression: Expression) -> Result<String, Error>
    func getData() -> Result<[Expression], Error>
    func removeData() -> Result<String, Error>
}
