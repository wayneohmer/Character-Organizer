//
//  DiceView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 11/24/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct DicePickerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var lightGray = Color(.lightGray)
    var background = Color(red: 0.10, green: 0.10, blue: 0.10)
    let longWidth:CGFloat = 237
    let longModWidth:CGFloat = 265
    let diceWith:CGFloat = 70
    let modwidth:CGFloat = 42
    let bmodwidth:CGFloat = 55
    @ObservedObject var details:DiceDetails
    @Binding var diceModel:FyreDiceModel
    var hasModifier = false
    @ObservedObject var pickerhelper:PickerHelper = PickerHelper()
    @State var saveCheck = ["Save","Check"]
    @State var sign = "+"
    @State var oopsStack = [FyreDiceModel]()

        
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Save").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
            }
            VStack {
                Text(self.details.title).padding(8)
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(Color.white).padding(5)
                VStack {
                    Text(self.diceModel.display)
                        .padding(8)
                        .font(Font.system(size: 20, weight: .bold, design: .default))
                        .frame(width: 240, height:40, alignment: .center)
                        .background(Color.black)
                        .padding(5)
                }
                HStack{
                    VStack {
                        self.diceButton(name: "Clear", width:longWidth, action: {self.diceModel.clear()})
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
                            if let oops = self.oopsStack.last {
                                self.diceModel = oops
                                self.oopsStack.removeLast()
                            }
                        })
                        Spacer()

                    }.padding(3)
                    if hasModifier {
                        VStack {
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
                            Spacer()
                        }.padding(3)
                    }

                }
            }
            .background(background)
            Spacer()
            
        }
        .foregroundColor(Color.white).padding(5)
        .background(Color.black)
    }
    
    func diceButton(name:String = "", width:CGFloat, modifier: Int = 0, d:Int = 0, action: (() -> Void)? = nil) -> some View {
        return Button(action: {
            if let action = action {
                action()
            } else {
                self.oopsStack.append(self.diceModel)
                
                if modifier != 0 {
                    self.diceModel.modifier += self.sign == "+" ? modifier : -modifier
                    return
                } else if d != 0 {
                    self.diceModel.add(multipier: self.sign == "+" ? 1 : -1, d: d)
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

struct DicePickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        DicePickerView(details: DiceDetails(), diceModel: .constant(FyreDiceModel()), hasModifier: true)
    }
}

