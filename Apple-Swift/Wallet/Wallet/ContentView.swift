//
//  ContentView.swift
//  Wallet
//
//  Created by Nianwen Dan on 2/11/23
//

import SwiftUI

// Tempory Storage
var cardDetails = CardDetails()

struct ContentView: View {
    @State private var holderName: String = ""
    @State private var cardBank: String = ""
    @State private var cardTypes: CardType = .visa
    @State private var cardNumber: String = ""
    @State private var cardCvv: String = ""
    @State private var cardExpireDate = Date()
    @State private var cardColor: Color = Colors.blue
    @State private var showCard = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("SIGNATURE")  {
                    TextField("Card Holder Name", text: $holderName)
                    TextField("Bank", text: $cardBank)
                    Picker("Card Type", selection: $cardTypes) {
                        ForEach(CardType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                Section("DETAILS") {
                    TextField("Card Number", text: $cardNumber)
                    TextField("Security Code", text: $cardCvv)
                    DatePicker(
                        "Valid Through",
                        selection: $cardExpireDate,
                        displayedComponents: [.date]
                    )
                }
                Section("CARD COLOR") {
                    //let colors: Array<Color> = [.blue, .pink, .yellow, .green, .purple, .cyan, .gray]
                    let customColors = Colors.all
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(customColors.indices, id: \.self) { index in
                                Circle()
                                    .foregroundStyle(customColors[index])
                                    .frame(width: 50, height: 50)
                                    .opacity(customColors[index] != cardColor ? 0.5 : 1.0)
                                    .scaleEffect(customColors[index] == cardColor ? 1.00 : 0.85)
                                    .onTapGesture {
                                        cardColor = customColors[index]
                                    }
                            }
                        }
                    }
                }
                
                Button(action: {
                    cardDetails.holderName = holderName
                    cardDetails.bank = cardBank
                    cardDetails.type = cardTypes
                    cardDetails.number = cardNumber
                    cardDetails.validity = cardExpireDate
                    cardDetails.secureCode = cardCvv
                    cardDetails.color = cardColor
                    showCard = true
                }, label: {
                    HStack{
                        Spacer()
                        Text("Add Card to Wallet")
                            .bold()
                        Spacer()
                    }
                })
                .disabled(holderName == "" || cardBank == "" || cardNumber == "" || cardCvv == "")
            }
            .sheet(isPresented: $showCard, content: {
                CardPreview()
                    .presentationDetents([.fraction(0.35)])
            })
            .navigationTitle("Add Card")
        }
    }
}

struct CardPreview : View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 330, height: 210)
                .foregroundStyle(cardDetails.color)

            // Card Details Display
            VStack {
                cardBankAndNetwork
                Spacer()
                cardDetail
            }
            .foregroundStyle(.white)
            .padding()
        }
        .padding()
    }
    
    var cardBankAndNetwork : some View {
        HStack {
            Text(cardDetails.bank)
                .font(.largeTitle)
                .textCase(.uppercase)
            Spacer()
            cardDetails.typeLogo
                .resizable()
                .scaledToFit()
                .frame(height: 80)
        }
        .offset(y: -20)
        .padding(10)
    }
    
    var cardDetail : some View {
        VStack (alignment: .leading, spacing: 3) {
            Text(cardDetails.holderName)
                .bold()
                .font(.title2)
                .textCase(.uppercase)
            HStack (spacing: 2) {
                Text("Vaild Thru: " + cardDetails.formattedValidity)
                Spacer()
                Text("Security Code: " + cardDetails.secureCode)
            }
            .font(.footnote)
            Text(cardDetails.number)
                .bold()
                .font(.title3)
        }
        .padding(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
