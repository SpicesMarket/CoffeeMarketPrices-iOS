//
//  HomeScreen.swift
//  CoffeeMarketPrices
//
//  Created by Rohith Thammaiah on 06/09/20.
//  Copyright © 2020 Rohith Thammaiah. All rights reserved.
//

import SwiftUI

//@available(iOS 14,*)
struct HomeScreen: View {
    
    var body: some View {
        
        ScrollView() {
        VStack {
            Spacer()
                .frame(height: 16.0)
            
            Text("Spice Prices")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
                .frame(height: 4.0)
            
            Text("Last updated: 06/09/2020")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
                .frame(height: 24)
            
            let halfSpan = (UIScreen.main.bounds.width / 2) - 16
            
            GridStack(rows: 3, columns: 2) { row, col in
                if row == 3 && col == 2 {
                    SpiceView(UIScreen.main.bounds.width)
                        .padding(4)
                } else {
                    SpiceView(halfSpan)
                        .padding(4)
                }
                SpiceView(UIScreen.main.bounds.width)
                    .padding(4)
            }
            
            Spacer()
                .frame(height: 48)
            
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
        ).background(Color("primaryColor"))
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
