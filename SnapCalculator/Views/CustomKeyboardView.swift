//
//  CustomKeyboardView.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import SwiftUI

struct CustomKeyboardView: View {
    @ObservedObject var vm: CalculatorViewModel
    @AppStorage("theme") var theme : String = "green"
    @Binding var isShowScannerView: Bool
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
        ], spacing: 0) {
            ForEach(Global.keyboard, id: \.self) { btn in
                switch(btn) {
                case .minus, .plus, .multiply, .division:
                    Button {
                        vm.typing(button: btn)
                    } label: {
                        HStack{
                            Spacer()
                            Text(btn.rawValue)
                                .foregroundColor(Color.metal)
                                .font(Font.largeTitle)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 20)
                case .none:
                    VStack{}
                case .saveToFM, .saveToCoreData:
                    Button {
                        guard let storage = Storage(rawValue: btn.rawValue)
                        else { return }
                        
                        vm.saveExpression(storage: storage)
                    } label: {
                        HStack{
                            Spacer()
                            Image(systemName: btn == .saveToFM ? "folder" : "tray.2")
                                .foregroundColor(theme == "green" ? Color.herbal : Color.darkRose)
                                .font(Font.largeTitle)
                            Spacer()
                        }
                    }
                    .frame(height: 80)
                    .disabled(btn == .none)
                case .camera:
                    Button {
                        isShowScannerView = true
                    } label: {
                        HStack{
                            Spacer()
                            Image(systemName: "camera.fill")
                                .foregroundColor(theme == "green" ? Color.herbal : Color.darkRose)
                                .font(Font.largeTitle)
                            Spacer()
                        }
                    }
                    .frame(height: 80)
                    .disabled(btn == .none)
                default:
                    Button {
                        vm.typing(button: btn)
                    } label: {
                        HStack{
                            Spacer()
                            Text(btn.rawValue)
                                .foregroundColor(Color.metal)
                                .font(Font.largeTitle)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 20)
                }
                
                

                
            }
        }
    }
}

struct CustomKeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        CustomKeyboardView(vm: CalculatorViewModel(), isShowScannerView: .constant(false))
    }
}
