//
//  ActionView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 10/31/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import SwiftUI

class CharacterPickerHelper: ObservableObject {
    
    @Published var saveCheckIndex = 0
}

struct ActionView: View {
    @State var selection = 0
    @EnvironmentObject var character: Character
    @EnvironmentObject var characterSet: CharacterSet
    @ObservedObject var characterPicker = CharacterPickerHelper()
    @State var pickerIndex = 0
    
    @State var model: CharacterModel = CharacterModel()
    @State var showingInitDice = false
    @State var showingStrDice = false
    @State var showingDexDice = false
    @State var showingConDice = false
    @State var showingIntDice = false
    @State var showingWisDice = false
    @State var showingChaDice = false
    @State var showingHP = false
    @State var showingMaxHP = false
    @State var showingTempHP = false
    @State var showingAC = false
    @State var showingSkills = false
    @State var showingSpeed = false
    @State var showingProfBonus = false
    @State var showingSpellDc = false

    @State var selectedSpellLevels = Set<Int>()


    var diceDetails = DiceDetails()
    var filterTimeings: [ActionTiming] = [.All, .Action, .BonusAction, .Reaction, .Long]
    @State var actionFilterIdx: Int = 0

    var lightGray = Color(.lightGray)
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    
    var allCharacters:[CharacterModel] { return characterSet.allCharacters.sorted().filter({ $0.isActive} ) }

