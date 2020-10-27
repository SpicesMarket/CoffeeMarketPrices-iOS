//
//  SpiceView.swift
//  CoffeeMarketPrices
//
//  Created by Rohith Thammaiah on 27/10/20.
//  Copyright © 2020 Rohith Thammaiah. All rights reserved.
//

import SwiftUI

struct SpiceView : View {
    var body: some View {
        VStack (alignment: .center) {
            VStack {
                Text("Arabica Parchment")
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                
                HStack {
                    VStack {
                        Spacer()
                        Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 10)
                    }
                    VStack {
                        Spacer()
                        Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                    }
                    
                    VStack {
                        Spacer()
                        Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 30)
                    }
                    
                    VStack {
                        Spacer()
                        Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 40)
                    }
                    
                    VStack {
                        Spacer()
                        Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 50)
                    }
                    
                    VStack {
                        Spacer()
                        Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 35)
                    }
                    
                    VStack {
                        Spacer()
                        Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 32)
                    }
                }.frame(maxHeight: .none)
                
                Text("Rs 2000 - 3000 / 50 KG")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            }
        .background(Color("primaryColor"))
    }
}

struct SpiceView_Previews: PreviewProvider {
    static var previews: some View {
        SpiceView()
    }
}
