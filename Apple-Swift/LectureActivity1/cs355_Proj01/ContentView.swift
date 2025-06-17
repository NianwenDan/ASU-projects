//
//  ContentView.swift
//  cs355_Proj01
//
//  Created by Nianwen Dan on 1/16/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                greeting()
                Spacer()
            }
            .padding()
            .navigationTitle("CSE335 Project 01")
        }
    }
}

struct greeting: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var greeting: String = ""
    @State var wisdom: String = "Today is the first page of a new chapter. Learn passionately, dream big, and welcome to your first day of school!"
    @State var isGainWisdom = false
    var body: some View {
        VStack {
            HStack {
                Text("First Name: ")
                Spacer()
                TextField(
                    "Required",
                    text: $firstName
                )
            }
            
            HStack {
                Text("Last Name: ")
                Spacer()
                TextField(
                    "Required",
                    text: $lastName
                )
            }
            
            Spacer()
            HStack {
                Button(action: {
                    self.greeting = "\(self.firstName) \(self.lastName) Welcome to CSE 335"
                }, label: {
                    Text("🎉 Greeting")
                })
                
                Button(action: {
                    isGainWisdom.toggle()
                }, label: {
                    Text("Gain Wisdom")
                })
                .alert(isPresented: $isGainWisdom) {
                    Alert(title: Text("Wisdom"), message: Text(wisdom), dismissButton: .default(Text("Got it!")))
                }
                
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
            Text(greeting)
            Spacer()
        }
        .textFieldStyle(.roundedBorder)
    }
}

#Preview {
    ContentView()
}
