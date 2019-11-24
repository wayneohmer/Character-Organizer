//
//  ActionView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 10/31/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct ActionView: View {
    @State var selection = 0
//    @EnvironmentObject var character:Character
    @State var character = Character.shared
    @State var model = Character.shared.model
    @State var str = Character.shared.str
    @State var showingInitiative = false


    var lightGray = Color(.lightGray)
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)

    var hitPoints: some View {
        VStack(spacing: 3){
            Text("Hit Points").fontWeight(.bold).frame(maxWidth: 100).foregroundColor(Color.white)
            TextField("0", text: self.$character.currentHP)
                .font(Font.system(size: 45, weight: .bold, design: .default))
                .frame(maxWidth: 100, minHeight: 80)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
                .multilineTextAlignment(.center)
                .background(Color.white)
                .foregroundColor(Color.black)
        }.padding(8)
    }
    
    var demographics: some View {
        return
            VStack {
                Text(character.name)
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(Color.white)
                    .padding(8)
                HStack {
                    Text("Race:").foregroundColor(Color.white)
                    Text(character.race).fontWeight(.bold).foregroundColor(Color.white)
                    Text("Alignment:").foregroundColor(Color.white)
                    Text(character.alignment).fontWeight(.bold).foregroundColor(Color.white)
                    Text("Speed:").foregroundColor(Color.white)
                    Text(character.speed).fontWeight(.bold).foregroundColor(Color.white)
                    Text("Level:").foregroundColor(Color.white)
                    Text(character.level).fontWeight(.bold).foregroundColor(Color.white)
                    
                    Spacer()
                }.padding(8)
        }
    }
    
    var armorClass: some View {
        VStack(spacing: 3){
            Text("AC").fontWeight(.bold).frame(width: 110).foregroundColor(Color.white)
            Text(character.armorClass)
                .padding(8)
                .font(Font.system(size: 35, weight: .bold, design: .default))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
                .background(Color.white)
                .foregroundColor(Color.black)
            Spacer()
        }.padding(5)
    }
    
    var initiative: some View {
        VStack(spacing: 3){
            Text("Init").fontWeight(.bold).frame(maxWidth: 100).foregroundColor(Color.white)
            Text(character.armorClass)
                .padding(8)
                .font(Font.system(size: 25, weight: .bold, design: .default))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
                .background(Color.white)
        }
    }
    
    var attributes: some View {
        VStack(spacing:8) {
            VStack  {
                self.attrButton(name: "STR", action: { self.attributeTouched() })
                self.attrText(character.str)
                self.attrModifier(character.strMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)

            VStack  {
                self.attrButton(name: "DEX", action: { self.attributeTouched() })
                self.attrText(character.dex)
                self.attrModifier(character.dexMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)

            VStack  {
                self.attrButton(name: "CON", action: { self.attributeTouched() })
                self.attrText(character.con)
                self.attrModifier(character.conMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)

            VStack  {
                self.attrButton(name: "INT", action: { self.attributeTouched() })
                self.attrText(character.int)
                self.attrModifier(character.intMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)

            VStack  {
                self.attrButton(name: "WIS", action: { self.attributeTouched() })
                self.attrText(character.wis)
                self.attrModifier(character.wisMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)

            VStack  {
                self.attrButton(name: "CHA", action: { self.attributeTouched() })
                self.attrText(character.cha)
                self.attrModifier(character.chaMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)
        }.padding(8)

    }
    
    var body: some View {
        TabView(selection: self.$selection){
            
            VStack {
                 HStack {
                    VStack {
                            HStack{
                                Image("Wayne").resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 90, height:90)
                                    .padding(3)
                                demographics

                            }
                            VStack {
                                HStack {
                                    hitPoints
                                    HStack {
                                        armorClass
                                    }.frame(width:60, height:110)
                                    VStack {
                                        Text("")
                                            .foregroundColor(Color.white)
                                            .font(Font.system(size: 18, weight: .bold, design: .default))
                                        
                                        Spacer()
                                    }
                                    Spacer()
                                }.frame(height:110)
                            }
                        HStack {
                            VStack(spacing:5) {
                                Button(action: {}){
                                    Text("Conditions").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                                }
                                .frame(width:120, height:40)
                                .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(5)
                                
                                Button(action: { self.showingInitiative = true }){
                                    Text("Initiative").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                                }.popover(isPresented: self.$showingInitiative, arrowEdge: .leading, content:  {
                                    DiceView()                                })
                                .frame(width:120, height:40)
                                .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(5)
                                
                                self.attributes
                            }
                            
                            List(character.actions) { action in
                                return ActionRow(action:action)
                            }
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
            .tabItem {
                VStack {
                    Text("First")
                }
            }.background(background)
            .tag(0)

            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Text("Second")
                    }
            }
            .tag(1)
        }
        
    }
    
    func attributeTouched() {
        print("touched")
    }
    
    func attrButton(name:String, action: @escaping () -> Void ) -> some View {
        return Button(action: action) {
            Text("\(name)").fontWeight(.bold).padding(3).frame(alignment: .center)
        }
        .frame(maxWidth: 70, maxHeight: 35)
        .foregroundColor(Color.white)
        .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(5)
    }
    
    func attrText(_ text:String) -> some View {
        Text(text).multilineTextAlignment(.center)
            .font(Font.system(size: 25, weight: .bold, design: .default))
            .frame(width: 70)
            .foregroundColor(Color.black)
    }
    
    func attrModifier(_ text:String) -> some View {
        return Text(text)
            .frame(width: 55, alignment: .center)
            .foregroundColor(Color.black)
    }
}

struct ActionRow: View {
    var action:Action
    
    var body: some View {
        return HStack {
            Spacer()
            VStack {
                Text(self.action.name)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 25, weight: .bold, design: .default)).padding(4)
                Text(self.action.desc).foregroundColor(Color.white).offset(y:-6)
                }
            .background(Color.black)
            Spacer()
        }.overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
    }
    
}

struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView()
    }
}
