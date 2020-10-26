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
                .frame(height: 64)
            
    
            
            ForEach(tags,  id: \.self) { i in
                VStack (alignment: .center) {
                    HStack {
                        Text("Arabica Parchment")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(Color.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                        
                        Text("Rs 2000 - 3000 / 50 KG")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(Color.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    Spacer()
                        .frame(height: 64)
                }
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
