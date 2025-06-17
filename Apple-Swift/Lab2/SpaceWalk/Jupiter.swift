//
//  Jupiter.swift
//  SpaceWalk
//
//  Created by Nianwen Dan on 2/1/24.
//

import SwiftUI

struct Jupiter: View {
    @Binding var weightOnEarth: Int
    @Binding var weightOnMoon: Double
    @Binding var extraWords: String
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            Form {
                Section {
                    VStack {
                        Text("I feel heavier!")
                        jupiterIcon
                    }
                }
                Section {
                    Text("Your Weight on Earth: \(weightOnEarth) Ibs")
                    let weightOnJupiter: String = String(format: "%.2f", jupiterWeight(is: weightOnEarth))
                    Text("Your Weight on Jupiter: \(weightOnJupiter) Ibs")
                    Text("Your Weight on Moon: \(String(format: "%.2f", weightOnMoon)) Ibs")
                }
                Section {
                    Button("Back to Earth") {
                        extraWords = "Comming from Jupiter"
                        path.removeLast(path.count)
                    }
                    Button("Back to Moon") {
                        path.removeLast()
                    }
                }
            }
        }
        .navigationTitle("Jupiter")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
    
    func jupiterWeight(is weight: Int) -> Double {
        Double(weight) * 2.4
    }
    
    var jupiterIcon: some View {
        VStack {
            Image(.jupiter)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: .bottomLeading)
        }
    }
}

#Preview {
    Jupiter(weightOnEarth: .constant(0), weightOnMoon: .constant(0), extraWords: .constant(""), path: .constant(NavigationPath()))
}
