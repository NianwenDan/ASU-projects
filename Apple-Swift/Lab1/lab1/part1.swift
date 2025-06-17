//
//  part1.swift
//  lab1
//
//  Created by Nianwen Dan on 1/23/24.
//

import SwiftUI

struct part1: View {
    @State var inputWeight = ""
    @State var inputHeight = ""
    @State var weight = 0.0
    @State var height = 0.0
    @State var bmi = 0.0
    @State var idealWeight = 0.0
    @State var offset = 0.0
    @State private var didFail = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                adjuster
                Spacer()
                calcButton
                Spacer()
                infoDisplayer
                Spacer()
            }
            .navigationTitle("Part I")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
    
    func converter() {
        let inputWeight = Double(inputWeight)
        let inputHeight = Double(inputHeight)
        if let inputWeight = inputWeight, let inputHeight = inputHeight {
            weight = inputWeight
            height = inputHeight
        } else {
            weight = 0.0
            height = 0.0
        }
    }
    
    var adjuster: some View {
        VStack {
            HStack {
                Text("Weight(lb): ")
                    .frame(width: 90, alignment: .trailing)
                TextField("100", text: $inputWeight)
                    .onChange(of: inputWeight) {
                        converter()
                    }
            }
            HStack {
                Text("Height(In): ")
                    .frame(width: 90, alignment: .trailing)
                TextField("60", text: $inputHeight)
                    .onChange(of: inputHeight) {
                        converter()
                    }
            }
        }
        .keyboardType(.decimalPad)
        .textFieldStyle(.roundedBorder)
    }
    
    func calculate() {
        bmi = (weight / (height * height)) * 703.0
        idealWeight = 5.0 * bmi + (bmi / 5.0) * (height - 60.0)
        offset = weight - idealWeight
    }
    
    var calcButton: some View {
        VStack {
            let tolerance = 0.001
            Button("Calculate") {
                calculate()
            }
            .disabled(weight - 0 <= tolerance || height - 0 <= tolerance)
        }
        .buttonStyle(.borderedProminent)
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
    part1()
}
