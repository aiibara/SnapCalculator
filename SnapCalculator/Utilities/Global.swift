//
//  Global.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import Foundation

enum KeyboardKey: String {
    case C = "C"
    case division = "/"
    case division_symbol = "÷"
    case multiplication = "*"
    case multiplication_symbol = "×"
    case plus = "+"
    case minus = "-"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case comma = "."
    case none = ""
    case saveToFM = "fm"
    case saveToCoreData = "cd"
    case camera = "camera"
    case gallery = "gallery"
}

struct Global {
    static let keyboard : [KeyboardKey] = [
        .saveToFM, .saveToCoreData, .camera, .gallery,
        .one, .two, .three,.division_symbol,
        .four, .five, .six,.multiplication_symbol,
        .seven, .eight, .nine, .plus,
        .C, .zero, .comma,.minus,
    ]
}
