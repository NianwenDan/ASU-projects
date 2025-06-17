//
//  part2.swift
//  lab1
//
//  Created by Nianwen Dan on 1/23/24.
//

import SwiftUI

struct part2: View {
    @State var weight = 100.0
    @State var height = 60.0
    @State var bmi = 0.0
    @State var idealWeight = 0.0
    @State var offset = 0.0
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                adjuster
                Spacer()
                infoDisplayer
                Spacer()
            }
            .navigationTitle("Part II")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
    
    var adjuster: some View {
        VStack (spacing: 20){
            Text("Weight(lb): " + String(format: "%.2f", weight))
            Slider(value: $weight, in: 10.0...220.0)
            Text("Height(In): " + String(format: "%.2f", height))
            Slider(value: $height, in: 10.0...80.0)
        }
        .onAppear {
            calculate()
        }
        .onChange(of: weight) {
            calculate()
        }
        .onChange(of: height) {
            calculate()
        }
    }
    
    func calculate() {
        bmi = (weight / (height * height)) * 703.0
        idealWeight = 5.0 * bmi + (bmi / 5.0) * (height - 60.0)
        offset = weight - idealWeight
    }
    
    var infoDisplayer: some View {
        VStack {
            Text("Your BMI: " + String(format: "%.1f", bmi))
            Text("Your Ideal Weight: \(Int(idealWeight))")
            // currentweight + 20 = idea
            if offset > 20 {
                Text("You are overweight")
                    .foregroundStyle(Color(.red))
            } else if offset > 10 && offset <= 20 {
                Text("You need to control your weight")
                    .foregroundStyle(Color(.blue))
            } else if offset > 5 && offset <= 10 {
                Text("You need to watch your weight gain")
                    .foregroundStyle(Color(.purple))
            } else if offset > -5 && offset <= 5 {
                Text("You are in good shape")
                    .foregroundStyle(Color(.green))
            } else {
                Text("You need eat more carb")
                    .foregroundStyle(Color(.yellow))
            }
        }
        .bold()
    }
}

#Preview {
    part2()
}
