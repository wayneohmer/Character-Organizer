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
    @State var sign = "+"

    
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
                            self.diceButton(width:diceWith, d: 4)
                            self.diceButton(width:diceWith, d: 6)
                            self.diceButton(width:diceWith, d: 8)
                        }
                        HStack {
                            self.diceButton(width:diceWith, d: 10)
                            self.diceButton(width:diceWith, d: 12)
                            self.diceButton(width:diceWith, d: 20)
                        }
                        self.diceButton(name: "oops", width:longWidth, action: {
                            if let oops = self.dice.oopsStack.last {
                                switch oops.type {
                                case .buttonTouch:
                                    self.dice.replaceWith(fyreDice:FyreDice(with:oops.fyreDice, includeResult:true))
                                case .roll:
                                    self.dice.rollValue = FyreDice(with:oops.fyreDice, includeResult:true).rollValue
                                    self.dice.diceResults = FyreDice(with:oops.fyreDice, includeResult:true).diceResults
                                default:
                                    break
                                }
                                self.dice.oopsStack.removeLast()
                            }
                        })
                    }.padding(3)
                    VStack {
                        
                        self.diceButton(name: "Roll", width:longModWidth, action: {
                            self.dice.oopsStack.append(Oops(fyreDice: FyreDice(with:self.dice, includeResult:true), type: Oops.OopsType.roll))
                            self.dice.roll()
                            
                        })
                        HStack {
                            self.diceButton(width:modwidth, modifier: 1)
                            self.diceButton(width:modwidth, modifier: 2)
                            self.diceButton(width:modwidth, modifier: 3)
                            self.diceButton(width:modwidth, modifier: 4)
                            self.diceButton(width:modwidth, modifier: 5)
                        }
                        HStack {
                            self.diceButton(width:modwidth, modifier: 6)
                            self.diceButton(width:modwidth, modifier: 7)
                            self.diceButton(width:modwidth, modifier: 8)
                            self.diceButton(width:modwidth, modifier: 9)
                            self.diceButton(width:modwidth, modifier: 10)
                            
                        }
                        HStack {
                            self.diceButton(width:bmodwidth, modifier: 20)
                            self.diceButton(width:bmodwidth, modifier: 30)
                            self.diceButton(width:bmodwidth, modifier: 40)
                            self.diceButton(name: "\(sign)", width:bmodwidth, action: {
                                self.sign = self.sign == "+" ? "-" : "+"
                            })
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
    
    func diceButton(name:String = "", width:CGFloat, modifier: Int = 0, d:Int = 0, action: (() -> Void)? = nil) -> some View {
        return Button(action: {
            if let action = action {
                action()
            } else {
                self.dice.oopsStack.append(Oops(fyreDice: FyreDice(with:self.dice, includeResult:true), type: Oops.OopsType.buttonTouch))

                if modifier != 0 {
                    self.dice.modifier += self.sign == "+" ? modifier : -modifier
                    return
                } else if d != 0 {
                    self.dice.add(multipier: self.sign == "+" ? 1 : -1, d: d)
                }
            }
        }) {
            if name != "" {
                Text("\(name)").fontWeight(.bold).padding(3).frame(width: width, height: 40, alignment: .center)
            } else if d != 0 {
                Text("\(sign)d\(d)").fontWeight(.bold).padding(3).frame(width: width, height: 40, alignment: .center)
            } else if modifier != 0 {
                Text("\(sign)\(modifier)").fontWeight(.bold).padding(3).frame(width: width, height: 40, alignment: .center)
            }
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

