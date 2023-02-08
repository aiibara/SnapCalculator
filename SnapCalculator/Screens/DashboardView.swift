//
//  DashboardView.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 07/02/23.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var vm : CalculatorViewModel = CalculatorViewModel()
    @StateObject var textRecoqnizerVM = TextRecoqnizerViewModel()
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
                        if let image = textRecoqnizerVM.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
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
        }
        
        .background(Color.atlasWhite)
        .sheet(isPresented: $isShowScannerView) {
            ImagePicker(vm: textRecoqnizerVM)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
