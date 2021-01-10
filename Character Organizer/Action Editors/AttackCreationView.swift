//
//  AttackCreationView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 3/22/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct WeaponAttackView: View  {
    

    @State var action: Action

    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    let timing = ActionTiming.allCases

    var body: some View {
        VStack() {
            HeaderBarView(name: "", saveAction:self.saveAction, deleteAction: self.deleteAction)
            
            TextField("Name",text: self.$action.name).font(Font.system(size: 30, weight: .bold, design: .default))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
                .multilineTextAlignment(.center)
                .background(Color.white)
                .foregroundColor(Color.black)
                .padding(16)
            HStack {
                Text("Timeing:")
                Picker("", selection: self.$action.timingIndex) {
                    ForEach(0 ..< 3) { index in
                        Text(self.timing[index].rawValue )
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color(.lightGray))
                .cornerRadius(8)
            }
            AttackCreationView(action: self.$action)
            TextView(text: self.$action.desc)
                .padding()
                .cornerRadius(5)
        }
        .foregroundColor(.white)
        .background(Color(.black))
    }
    
    func saveAction(){
        if let action = Character.shared.model.actions.filter({$0.name == self.action.name}).first {
            Character.shared.model.actions.remove(action)
        }
        self.action.damageType = DamageType.shared.map({$0.value.name}).sorted()[action.damageTypeIndex]
        self.action.spell = nil
        Character.shared.model.actions.insert(self.action)
    }
    
    func deleteAction() {
        if let action = Character.shared.model.actions.filter({$0.name == self.action.name}).first {
            Character.shared.model.actions.remove(action)
        }
    }
}

struct AttackCreationView: View {
    
    var weapon:Equipment?
    var spell:Spell?
    let damageTypes:[String] = DamageType.shared.map({$0.value.name}).sorted()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var character = Character.shared
    @State var selectedType = 0
    @State var damageTypeIdx = 0
    
    @Binding var action:Action
    
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    @State var showingToHitBonus = false
    @State var showingDamageBonus = false
    @State var showingDamageDice = false
    @State var desc = ""
    @State var isNew = true
    
    var oldAction:Action?
    var diceDetails = DiceDetails()
    @State var damageDice = FyreDice()
    
    var body: some View {
        VStack {
            HStack{
                Text("Attribute:")
                Picker("", selection: self.$action.attrIndex) {
                    ForEach(0 ..< Character.AttributeArray.count) { index in
                        Text(Character.AttributeArray[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color(.lightGray))
                .cornerRadius(8)
            }
            HStack {
                VStack {
                    HStack {
                    Text("To Hit: \(self.toHitTotal())").font(Font.system(size: 20, weight: .bold, design: .default))
                        Spacer()
                    }
                    HStack {
                        Toggle(isOn:self.$action.isProficient) {
                            Text("Proficient:")
                        }.frame(width:150)
                        Text("Bonus:")
                        Text("\(self.action.attack_bonus)")
                            .onTapGesture {
                                self.showingToHitBonus = true
                        }
                        .frame(width: 55, height:30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(5)
                        .popover(isPresented: $showingToHitBonus, content: {
                            NumberEditor(value: "0", modifiedValue: self.$action.attack_bonus , isHP: false)
                        })
                        
                        Spacer()
                    }
                    HStack{
                        Text("Damage: \(self.damageTotal())").font(Font.system(size: 20, weight: .bold, design: .default))
                        Spacer()
                    }
                    HStack {
                        Text("Dice:")
                        Text(action.damageFyreDice.display).onTapGesture {
                            self.showingDamageDice = true
                        }
                        .frame(width: 70, height:30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(5)
                        .popover(isPresented: $showingDamageDice, content: {
                            DicePickerView(details: DiceDetails(title: self.action.name), diceModel: self.$action.damageDice)
                        })
                        Text("Bonus:").frame(width: 75)
                        Text("\(action.damage_bonus)").onTapGesture {
                            self.showingDamageBonus = true
                        }
                        .frame(width: 45, height:30)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(5)
                        .popover(isPresented: $showingDamageBonus, content: {
                            NumberEditor(value: "0", modifiedValue: self.$action.damage_bonus, isHP: false)
                        })
                        Toggle(isOn:$action.attrDamage) {
                            Text("Add Attrbiute:")
                        }.frame(width:170)
                        Spacer()
                    }
                }
                HStack {
                    Text("Type:")
                    Picker("", selection: $action.damageTypeIndex) {
                        ForEach(0 ..< self.damageTypes.count) { index in
                            Text(String(self.damageTypes[index]))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .background(Color(.lightGray))
                    .frame(width: 170, height: 100)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .foregroundColor(Color.white)
        .background(Color(.black))
        
    }
    
    func toHitTotal() -> String {
        
        let total = (self.action.attack_bonus) + (self.action.isProficient ? (character.model.proficiencyBonus) : 0) + character.attrBonusArray[action.attrIndex]
        
        return "\(total < 0 ? "" : "+") \(total)"
    }
    
    func damageTotal() -> String {
        
        let total = self.action.damage_bonus + (self.action.attrDamage ? character.attrBonusArray[action.attrIndex] : 0)
        
        return "\(total < 0 ? "" : "+") \(total)"
    }
}

struct AttackCreationView_Previews: PreviewProvider {

    static var previews: some View {

        WeaponAttackView(action: Action())
    }
}
