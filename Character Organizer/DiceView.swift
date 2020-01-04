//
//  DiceView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 11/24/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import SwiftUI

class DiceDetails: ObservableObject {
    @Published var title = "Junk"
    @Published var isSave = true
    @Published var dice = FyreDice()
}

class PickerHelper: ObservableObject {
    
    @Published var saveCheckIndex = 0
}

struct DiceView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var lightGray = Color(.lightGray)
    var background = Color(red: 0.10, green: 0.10, blue: 0.10)
    let longWidth:CGFloat = 237
    let longModWidth:CGFloat = 265
    let diceWith:CGFloat = 70
    let modwidth:CGFloat = 42
    let bmodwidth:CGFloat = 55
    @ObservedObject var details:DiceDetails
    @ObservedObject var dice:FyreDice
    @ObservedObject var pickerhelper:PickerHelper = PickerHelper()
    @State var saveCheck = ["Save","Check"]

    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Close").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
            }
            VStack {
                Text(self.details.title).padding(8)
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(Color.white).padding(5)
                HStack {
                    VStack {
                        Text(self.dice.display)
                            .padding(8)
                            .font(Font.system(size: 20, weight: .bold, design: .default))
                            .frame(width: 240, height:40, alignment: .center)
                            .background(Color.black)
                        .padding(5)

                        Text(self.dice.resultDisplay)
                            .padding(8)
                            .font(Font.system(size: 20, weight: .bold, design: .default))
                            .frame(width: 240, height:40, alignment: .center)
                            .background(Color.black)
                        .padding(5)
                    }
                    Spacer()
                    Text(self.dice.rollValueString).padding(10)
                        .font(Font.system(size: 50, weight: .bold, design: .default)).frame(width: 150)
                        .frame(width: 250, alignment: .center)
                        .background(Color.black)
                    .padding(5)
                    }.foregroundColor(Color.white).padding(5)
                
                HStack{
                    VStack {
                        self.diceButton(name: "Clear", width:longWidth, action: {self.dice.clear()})
                        HStack {
                            self.diceButton(name: "+1d4", width:diceWith, action: {self.dice.add(multipier: 1, d: 4)})
                            self.diceButton(name: "+1d6", width:diceWith, action: {self.dice.add(multipier: 1, d: 6)})
                            self.diceButton(name: "+1d8", width:diceWith, action: {self.dice.add(multipier: 1, d: 8)})
                        }
                        HStack {
                            self.diceButton(name: "+1d10", width:diceWith, action: {self.dice.add(multipier: 1, d: 10)})
                            self.diceButton(name: "+1d12", width:diceWith, action: {self.dice.add(multipier: 1, d: 12)})
                            self.diceButton(name: "+1d20", width:diceWith, action: {self.dice.add(multipier: 1, d: 20)})
                        }
                        self.diceButton(name: "oops", width:longWidth, action: {})
                    }.padding(3)
                    VStack {
                        
                        self.diceButton(name: "Roll", width:longModWidth, action: { self.dice.roll() })
                        HStack {
                            self.diceButton(name: "+1", width:modwidth, action: {self.dice.modifier += 1})
                            self.diceButton(name: "+2", width:modwidth, action: {self.dice.modifier += 2})
                            self.diceButton(name: "+3", width:modwidth, action: {self.dice.modifier += 3})
                            self.diceButton(name: "+4", width:modwidth, action: {self.dice.modifier += 4})
                            self.diceButton(name: "+5", width:modwidth, action: {self.dice.modifier += 5})
                        }
                        HStack {
                            self.diceButton(name: "+6", width:modwidth, action: {self.dice.modifier += 6})
                            self.diceButton(name: "+7", width:modwidth, action: {self.dice.modifier += 7})
                            self.diceButton(name: "+8", width:modwidth, action: {self.dice.modifier += 8})
                            self.diceButton(name: "+9", width:modwidth, action: {self.dice.modifier += 9})
                            self.diceButton(name: "+10", width:modwidth, action: {self.dice.modifier += 10})
                        }
                        HStack {
                            self.diceButton(name: "+20", width:bmodwidth, action: {self.dice.modifier += 20})
                            self.diceButton(name: "+30", width:bmodwidth, action: {self.dice.modifier += 30})
                            self.diceButton(name: "+40", width:bmodwidth, action: {self.dice.modifier += 40})
                            self.diceButton(name: "-", width:bmodwidth, action: {})
                        }
                    }.padding(3)
                }
                HStack {
                    Toggle(isOn: $dice.advantage ) { Text ("Advantage") }.padding(8).frame(width: 200).disabled(self.dice.dice[20] ?? 0 == 0)
                    Toggle(isOn: $dice.disadvantage ) { Text ("Disadvantage") }.padding(8).frame(width: 200).disabled(self.dice.dice[20] ?? 0 == 0)
                    Spacer()
                    
                }.foregroundColor(Color.white).padding()
                if self.details.isSave {
                    Picker("SaveCheck", selection: $pickerhelper.saveCheckIndex) {
                        ForEach(0 ..< saveCheck.count) { index in
                            Text(self.saveCheck[index])
                        }
                        }.pickerStyle(SegmentedPickerStyle())
                        .padding(10)
                        .onReceive(self.pickerhelper.objectWillChange, perform: { self.dice.modifier = self.pickerhelper.saveCheckIndex == 0 ? 7 : 2  })
                }
            }
            .background(background)
            .frame(width: 550, alignment: .center)
            
            Spacer()

        }
        .background(Color.black)
    }
    
    func diceButton(name:String, width:CGFloat, action: @escaping () -> Void ) -> some View {
        return Button(action: action) {
            Text("\(name)").fontWeight(.bold).padding(3).frame(width: width, height: 40, alignment: .top)
        }
        .foregroundColor(Color.white)
        .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(5)
        .padding(3)
    }

    
}

struct DiceView_Previews: PreviewProvider {
    
    static var previews: some View {
        DiceView(details: DiceDetails(), dice: FyreDice())
    }
}

