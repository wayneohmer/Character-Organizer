//
//  SwiftUIView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 5/11/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct NumberEditor: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State var value:String
    @Binding var modifiedValue:String
    @State var isHP:Bool
    @ObservedObject var character = ObCharacer().character

    var body: some View {
        VStack{
            HStack{
                Text("\(value)")
                    .font(Font.system(size: 60, weight: .bold, design: .default))
                    .frame(width: 160, height: 100)
                    .background(Color(.black))
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth:2)).foregroundColor(Color.white)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    
                VStack {
                    GrayButton(text: "X", width: 40) { self.value = "0" }
                    Spacer()
                }.frame(height: 100)
                Spacer()
            }.padding()
            VStack{
                HStack{
                    NumberButton(buttonValue: 1, value: $value)
                    NumberButton(buttonValue: 2, value: $value)
                    NumberButton(buttonValue: 3, value: $value)
                }
                HStack{
                    NumberButton(buttonValue: 4, value: $value)
                    NumberButton(buttonValue: 5, value: $value)
                    NumberButton(buttonValue: 6, value: $value)
                }
                HStack{
                    NumberButton(buttonValue: 7, value: $value)
                    NumberButton(buttonValue: 8, value: $value)
                    NumberButton(buttonValue: 9, value: $value)
                }
                HStack {
                    Text("").frame(width: 65, height: 45).padding(3)
                    NumberButton(buttonValue: 0, value: $value)
                    GrayButton(text:"<", width: 65, height: 45) {
                        if self.value.count > 1 {
                            self.value = String(self.value.dropLast())
                        } else {
                            self.value = "0"
                        }
                        
                    }
                }
                Spacer()
                HStack {
                    Button(action: {
                        let heal = Int(self.value) ?? 0
                        var modvalue = Int(self.modifiedValue) ?? 0
                        modvalue += heal
                        self.modifiedValue = "\(modvalue)"
                        self.presentationMode.wrappedValue.dismiss()

                    }, label: {
                        if isHP {
                            Text("Heal").fontWeight(.bold)
                                .frame(width: 100, height: 40, alignment: .center)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(.blue), .black]), startPoint: .top, endPoint: .bottom))
                                .offset(x: 0, y: -3)

                                .cornerRadius(5)
                        } else {
                            Text("Add").fontWeight(.bold)
                                .frame(width: 100, height: 40, alignment: .center)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(.lightGray), .black]), startPoint: .top, endPoint: .bottom))
                                .offset(x: 0, y: -3)

                                .cornerRadius(5)
                            
                        }
                    })
                    Button(action: {
                        var damage = Int(self.value) ?? 0
                        if self.character.model.tempHP > 0 {
                            if damage > self.character.model.tempHP {
                                damage -= self.character.model.tempHP
                                self.character.model.tempHP = 0
                            } else {
                                self.character.model.tempHP -= damage
                                damage = 0
                            }
                        }
                        var modvalue = Int(self.modifiedValue) ?? 0
                        modvalue -= damage
                        self.modifiedValue = "\(modvalue)"
                        self.presentationMode.wrappedValue.dismiss()

                        
                    }, label: {
                        if isHP {
                            Text("Damage").fontWeight(.bold)
                                .offset(x: 0, y: -3)

                                .frame(width: 100, height: 40, alignment: .center)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(.red), .black]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(5)
                                .padding(3)
                        } else {
                            Text("Subtract").fontWeight(.bold)
                                .offset(x: 0, y: -3)

                                .frame(width: 100, height: 40, alignment: .center)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(.lightGray), .black]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(5)
                            
                        }
                        
                    })
                }
               GrayButton(text:"Set", width: 100) {
                    self.modifiedValue = "\(self.value)"
                    self.presentationMode.wrappedValue.dismiss()
                }
                Spacer()

            }
            Spacer()
        }
        .frame(width: 250, height: 450)
        .foregroundColor(Color.white)
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(.white), lineWidth: 4))
        .cornerRadius(15)

    }
    
    struct NumberButton: View {

        var buttonValue:Int
        @Binding var value:String
        
        var body: some View {
            GrayButton(text:"\(buttonValue)",width: 65, height: 45) {
                if self.value == "0" {
                    self.value = "\(self.buttonValue)"
                } else {
                    self.value = self.value + "\(self.buttonValue)"
                }
            }
        }
    }
}


struct NumberEditor_Previews: PreviewProvider {
    static var previews: some View {
        NumberEditor(value: "0", modifiedValue: .constant("35"), isHP: false)
    }
}
