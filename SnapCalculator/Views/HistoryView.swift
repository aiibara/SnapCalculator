//
//  HistoryView.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var calculatorVM: CalculatorViewModel
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                ForEach(Array(calculatorVM.savedExpressionsList.enumerated()), id: \.element.id) { (idx, item) in
                    HStack{
                        Image(systemName: item.storage == .fm ? "folder.fill" : "tray.2.fill")
                            .foregroundColor(.atlasWhite)
                        Spacer()
                        VStack(alignment: .trailing){
                            Text(item.result)
                                .bold()
                                .font(.headline)
                                .foregroundColor(Color.metal)
                            Text(item.detail)
                                .font(.callout)
                                .foregroundColor(Color.metal)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.vertical, 5)
                }
                
                .onChange(of: calculatorVM.savedExpressionsList.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
                    .listRowBackground(Color.clear)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .padding(24)
            .onAppear{
                scrollToBottom(proxy: proxy)
            }
            
        }
        
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        if let toId = calculatorVM.savedExpressionsList.last?.id {
            proxy.scrollTo(toId, anchor: .bottom)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(calculatorVM: CalculatorViewModel())
    }
}
