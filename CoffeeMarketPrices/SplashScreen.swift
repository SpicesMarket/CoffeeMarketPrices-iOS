//
//  ContentView.swift
//  CoffeeMarketPrices
//
//  Created by Rohith Thammaiah on 05/09/20.
//  Copyright © 2020 Rohith Thammaiah. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    let home = HomeScreen()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Spice Prices")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity,
                           alignment: .center)
                
                NavigationLink(destination: home,
                               isActive: $isActive,
                               label: { EmptyView() })
                
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
            )
                .background(Color("primaryColor"))
                .onAppear(perform: {
                    self.gotoHomeScreen(time: 2.5)
                })
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
    
    func gotoHomeScreen(time: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(time)) {
            self.isActive = true
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
