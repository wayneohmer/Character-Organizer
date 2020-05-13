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
    let attackTyes = ["Weapon","Spell"]
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var character = ObCharacer().character
    @State var selectedType = 0
    @State var selectedAttr = 0
    @State var proficient = false
    
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    @State var showingToHitBonus = false
    @State var toHitBonus:String = "0"
    @State var damageBonus:String = "0"
    @State var showingDamageDice = false
    @State var showingDamageBonus = false


    @State var action = Action(name: "New", desc: "")
    var diceDetails = DiceDetails()
    @State var damageDice = FyreDice()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.action.attrIndex = self.selectedAttr
                    self.action.attack_bonus = Int(self.toHitBonus) ?? 0
                    self.action.damage_bonus = Int(self.damageBonus) ?? 0
                    self.action.damageDice = self.damageDice.model
                    self.character.model.actions.insert(self.action, at: 0)
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Save").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
            }
            TextField("Name",text: self.$action.name).font(Font.system(size: 30, weight: .bold, design: .default))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
                .multilineTextAlignment(.center)
                .background(Color.white)
                .foregroundColor(Color.black)
            VStack{
                HStack{
                    Text("Type: ")
                    Picker("", selection: $selectedType) {
                        ForEach(0 ..< attackTyes.count) { index in
                            Text(self.attackTyes[index])
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
                HStack {
                    Toggle(isOn:$proficient) {
                        Text("Proficient:")
                    }.frame(width: 150)
                    Text("To Hit Bonus:")
                    Text("\(character.attrBonusArray[selectedAttr] + (proficient ? character.model.proficiencyBonus : 0) + (Int(self.toHitBonus) ?? 0))")
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
                    Text("Damage Dice:")
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
                    Text("Damage Bonus:")
                    Text("\(character.attrBonusArray[selectedAttr] + (Int(self.damageBonus) ?? 0))")
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
                    Spacer()
                }
            }
            Spacer()
        }
        .foregroundColor(Color.white)
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
        .onAppear(){
            if let weapon = self.weapon {
                self.action.weapon = weapon
                self.action.name = weapon.name
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

struct AttackCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AttackCreationView()
    }
}
