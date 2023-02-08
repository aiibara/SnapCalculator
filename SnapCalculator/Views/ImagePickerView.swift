//
//  ImagePickerView.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import SwiftUI

struct ImagePickerView: View {
    @ObservedObject var calculatorVM: CalculatorViewModel
    @Binding var isShow: Bool
    var body: some View {
        Text("image picker")
    }
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(calculatorVM: CalculatorViewModel(), isShow: .constant(true))
    }
}
