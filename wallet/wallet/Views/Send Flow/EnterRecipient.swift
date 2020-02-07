//
//  EnterRecipient.swift
//  wallet
//
//  Created by Francisco Gindre on 1/7/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import SwiftUI
import Combine
class EnterRecipientViewModel: ObservableObject {
    
    @Published var showScanView = false
    
    var dispose = Set<AnyCancellable>()
    
}
struct EnterRecipient: View {
    
    @EnvironmentObject var flow: SendFlowEnvironment
    
    @ObservedObject var viewModel = EnterRecipientViewModel()
    var availableBalance: Bool {
        flow.verifiedBalance > 0
    }
    
    var amountSubtitle: String {
        if availableBalance, let balance = NumberFormatter.zecAmountFormatter.string(from: NSNumber(value: flow.verifiedBalance)) {
            return "You Have \(balance) sendable ZEC"
        } else {
            return "You don't have any sendable ZEC yet"
        }
    }
    
    var validAddress: Bool {
        flow.address.count > 0
    }
    
    var validForm: Bool {
        availableBalance && validAddress
    }
    
    var addressInBuffer: AnyView {
        guard let clipboard = UIPasteboard.general.string,
            clipboard.shortZaddress != nil else {
                return AnyView(EmptyView())
        }
        
        return AnyView(
            ActionableMessage(message: "Zcash address in buffer", actionText: "Paste", action: { self.flow.address = clipboard })
                )
    }
    
    var body: some View {
        ZStack {
            ZcashBackground()
            
            VStack(alignment: .leading, spacing: 20) {
                
                Spacer().frame(height: 96)
                ZcashTextField(
                    title: "To",
                    subtitle: "Enter a shielded Zcash address",
                    keyboardType: UIKeyboardType.alphabet,
                    binding: $flow.address,
                    action: {
                        self.viewModel.showScanView = true
                },
                    accessoryIcon: Image("QRCodeIcon")
                        .renderingMode(.original)
                ).sheet(isPresented: $viewModel.showScanView) {
                    ScanAddress(
                        viewModel: ScanAddressViewModel(
                            address: self.$flow.address,
                            shouldShow: self.$viewModel.showScanView
                        )
                    ).environmentObject(SceneDelegate.shared.environment!)
                }
                
                ZcashTextField(
                    title: "Amount",
                    subtitle: "You have \(flow.verifiedBalance) sendable ZEC",
                    keyboardType: UIKeyboardType.decimalPad,
                    binding: $flow.amount
                )
                
                
                addressInBuffer
                Spacer()
                NavigationLink(destination: AddMemo().environmentObject(flow)){
                    ZcashButton(color: Color.black, fill: Color.zYellow, text: "Next")
                        .frame(height: 58)
                        .padding([.leading, .trailing], 40)
                }
                    .opacity(validForm ? 1.0 : 0.3 ) // validate this
                    .disabled(!validForm)
                Spacer()
                
            }.padding([.horizontal], 24)
            
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }.navigationBarItems(trailing: Image("infobutton"))
        .onAppear() {
           
        }
       
    }
    
}



struct EnterRecipient_Previews: PreviewProvider {
    static var previews: some View {
        EnterRecipient().environmentObject(SendFlowEnvironment(amount: 1.2345, verifiedBalance: 23.456))
    }
}