    var hitPoints: some View {
        VStack{
            Text("Hit Points").fontWeight(.bold).frame(width: 100).offset(x: 0, y: 15)
            ZStack {
                Image("heart").resizable().colorMultiply(hpColor()).shadow(color: .red, radius: 5, x: 0, y: 0)
                Text(self.character.effectiveHP)
                    .onTapGesture {
                        self.showingHP = true
                }
                .font(Font.system(size: 40, weight: .bold, design: .default))
                .multilineTextAlignment(.center)
                .offset(x: 0, y: -7 )
                .popover(isPresented: $showingHP, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.currentHP, isHP: true) })
                
            }.frame(width: 120, height: 100)
            BrownButton(text: "Set Max", width: 100) { self.character.currentHP = self.character.maxHP }.offset(x: 0, y: -10)
        }.foregroundColor(Color.black).frame(width: 120, height: 165).offset(x: 0, y: -7)
    }
    
    var maxTemp:  some View {
        
        VStack(spacing: 3)  {
            VStack(spacing: 3)  {
                Text("Max HP").frame(maxWidth: 80).offset(x: 0, y: 2)
                Text(character.maxHP)
                    .onTapGesture {
                        self.showingMaxHP = true
                    }
                    .frame(width: 70, height:30)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(color: .black, radius: 3, x: 2, y: 2)

                .popover(isPresented: $showingMaxHP, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.maxHP, isHP: false) })
            }
            VStack(spacing: 3)  {
                Text("Temp HP").frame(maxWidth: 80).offset(x: 0, y: 2)
                Text(character.tempHP)
                    .onTapGesture {
                            self.showingTempHP = true
                    }
                    .frame(width: 60, height:30)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(color: .black, radius: 3, x: 2, y: 2)

                .popover(isPresented: $showingTempHP, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.tempHP, isHP: false) })
            }
            Spacer()
        }
    }
    
    var speedProf: some View {
        VStack (spacing: 3) {
            VStack(spacing: 3) {
                Text("Speed").frame(maxWidth: 80).offset(x: 0, y: 2)
                Text(character.speed)
                    .onTapGesture {
                        self.showingSpeed = true
                    }
                    .frame(width: 60, height:30)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(5)
                    .shadow(color: .black, radius: 3, x: 2, y: 2)

                .popover(isPresented: $showingSpeed, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.speed, isHP: false) })
            }
            VStack (spacing: 3){
                Text("Spell DC").frame(maxWidth: 80).offset(x: 0, y: 2)
                Text("\(character.spellDC)")
//                    .onTapGesture {
//                            self.showingSpellDc = true
//                    }
                    .frame(width: 60, height:30)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(5)
                    .shadow(color: .black, radius: 3, x: 2,y: 2)
//
//                .popover(isPresented: $showingProfBonus, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.proficiencyBonus, isHP: false) })
            }
            Spacer()
        }
    }
    
    var demographics: some View {

        return VStack {
            HStack {
                VStack {
                    Image("Logo").resizable().aspectRatio(contentMode: .fit).frame(height: 30).offset(x: 0, y: 68)
                    ZStack {
                        Image("NameBackground").resizable().frame(width: 320,height: 180)
                        Text(Character.shared.name).font(Font.system(size: 18, weight: .bold, design: .default)).offset(x: 3, y: -3).onTapGesture(perform: {
                            self.characterSet.allCharacters.update(with:Character.shared.model)
                            self.pickerIndex += 1
                            if self.pickerIndex >= self.allCharacters.count {
                                self.pickerIndex = 0
                            }
                            Character.shared.model = self.allCharacters[self.pickerIndex]
                            self.character.model = Character.shared.model
                        })
                    }
                }.frame(height: 20).offset(x: 0, y: -12)
                VStack {
                    HStack {
                        Text("Race:")
                        Text(Character.shared.race.name).fontWeight(.bold).padding(3)
                        Text("Class:")
                        Text(Character.shared.charcaterClass.name).fontWeight(.bold).padding(3)
                        Spacer()
                        
                    }
                    HStack {
                        Text("Level:")
                        Text(Character.shared.level).fontWeight(.bold).padding(3)
                        Text("Alignment:")
                        Text(Character.shared.alingment).fontWeight(.bold).padding(3)
                        Spacer()
                    }
                    HStack {
                        Text("Languages:")
                        Text(Character.shared.languageString).fontWeight(.bold).padding(3)
                        Spacer()
                    }
                }
                Spacer()
            }
        }.frame(height: 90).foregroundColor(Color.black).padding().offset(x: -20, y: 0)
    }
    
    var armorClass: some View {
        VStack(spacing: 3){
            Text("AC").fontWeight(.bold).frame(width: 80).cornerRadius(5).offset(x: 0, y: -5)
            Text(character.armorClass)
                .padding(8)
                .font(Font.system(size: 40, weight: .bold, design: .default))
                .background(Image("ACicon").resizable().frame(width: 85, height: 85, alignment: .center)).shadow(color: .white, radius: 10, x: 0, y: 0)
                .foregroundColor(Color.black)
                .onTapGesture {
                    self.showingAC = true
                }
            .popover(isPresented: $showingAC, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.armorClass, isHP: false) })
            Spacer()
        }.padding(5).frame(width:80).foregroundColor(Color.black)
    }
    
    var attributes: some View {
        VStack(spacing:24) {
            
            VStack  {
                BrownButton(text: Attribute.STR.rawValue, width: 70, height: 30) {
                    self.showingStrDice = true
                    self.attributeTouched(attr:Attribute.STR, mod: self.character.saveModFor(attr: Attribute.STR))
                }
                self.attrText(Character.shared.str)
                self.attrModifier(character.strMod)
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
            .popover(isPresented: self.$showingStrDice, arrowEdge: .leading, content: {
                DiceView(details: self.diceDetails, dice: self.diceDetails.dice, proficiencyMod: self.character.saveProfModFor(attr: Attribute.STR))
                
            })
            
            VStack  {
                BrownButton(text: Attribute.DEX.rawValue, width: 70, height: 30){
                    self.showingDexDice = true
                    self.attributeTouched(attr:Attribute.DEX, mod: self.character.saveModFor(attr: Attribute.DEX))
                }
                self.attrText(Character.shared.dex)
                self.attrModifier(Character.shared.dexMod)
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
            .popover(isPresented: self.$showingDexDice, arrowEdge: .leading, content: {
                DiceView(details: self.diceDetails, dice: self.diceDetails.dice, proficiencyMod: self.character.saveProfModFor(attr: Attribute.DEX))
                
            })
            
            VStack  {
                BrownButton(text: Attribute.CON.rawValue, width: 70, height: 30){
                    self.showingConDice = true
                    self.attributeTouched(attr:Attribute.CON, mod: self.character.saveModFor(attr: Attribute.CON))
                }
                self.attrText(Character.shared.con)
                self.attrModifier(Character.shared.conMod)
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
                
            .popover(isPresented: self.$showingConDice, arrowEdge: .leading, content: {
                DiceView(details: self.diceDetails, dice: self.diceDetails.dice, proficiencyMod: self.character.saveProfModFor(attr: Attribute.CON))
                
            })
            
            VStack  {
                BrownButton(text: Attribute.INT.rawValue, width: 70, height: 30){
                    self.showingIntDice = true
                    self.attributeTouched(attr:Attribute.INT, mod: self.character.saveModFor(attr: Attribute.INT))
                    
                }
                self.attrText(Character.shared.int)
                self.attrModifier(Character.shared.intMod)
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
                
            .popover(isPresented: self.$showingIntDice, arrowEdge: .leading, content: {
                DiceView(details: self.diceDetails, dice: self.diceDetails.dice, proficiencyMod: self.character.saveProfModFor(attr: Attribute.INT))
                
            })
            VStack  {
                BrownButton(text: Attribute.WIS.rawValue, width: 70, height: 30){
                    self.showingWisDice = true
                    self.attributeTouched(attr:Attribute.WIS, mod: self.character.saveModFor(attr: Attribute.WIS))
                    
                }
                self.attrText(Character.shared.wis)
                self.attrModifier(Character.shared.wisMod)
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
                
            .popover(isPresented: self.$showingWisDice, arrowEdge: .leading, content: {
                DiceView(details: self.diceDetails, dice: self.diceDetails.dice, proficiencyMod: self.character.saveProfModFor(attr: Attribute.WIS))
                
            })
            VStack  {
                BrownButton(text: Attribute.CHA.rawValue, width: 70, height: 30) {
                    self.showingChaDice = true
                    self.attributeTouched(attr:Attribute.CHA, mod: self.character.saveModFor(attr: Attribute.CHA))
                }
                self.attrText(Character.shared.cha)
                self.attrModifier(Character.shared.chaMod)
                    .popover(isPresented: self.$showingChaDice, arrowEdge: .leading, content: {
                        DiceView(details: self.diceDetails, dice: self.diceDetails.dice, proficiencyMod: self.character.saveProfModFor(attr: Attribute.CHA))
                        
                    })
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
            
        }.padding(8)

    }
    
    var body: some View {
        
        TabView(selection: self.$selection){
            VStack {
                HStack {
                    VStack( spacing: 5) {
                        Image(uiImage: self.character.image).resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .shadow(color: .black, radius: 5, x: 3, y: 3)
                        hitPoints
                        BrownButton(text: "Skill", width: 100) {
                            self.showingSkills = true
                        }
                        .sheet(isPresented: $showingSkills, content: { SkillCheckView()})

                        self.attributes

                        Spacer()
                    }.offset(x: 0, y:8)
                    VStack {
                        demographics
                        HStack {
                            maxTemp
                            armorClass
                            speedProf
                            Spacer()
                        }.frame(height:100).foregroundColor(Color.black).offset(x: 0, y: -8)
                        if character.model.isSpellCaster {
                            HStack {
                                Spacer()
                                SpellsUsedGrid(selectedSpellLevels: self.$selectedSpellLevels)
                            }
                            
                        }
                        HStack {
                            
                            VStack {
                                
                                Picker("Filter", selection: $actionFilterIdx) {
                                    ForEach(0 ..< self.filterTimeings.count) { idx in
                                        Text(self.filterTimeings[idx].rawValue)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .cornerRadius(8)
                                ZStack {
                                    Image(uiImage: self.character.image).resizable().aspectRatio(contentMode: .fit).opacity(0.6)
                                    ScrollView(.vertical) {
                                        VStack{
                                            ForEach(character.actions.filter({
                                                if self.selectedSpellLevels.count > 0 {
                                                    if let spell = $0.spell {
                                                        if !self.selectedSpellLevels.contains(spell.level) {
                                                            return false
                                                        }
                                                    }
                                                }
                                                return $0.timing == self.filterTimeings[actionFilterIdx] || actionFilterIdx == 0
                                                
                                                
                                            }).sorted()) { action in
                                                if action.weapon != nil {
                                                    WeaponAction(action: action)
                                                } else if action.spell != nil {
                                                    SpellAction(action:action)
                                                } else {
                                                    MiscAction(action:action)
                                                }
                                            }
                                            HStack{ Spacer() }
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            Text("")
                            Spacer()
                        }
                    }
                 }.background(Image("parchment").resizable().opacity(0.8))
                
                Spacer()
            }
            
            .onAppear(){
                for (idx,model) in self.allCharacters.enumerated() {
                    if model == Character.shared.model {
                        self.pickerIndex = idx
                        self.character.model = Character.shared.model
                    }
                }
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
            SelectView()
                .tabItem {
                    VStack {
                        Text("Select")
                    }
            }.background(background)
                .tag(2)
                CreateView()
            .tabItem {
                    VStack {
                        Text("Create")
                    }
            }.background(background)
                .tag(3)
        }
        
    }
    
    func attributeTouched(attr:Attribute, mod:Int) {
        self.diceDetails.title = attr.desc()
        self.diceDetails.isSave = true
        self.diceDetails.dice = FyreDice(with: [20:1], modifier: mod)
    }
    
    func attrText(_ text:String) -> some View {
        Text(text).multilineTextAlignment(.center)
            .font(Font.system(size: 25, weight: .bold, design: .default))
            .frame(width: 70, height: 35)
            .offset(x: 0, y: -3)
            .foregroundColor(Color.black)
            
    }
    
    func attrModifier(_ text:String) -> some View {
        return Text(text)
            .frame(width: 55, alignment: .center)
            .foregroundColor(Color.black)
    }
    
    func hpColor() -> Color {
        let r = Double(self.character.model.currentHP)/Double(self.character.model.maxHP)
        return Color(red: 1.0  , green: r, blue: r)
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
        HStack {
            Spacer()
            VStack {
                Text(self.action.name)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 25, weight: .bold, design: .default)).padding(4)
                Text(self.action.desc).foregroundColor(Color.white).offset(y:-6)
            }
            Spacer()
        }
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
    }
    
}

struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView()
    }
}
