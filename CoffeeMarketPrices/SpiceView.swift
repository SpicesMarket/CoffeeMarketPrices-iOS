//
//  SpiceView.swift
//  CoffeeMarketPrices
//
//  Created by Rohith Thammaiah on 27/10/20.
//  Copyright © 2020 Rohith Thammaiah. All rights reserved.
//

import SwiftUI

struct SpiceView : View {
    

    var itemWidth: CGFloat
    
    init(_ itemWidth: CGFloat) {
            self.itemWidth = itemWidth
        }
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack {
                Text("Arabica Parchment")
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(10)
                
                HStack {
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 12, height: 10)
                    }
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 12, height: 20)
                    }
                    
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 12, height: 30)
                    }
                    
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 12, height: 40)
                    }
                    
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 12, height: 50)
                    }
                    
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 12, height: 35)
                    }
                    
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 12, height: 32)
                    }
                }.frame(maxHeight: .none)
                
                Text("Rs 2000 - 3000 / 50 KG")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                .padding(10)
                
                Spacer()
            }
        }
        .frame(
            width: itemWidth,
            height: 200
        )
        .padding(2)
        .background(Color("bgCard"))
        .shadow(radius: 5)
        .cornerRadius(10)
    }
}
