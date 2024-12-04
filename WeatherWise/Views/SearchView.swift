//
//  SearchView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 03/12/2024.
//

import SwiftUI

struct SearchView: View {
    @State private var cityName: String = ""
    @Environment(\.presentationMode) var presentationMode // to dismiss the view
    var onCitySelected: (String) -> Void // Callback to add the city

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter city name", text: $cityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    if !cityName.isEmpty {
                        onCitySelected(cityName)
                        presentationMode.wrappedValue.dismiss() // this to go back to the previous screen
                    }
                }) {
                    Text("Add City")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .navigationTitle("Search City")
        }
    }
}
