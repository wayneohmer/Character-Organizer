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

    var diceDetails = DiceDetails()
    var filterTimeings: [ActionTiming] = [.All, .Action, .BonusAction, .Reaction, .Long]
    @State var actionFilterIdx: Int = 0

    var lightGray = Color(.lightGray)
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    
    var allCharacters:[CharacterModel] { return characterSet.allCharacters.sorted().filter({ $0.isActive} ) }

    var hitPoints: some View {
        HStack{
            VStack(spacing: 3){
                Text("Hit Points").fontWeight(.bold).frame(maxWidth: 100).background(Color(.white).opacity(0.3)).cornerRadius(5)
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

                .popover(isPresented: $showingHP, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.currentHP, isHP: true) })

                GrayButton(text: "Set Max", width: 100) { self.character.currentHP = self.character.maxHP }
            }.padding(5)
            VStack {
                VStack {
                    Text("Max").frame(maxWidth: 45).background(Color(.white).opacity(0.3)).cornerRadius(5)
                    Text(character.maxHP)
                        .onTapGesture {
                            self.showingMaxHP = true
                        }
                        .frame(width: 45, height:30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(5)

                    .popover(isPresented: $showingMaxHP, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.maxHP, isHP: false) })
                }
                VStack {
                    Text("Temp").frame(maxWidth: 45).background(Color(.white).opacity(0.3)).cornerRadius(5)
                    Text(character.tempHP)
                        .onTapGesture {
                                self.showingTempHP = true
                        }
                        .frame(width: 45, height:30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(5)

                    .popover(isPresented: $showingTempHP, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.tempHP, isHP: false) })
                }
                Spacer()
            }
        }
    }
    
    var speedProf: some View {
        VStack {
            VStack {
                Text("Speed").frame(maxWidth: 60).background(Color(.white).opacity(0.3)).cornerRadius(5)
                Text(character.speed)
                    .onTapGesture {
                        self.showingSpeed = true
                    }
                    .frame(width: 60, height:30)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(5)

                .popover(isPresented: $showingSpeed, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.speed, isHP: false) })
            }
            VStack {
                Text("Prof").frame(maxWidth: 60).background(Color(.white).opacity(0.3)).cornerRadius(5)
                Text(character.proficiencyBonus)
                    .onTapGesture {
                            self.showingProfBonus = true
                    }
                    .frame(width: 60, height:30)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(5)

                .popover(isPresented: $showingProfBonus, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.proficiencyBonus, isHP: false) })
            }
            Spacer()
        }
    }
    
    var demographics: some View {
        let saveCheckIndex = Binding<Int>(get: {

            return self.pickerIndex

        }, set: {
            self.pickerIndex = $0
            self.characterSet.allCharacters.update(with:Character.shared.model)
            Character.shared.model = self.allCharacters[$0]
            self.character.model = Character.shared.model
        })

        return VStack {
            Picker("", selection: saveCheckIndex) {
                ForEach(0 ..< allCharacters.count) { index in
                    Text(self.allCharacters[index].name)
                }
            }.pickerStyle(SegmentedPickerStyle())

            HStack {
                Text("Race:")
                Text(Character.shared.race.name).fontWeight(.bold).padding(3).background(Color(.white).opacity(0.3)).cornerRadius(5)
                Text("Class:")
                Text(Character.shared.charcaterClass.name).fontWeight(.bold).padding(3).background(Color(.white).opacity(0.3)).cornerRadius(5)
                Text("Level:")
                Text(Character.shared.level).fontWeight(.bold).padding(3).background(Color(.white).opacity(0.3)).cornerRadius(5)
                Spacer()
                
            }
            HStack {
                Text("Alignment:")
                Text(Character.shared.alingment).fontWeight(.bold).padding(3).background(Color(.white).opacity(0.3)).cornerRadius(5)
                Text("Languages:")
                Text(Character.shared.languageString).fontWeight(.bold).padding(3).background(Color(.white).opacity(0.3)).cornerRadius(5)
                Spacer()
            }
            }.foregroundColor(Color.black).padding()
    }
    
    var armorClass: some View {
        VStack(spacing: 3){
            Text("AC").fontWeight(.bold).frame(width: 80).background(Color(.white).opacity(0.3)).cornerRadius(5).offset(x: 0, y: -5)
            Text(character.armorClass)
                .padding(8)
                .font(Font.system(size: 40, weight: .bold, design: .default))
                .background(Image("ACicon").resizable().frame(width: 80, height: 80, alignment: .center))
                .foregroundColor(Color.black)
                .onTapGesture {
                    self.showingAC = true
                }
            .popover(isPresented: $showingAC, arrowEdge: .leading, content: { NumberEditor(value: "0", modifiedValue: self.$character.model.armorClass, isHP: false) })
            Spacer()
        }.padding(5).frame(width:90)
    }
    
    var attributes: some View {
        VStack(spacing:24) {
            
            VStack  {
                GrayButton(text: Attribute.STR.rawValue, width: 70, height: 30) {
                    self.showingStrDice = true
                    self.attributeTouched(title:Attribute.STR.desc(), mod: Int(Character.shared.strMod) ?? 0)
                }
                self.attrText(Character.shared.str)
                self.attrModifier(character.strMod)
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
            .popover(isPresented: self.$showingStrDice, arrowEdge: .leading, content: { DiceView(details: self.diceDetails, dice: self.diceDetails.dice) })
            
            VStack  {
                GrayButton(text: Attribute.DEX.rawValue, width: 70, height: 30){
                    self.showingDexDice = true
                    self.attributeTouched(title:Attribute.DEX.rawValue, mod: Int(Character.shared.dexMod) ?? 0)
                }
                self.attrText(Character.shared.dex)
                self.attrModifier(Character.shared.dexMod)
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
            .popover(isPresented: self.$showingDexDice, arrowEdge: .leading, content: { DiceView(details: self.diceDetails, dice: self.diceDetails.dice) })
            
            VStack  {
                GrayButton(text: Attribute.CON.rawValue, width: 70, height: 30){
                    self.showingConDice = true
                    self.attributeTouched(title:Attribute.CON.desc(), mod: Int(Character.shared.conMod) ?? 0)
                }
                self.attrText(Character.shared.con)
                self.attrModifier(Character.shared.conMod)
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
                
            .popover(isPresented: self.$showingConDice, arrowEdge: .leading, content: { DiceView(details: self.diceDetails, dice: self.diceDetails.dice) })
            
            VStack  {
                GrayButton(text: Attribute.INT.rawValue, width: 70, height: 30){
                    self.showingIntDice = true
                    self.attributeTouched(title:Attribute.INT.desc(), mod: Int(Character.shared.intMod) ?? 0)
                    
                }
                self.attrText(Character.shared.int)
                self.attrModifier(Character.shared.intMod)
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
                
            .popover(isPresented: self.$showingIntDice, arrowEdge: .leading, content: { DiceView(details: self.diceDetails, dice: self.diceDetails.dice) })
            VStack  {
                GrayButton(text: Attribute.WIS.rawValue, width: 70, height: 30){
                    self.showingWisDice = true
                    self.attributeTouched(title:Attribute.WIS.desc(), mod: Int(Character.shared.wisMod) ?? 0)
                    
                }
                self.attrText(Character.shared.wis)
                self.attrModifier(Character.shared.wisMod)
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
                
            .popover(isPresented: self.$showingWisDice, arrowEdge: .leading, content: {
                DiceView(details: self.diceDetails, dice: self.diceDetails.dice) })
            VStack  {
                GrayButton(text: Attribute.CHA.rawValue, width: 70, height: 30) {
                    self.showingChaDice = true
                    self.attributeTouched(title:Attribute.CHA.desc(), mod: Int(Character.shared.chaMod) ?? 0)
                }
                self.attrText(Character.shared.cha)
                self.attrModifier(Character.shared.chaMod)
                .popover(isPresented: self.$showingChaDice, arrowEdge: .leading, content: { DiceView(details: self.diceDetails, dice: self.diceDetails.dice) })
            }
            .background(Image("AttrIcon").resizable().frame(width: 90, height: 100, alignment: .center))
            
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
                            speedProf
                            if character.model.isSpellCaster {
                                HStack {
                                    HStack {
                                        VStack {
                                            Text("Level:").frame(width: 50, height: 25, alignment: .center).cornerRadius(5)
                                            Text("Slots:").frame(width: 50, height: 35, alignment: .center).cornerRadius(5)
                                            Text("Used:").frame(width: 50, height: 35, alignment: .center).cornerRadius(5)
                                        }
                                        ForEach ( 1..<10 ) { idx in
                                            VStack(spacing: 3) {
                                                Text("\(idx)").frame(width: 35, height: 25, alignment: .center).cornerRadius(5)
                                                Text("\(self.character.model.spellSlots[idx]!)").frame(width: 35, height: 35, alignment: .center).background(Color(.white)).foregroundColor(.black).cornerRadius(5)
                                                Text("\(self.character.model.spellSlotsUsed[idx]!)").frame(width: 35, height: 35, alignment: .center).background(Color(.white)).foregroundColor(.black).cornerRadius(5)
                                            }
                                        }
                                    }
                                    .background(Color(.white).opacity(0.3)).cornerRadius(5)
                                    .foregroundColor(.black)
                                    .padding(4)
                                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                                    Spacer()
                                }
                            }
                            Spacer()
                        }.frame(height:110)
                        HStack {
                            VStack(spacing:5) {
                                GrayButton(text: "Skill", width: 120) {
                                    self.showingSkills = true
                                }
                                .sheet(isPresented: $showingSkills, content: { SkillCheckView()})
                                GrayButton(text: "Initiative", width: 120){
                                    self.diceDetails.title = "Initiative"
                                    self.showingInitDice = true
                                    self.diceDetails.isSave = false
                                }
                                .popover(isPresented: self.$showingInitDice, arrowEdge: .leading, content: { DiceView(details: self.diceDetails, dice: self.diceDetails.dice) })
                                
                                self.attributes
                            }
                            
                            VStack {
                                
                                
                                Picker("Filter", selection: $actionFilterIdx) {
                                    ForEach(0 ..< self.filterTimeings.count) { idx in
                                        Text(self.filterTimeings[idx].rawValue)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .cornerRadius(8)
                                ScrollView(.vertical) {
                                    VStack{
                                        ForEach(character.actions.filter({$0.timing == self.filterTimeings[actionFilterIdx] || actionFilterIdx == 0 }).sorted()) { action in
                                            if action.weapon != nil {
                                                WeaponAction(action: action)
                                            } else if action.spell != nil {
                                                SpellAction(action:action)
                                            } else {
                                                ActionRow(action:action)
                                            }
                                        }
                                        HStack{ Spacer() }
                                        Spacer()
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
    
    func attributeTouched(title:String, mod:Int) {
        self.diceDetails.title = title
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
        ActionView(model: Character.shared.model)
    }
}
