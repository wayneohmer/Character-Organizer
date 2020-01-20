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
    @State var character = Character.shared
    @State var model = Character.shared.model
    @State var showingDice = false
    
    var diceDetails = DiceDetails()

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
                    Text(Character.shared.race.name).fontWeight(.bold).foregroundColor(Color.white)
                    Text("Alignment:").foregroundColor(Color.white)
                    Text(Character.shared.alignment).fontWeight(.bold).foregroundColor(Color.white)
                    Text("Speed:").foregroundColor(Color.white)
                    Text(Character.shared.speed).fontWeight(.bold).foregroundColor(Color.white)
                    Text("Level:").foregroundColor(Color.white)
                    Text(Character.shared.level).fontWeight(.bold).foregroundColor(Color.white)
                    
                    Spacer()
                    
                }.padding(8)
                HStack {
                    Text("Languages:").foregroundColor(Color.white)
                    Text(Character.shared.languageString).fontWeight(.bold).foregroundColor(Color.white)
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
    
    var attributes: some View {
        VStack(spacing:8) {
            VStack  {
                self.attrButton(name: "STR", action: { self.attributeTouched(title:"Strength", mod: Int(Character.shared.strMod) ?? 0) })
                self.attrText(Character.shared.str)
                self.attrModifier(character.strMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)

            VStack  {
                self.attrButton(name: "DEX", action: { self.attributeTouched(title:"Dexterity", mod: Int(Character.shared.dexMod) ?? 0) })
                self.attrText(Character.shared.dex)
                self.attrModifier(Character.shared.dexMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)

            VStack  {
                self.attrButton(name: "CON", action: { self.attributeTouched(title:"Constitution", mod: Int(Character.shared.conMod) ?? 0) })
                self.attrText(Character.shared.con)
                self.attrModifier(Character.shared.conMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)

            VStack  {
                self.attrButton(name: "INT", action: { self.attributeTouched(title:"Intelligence", mod: Int(Character.shared.intMod) ?? 0) })
                self.attrText(Character.shared.int)
                self.attrModifier(Character.shared.intMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)

            VStack  {
                self.attrButton(name: "WIS", action: { self.attributeTouched(title:"Wisdom", mod: Int(Character.shared.wisMod) ?? 0) })
                self.attrText(Character.shared.wis)
                self.attrModifier(Character.shared.wisMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)

            VStack  {
                self.attrButton(name: "CHA", action: { self.attributeTouched(title:"Charisma", mod: Int(Character.shared.chaMod) ?? 0) })
                self.attrText(Character.shared.cha)
                self.attrModifier(Character.shared.chaMod)
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
                                
                                Button(action: {
                                    self.diceDetails.title = "Initiative"
                                    self.showingDice = true
                                    self.diceDetails.isSave = false
                                }){
                                    Text("Initiative").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                                }
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
                 }.sheet(isPresented: self.$showingDice, content: { DiceView(details: self.diceDetails, dice: self.diceDetails.dice) })

                Spacer()
            }.onAppear(){
                //forces redraw
                self.showingDice = true
                self.showingDice = false
            }

            .tabItem {
                VStack {
                    Text("Action")
                }
            }.background(background)
                .tag(0)
            DescriptionView()
                .tabItem {
                    VStack {
                        Text("Description")
                    }
            }.background(background)
            .tag(1)
            CreateView()
                .tabItem {
                    VStack {
                        Text("Create")
                    }
            }.background(background)
            .tag(2)
        }
        
    }
    
    func attributeTouched(title:String, mod:Int) {
        self.showingDice = true
        self.diceDetails.title = title
        self.diceDetails.isSave = true
        self.diceDetails.dice = FyreDice(with: [20:1], modifier: mod)
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
