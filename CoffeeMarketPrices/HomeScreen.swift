//
//  HomeScreen.swift
//  CoffeeMarketPrices
//
//  Created by Rohith Thammaiah on 06/09/20.
//  Copyright © 2020 Rohith Thammaiah. All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    var tags: [Int] = [0,1,2,3]
    
    var body: some View {
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
            
            GridStack(rows: 3, columns: 2) { row, col in
                SpiceView()
                .padding()
            }
            
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

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
