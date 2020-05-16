//
//  AttackCreationView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 3/22/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct AttackCreationView: View {
    
    var weapon:Equipment?
    let attackTypes = ["Weapon","Spell"]
    let damageTypes:[String] = DamageType.shared.map({$0.value.name}).sorted()

    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var character = ObCharacer().character
    @State var selectedType = 0
    @State var selectedAttr = 0
    @State var damageTypeIdx = 0

    @State var isProficient = true
    @State var attrDamage = true

    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    @State var showingToHitBonus = false
    @State var toHitBonus:String = "0"
    @State var damageBonus:String = "0"
    @State var showingDamageDice = false
    @State var showingDamageBonus = false
    @State var desc = ""
    var actionIdx = 0
    @State var isNew = true

    @State var action = Action()
    var oldAction:Action?
    var diceDetails = DiceDetails()
    @State var damageDice = FyreDice()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.updateAction()
                    self.character.model.actions.insert(self.action, at: 0)
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("\(self.isNew ? "Save" : "Copy")").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
                if !self.isNew {
                    Button(action: {
                        self.updateAction()
                        self.character.model.actions[self.actionIdx] = self.action
                        self.presentationMode.wrappedValue.dismiss()
                    } ) {
                        Text("Replace").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                    }.frame(width: 100, height: 50, alignment: .center)
                }
            }
            TextField("Name",text: self.$action.name).font(Font.system(size: 30, weight: .bold, design: .default))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
                .multilineTextAlignment(.center)
                .background(Color.white)
                .foregroundColor(Color.black)
                .padding(16)
            VStack{
                HStack{
                    Text("Type: ")
                    Picker("", selection: $selectedType) {
                        ForEach(0 ..< attackTypes.count) { index in
                            Text(self.attackTypes[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 500)
                    .background(Color(.lightGray))
                    .cornerRadius(8)

                    Spacer()
                }
                HStack{
                Text("Attribute:")
                Picker("", selection: $selectedAttr) {
                    ForEach(0 ..< Character.AttributeArray.count) { index in
                        Text(Character.AttributeArray[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color(.lightGray))
                .cornerRadius(8)
                }
                Text("To Hit \(self.toHitTotal())").font(Font.system(size: 30, weight: .bold, design: .default))

                HStack {
                    Toggle(isOn:$isProficient) {
                        Text("Proficient:")
                    }.frame(width:150)
                    Text("Bonus:")
                    Text(self.toHitBonus)
                    .onTapGesture {
                        self.showingToHitBonus = true
                    }
                    .frame(width: 45, height:30)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(5)
                    .popover(isPresented: $showingToHitBonus, content: {
                        NumberEditor(value: "0", modifiedValue: self.$toHitBonus , isHP: false)
                    })
                    Spacer()
                }
                Text("Damage \(self.damageTotal())").font(Font.system(size: 30, weight: .bold, design: .default))
                HStack {
                    Text("Dice:")
                    Text(self.damageDice.display)
                    .onTapGesture {
                        self.showingDamageDice = true
                    }
                    .frame(width: 75, height:30)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(5)
                    .popover(isPresented: $showingDamageDice, content: {
                        DicePickerView(details: self.diceDetails, dice: self.damageDice)
                    })
                    Text("Bonus:")
                    
                    Text(self.damageBonus).onTapGesture {
                        self.showingDamageBonus = true
                    }
                    .frame(width: 45, height:30)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(5)
                    .popover(isPresented: $showingDamageBonus, content: {
                        NumberEditor(value: "0", modifiedValue: self.$damageBonus , isHP: false)
                    })
                    Toggle(isOn:$attrDamage) {
                        Text("Add Attrbiute:")
                    }.frame(width:170)
                       
                    Picker("", selection: $damageTypeIdx) {
                        ForEach(0 ..< self.damageTypes.count) { index in
                            Text(String(self.damageTypes[index]))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .background(Color(.lightGray))
                    .frame(width: 170, height: 100)
                    .cornerRadius(8)
                    Spacer()
                }
                TextField("Description",text: $desc)
                    .frame(height: 50, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
                    .multilineTextAlignment(.center)
                    .background(Color.white)
                    .foregroundColor(Color.black)
            }
            Spacer()
        }
        .padding()
        .foregroundColor(Color.white)
        .background(Color(.black))
        .onAppear(){
            if let oldAction = self.oldAction {
                self.action.name = oldAction.name
                self.action.weapon = oldAction.weapon
                self.action.spell = oldAction.spell
                self.selectedType = oldAction.weapon != nil ? 0 : 1
                self.selectedAttr = oldAction.attrIndex
                self.toHitBonus = "\(oldAction.attack_bonus ?? 0)"
                self.isProficient = oldAction.isPoficient
                self.damageDice = FyreDice(with: oldAction.damageDice?.dice ?? [:], modifier: 0)
                self.damageBonus = "\(oldAction.damage_bonus ?? 0)"
                self.damageTypeIdx = self.damageTypes.firstIndex(of: oldAction.damageType ?? "") ?? 0
                self.desc = oldAction.desc
                self.isNew = false
            } else {
            
                if let weapon = self.weapon {
                    self.action.weapon = weapon
                    self.action.name =  self.weapon!.name
                    if weapon.weapon_range == "Melee" {
                        self.selectedAttr = 0
                    }
                    if weapon.weapon_range == "Ranged" {
                        self.selectedAttr = 1
                    }
                    self.damageTypeIdx = self.damageTypes.firstIndex(of: weapon.damage?.damage_type?.name ?? "") ?? 0
                    self.action.desc = weapon.desc?.joined(separator: "\n") ?? ""
                    if let damageString = weapon.damage?.damage_dice {
                        let damageArray = damageString.split(separator: "d")
                        if damageArray.count == 2 {
                            if let d = Int(damageArray[0]), let m = Int(damageArray[1]) {
                                self.damageDice = FyreDice(with: [m:d], modifier: 0)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateAction() {
        self.action.attrIndex = self.selectedAttr
        self.action.isPoficient = self.isProficient
        self.action.attrDamage = self.attrDamage
        self.action.attack_bonus = Int(self.toHitBonus) ?? 0
        self.action.damage_bonus = Int(self.damageBonus) ?? 0
        self.action.damageDice = self.damageDice.model
        self.action.desc = self.desc
        self.action.isAttack = true
        self.action.damageType = self.damageTypes[self.damageTypeIdx]
    }
    
    func toHitTotal() -> String {
        
        let total = (Int(self.toHitBonus) ?? 0) + (self.isProficient ? (character.model.proficiencyBonus) : 0) + character.attrBonusArray[selectedAttr]
        
        return "\(total < 0 ? "" : "+") \(total)"
    }
    
    func damageTotal() -> String {
        
        let total = (Int(self.damageBonus) ?? 0) + (self.attrDamage ? character.attrBonusArray[selectedAttr] : 0)
        
        return "\(total < 0 ? "" : "+") \(total)"
    }
}

struct AttackCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AttackCreationView()
    }
}
