//
//  AboutView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("WeatherWise")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Version 1.0")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer().frame(height: 30)
            
            Text("Developed by Rocien Nkunga")
                .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle("About")
    }
}
