//
//  Moon.swift
//  SpaceWalk
//
//  Created by Nianwen Dan on 2/1/24.
//

import SwiftUI

struct Moon: View {
    @Binding var weightOnEarth: Int
    @Binding var weightOnMoon: Double
    @Binding var extraWords: String
//    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            Form {
                Section {
                    VStack {
                        Text("I feel much lighter")
                        moonIcon
                    }
                }
                Section {
                    Text("Your Weight on Earth: \(weightOnEarth) Ibs")
                    Text("Your Weight on Moon: \(String(format: "%.2f", weightOnMoon)) Ibs")
                }
                .onAppear() {
                    weightOnMoon = moonWeight(is: weightOnEarth)
                }
                Section {
//                    Button("Back to Earth") {
//                        extraWords = "Comming from Moon"
//                        path.removeLast(path.count)
//                    }
                    NavigationLink("Go to Jupiter", value: "jupiter")
                }
            }
        }
        .navigationTitle("Moon")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
    
    func moonWeight(is weight: Int) -> Double {
        Double(weight) / 6.0
    }
    
    var moonIcon: some View {
        VStack {
            Image(.moon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: .bottomLeading)
        }
    }
}

#Preview {
    Moon(weightOnEarth: .constant(0), weightOnMoon: .constant(0), extraWords: .constant(""))
}
