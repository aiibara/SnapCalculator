//
//  DashboardView.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 07/02/23.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var vm : CalculatorViewModel = CalculatorViewModel()
    @AppStorage("theme") var theme : String = "green"
    @AppStorage("saveTo") var saveTo : String = "fm"
    @State var isShowScannerView: Bool = false
    @State var isShowImagePicker: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                
                VStack(alignment: .leading){
                    HStack{
                        Spacer()
                        CustomThemeSwitch()
                    }
                    .padding(.horizontal, 24)
                    
                    VStack{
                        if isShowImagePicker {
                            ImagePickerView(calculatorVM: vm, isShow: $isShowImagePicker)
                        } else {
                            HistoryView(calculatorVM: vm)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(theme == "green" ? Color.herbal : Color.darkRose)
                .animation(.easeInOut, value: theme)
                
                VStack(alignment: .trailing){
                    Text(vm.result)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(1)
                        .font(.largeTitle)
                    TextField("", text: $vm.detail)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.trailing)
                        .font(.title3)
                    
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
            VStack{
                CustomKeyboardView(vm: vm, isShowScannerView: $isShowScannerView)
            }
                
//            Button {
//                vm.saveExpression()
//            } label: {
//                Text("save expression")
//            }
//
//            ForEach(vm.savedExpressionsList, id:\.id) { item in
//                VStack{
//                    Text(item.detail)
//                    Text(item.id.uuidString)
//                    Text(item.createdDate?.formatted() ?? "")
//                    Text(item.storage.rawValue)
//                }
//            }
        }
        
        .background(Color.atlasWhite)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
