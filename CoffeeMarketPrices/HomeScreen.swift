//
//  HomeScreen.swift
//  CoffeeMarketPrices
//
//  Created by Rohith Thammaiah on 06/09/20.
//  Copyright © 2020 Rohith Thammaiah. All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 16.0)
            
            Text("Spice Prices")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
                .frame(height: 4.0)
            
            Text("Last updated: 06/09/2020")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .center)
            
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
        ).background(Color("primaryColor"))
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
