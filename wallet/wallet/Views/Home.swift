//
//  Home.swift
//  wallet
//
//  Created by Francisco Gindre on 1/2/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    @Binding var sendZecAmount: Double
    
    @State var showReceiveFunds = false
    @State var showProfile = false
    
    init(amount: Binding<Double> = .constant(Double.zero)) {
        _sendZecAmount = amount
    }
    
    var body: some View {
        
        ZStack {
            
            if $sendZecAmount.wrappedValue > 0 {
                Background(showGradient: $sendZecAmount.wrappedValue > 0)
            } else {
                Color.black
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack(alignment: .center, spacing: 30) {
                
                SendZecView(zatoshi: $sendZecAmount)
                    .opacity($sendZecAmount.wrappedValue > 0 ? 1.0 : 1.0)
                
                if $sendZecAmount.wrappedValue > 0 {
                    BalanceDetail(availableZec: $sendZecAmount.wrappedValue, status: .available)
                } else {
                    Spacer()
                    ActionableMessage(message: "No Balance", actionText: "Fund Now", action: {})
                        .padding()
                }
                Spacer()
                KeyPad()
                    .opacity($sendZecAmount.wrappedValue > 0 ? 1.0 : 0.3)
                    .disabled($sendZecAmount.wrappedValue <= 0)
                
                Spacer()
                
                Button(action: {}) {
                    Text("Syncing")
                        
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(Color.zAmberGradient2, lineWidth: 4)
                    )
                }
                
                Spacer()
                
                Button(action: {})  {
                    HStack(alignment: .center, spacing: 10) {
                        Image("wallet_details_icon")
                        Text("Wallet Details")
                            .font(.headline)
                    }.accentColor(Color.zLightGray)
                }
                Spacer()
                
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    self.showReceiveFunds = true
                }) {
                    Image("QRCodeIcon")
                        .accessibility(label: Text("Receive Funds"))
                        .scaleEffect(0.5)
                }, trailing:
                    Button(action: {
                        self.showProfile = true
                    }) {
                        Image(systemName: "person.crop.circle")
                        .imageScale(.large)
                        .accessibility(label: Text("Your Profile"))
                        .padding()
                    })
            .sheet(isPresented: $showReceiveFunds){
                ReceiveFunds(address: "Ztestsapling1ctuamfer5xjnnrdr3xdazenljx0mu0gutcf9u9e74tr2d3jwjnt0qllzxaplu54hgc2tyjdc2p6")
                .navigationBarHidden(false)
                .navigationBarTitle("", displayMode: .inline)
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(amount: .constant(0))
    }
}
