//
//  DashboardView.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 07/02/23.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var vm : CalculatorViewModel = CalculatorViewModel()
    @StateObject var textRecognizerVM = TextRecognizerViewModel()
    @AppStorage("theme") var theme : String = "green"
    @AppStorage("saveTo") var saveTo : String = "fm"
    @State var isShowScannerView: Bool = false
    @State var isShowImagePickerView: Bool = false
    
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
                        if let image = textRecognizerVM.image {
                            ZStack(alignment: .topTrailing){
                                HStack {
                                    Spacer()
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    Spacer()
                                }
                                Button {
                                    textRecognizerVM.image = nil
                                } label: {
                                    HStack{
                                        Image(systemName: "x.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color.white)
                                            .opacity(0.5)
                                    }
                                    .padding(.top, 20)
                                    .padding(.trailing, 24)
                                }
                                
                            }
                            .background(Color.black)
                            
                        }
                        else {
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
            
            if !isShowScannerView {
                VStack{
                    CustomKeyboardView(vm: vm, isShowScannerView: $isShowScannerView, isShowImagePickerView: $isShowImagePickerView)
                }
            }
            
        }
        
        .background(Color.atlasWhite)
        .sheet(isPresented: $isShowImagePickerView) {
            ImagePicker(vm: textRecognizerVM, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $isShowScannerView) {
//            ScannerView(vm: textRecognizerVM)
            ImagePicker(vm: textRecognizerVM, sourceType: .camera)
        }
        .onChange(of: textRecognizerVM.recognizedExpression) { newValue in
            vm.processDetailFromRecognizer(detail: newValue)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
