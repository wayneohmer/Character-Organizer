//
//  ActionView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 10/31/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import SwiftUI

class ObCharacer: ObservableObject {
    @Published var character = Character.shared
}

struct ActionView: View {
    @State var selection = 0
    @ObservedObject var character = ObCharacer().character
    @State var model = Character.shared.model
    @State var showingInitDice = false
    @State var showingStrDice = false
    @State var showingDexDice = false
    @State var showingHP = false
    @State var showingMaxHP = false
    @State var showingTempHP = false
    @State var showingAC = false
    @State var showingSkills = false

    var diceDetails = DiceDetails()

    var lightGray = Color(.lightGray)
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)

    var hitPoints: some View {
        HStack{
            VStack(spacing: 3){
                Text("Hit Points").fontWeight(.bold).frame(maxWidth: 100).foregroundColor(Color.white)
                Text(self.character.effectiveHP)
                    .onTapGesture {
                        self.showingHP = true
                }
                .font(Font.system(size: 45, weight: .bold, design: .default))
                .frame(maxWidth: 100, minHeight: 70)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
                .multilineTextAlignment(.center)
                .background(self.hpColor())
                .foregroundColor(Color.black)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(hpBorderColor(), lineWidth: 4))

                .popover(isPresented: $showingHP, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.currentHP, isHP: true) })
                
                Button(action: {self.character.currentHP = self.character.maxHP}, label: {
                    Text("Set Max").foregroundColor(Color.white).fontWeight(.bold)
                })
                    .frame(width: 100, height: 40, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: [Color(.lightGray), .black]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(5)
                .padding(3)
                
            }.padding(5)
            VStack {
                VStack {
                    Text("Max").frame(maxWidth: 45).foregroundColor(Color.white)
                    Text(character.maxHP)
                        .onTapGesture {
                            self.showingMaxHP = true
                        }
                        .frame(width: 45, height:30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .popover(isPresented: $showingMaxHP, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.maxHP, isHP: false) })
                }
                VStack {
                    Text("Temp").frame(maxWidth: 45).foregroundColor(Color.white)
                    Text(character.tempHP)
                        .onTapGesture {
                                self.showingTempHP = true
                        }
                        .frame(width: 45, height:30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .popover(isPresented: $showingTempHP, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.tempHP, isHP: false) })
                }
                Spacer()
            }
        }
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
                    Text(Character.shared.alingment).fontWeight(.bold).foregroundColor(Color.white)
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
                .font(Font.system(size: 40, weight: .bold, design: .default))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
                .background(Color.white)
                .foregroundColor(Color.black)
                .onTapGesture {
                    self.showingAC = true
                }
            .popover(isPresented: $showingAC, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.armorClass, isHP: false) })
            Spacer()
        }.padding(5).frame(width:80)
    }
    
    var attributes: some View {
        VStack(spacing:8) {
            VStack  {
                self.attrButton(name: "STR", action: {
                    self.showingStrDice = true
                    self.attributeTouched(title:"Strength", mod: Int(Character.shared.strMod) ?? 0)
                    
                })
                self.attrText(Character.shared.str)
                self.attrModifier(character.strMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)
            .popover(isPresented: self.$showingStrDice, arrowEdge: .leading, content: { DiceView(details: self.diceDetails, dice: self.diceDetails.dice) })
            
            VStack  {
                self.attrButton(name: "DEX", action: {
                    self.showingDexDice = true
                    self.attributeTouched(title:"Dexterity", mod: Int(Character.shared.dexMod) ?? 0)
                    
                })
                self.attrText(Character.shared.dex)
                self.attrModifier(Character.shared.dexMod)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
            .background(Color.white)
            .popover(isPresented: self.$showingDexDice, arrowEdge: .leading, content: { DiceView(details: self.diceDetails, dice: self.diceDetails.dice) })
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
                        HStack {
                            hitPoints
                            armorClass
                            Spacer()
                        }.frame(height:140)
                        HStack {
                            VStack(spacing:5) {
                                Button(action: { self.showingSkills = true }){
                                    Text("Skill").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                                }
                                .frame(width:120, height:40)
                                .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(5)
                                .sheet(isPresented: $showingSkills, content: { SkillCheckView()})
                                Button(action: {
                                    self.diceDetails.title = "Initiative"
                                    self.showingInitDice = true
                                    self.diceDetails.isSave = false
                                }){
                                    Text("Initiative").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                                }
                                .frame(width:120, height:40)
                                .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(5)
                                .popover(isPresented: self.$showingInitDice, arrowEdge: .leading, content: { DiceView(details: self.diceDetails, dice: self.diceDetails.dice) })
                                
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
            }.onAppear(){
                //forces redraw
               
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
        //self.showingDice = true
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
    
    func hpColor() -> Color {
        let r = Double(self.character.model.currentHP)/Double(self.character.model.maxHP)
        return Color(red: 1.0, green: r, blue: r)
    }
    
    func hpBorderColor() -> Color {
        if self.character.model.tempHP > 0 {
            return (Color.green)
        }
        return Color(.black)
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
