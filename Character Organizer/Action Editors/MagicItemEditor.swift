//
//  SpellmagicItemEditor.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 5/28/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct MagicItemEditor: View  {
    
    @State var magicItem: MagicItem
    @State var isAction = false
    @State var requiresAttunement = false
    @State var attuned = false
    let timing = ActionTiming.allCases
    var background = Color(red: 0.07, green: 0.07, blue: 0.07)

    var body: some View {
        VStack {
            
            HeaderBarView(name: magicItem.name, saveAction:self.saveMagicItem, deleteAction: self.deleteMagicItem)
            
            HStack {
                VStack (alignment: .leading){
                    VStack(alignment: .leading) {
                        VStack {
                            Button(action: {
                                self.magicItem.getPastedString()
                            }, label: {
                                Text("  Paste  ")
                            })
                            TextField("Name",text: self.$magicItem.name).font(Font.system(size: 30, weight: .bold, design: .default))
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
                                .multilineTextAlignment(.center)
                                .background(Color.white)
                                .foregroundColor(Color.black)
                                .padding(16)
                            
                            HStack {
                                Toggle(isOn: self.$magicItem.isAction ) { Text("Action?")}.frame(width: 130, height: 40)
                                Toggle(isOn: self.$magicItem.requiresAttunement ) { Text("Requires Attunement?")}.frame(width: 230, height: 40)
                                if self.magicItem.requiresAttunement {
                                    Toggle(isOn: self.$magicItem.attuned ) { Text("Attuned?")}.frame(width: 130, height: 40)
                                }
                                Spacer()
                            }
                            if self.magicItem.isAction {
                                HStack {
                                    Text("Timeing:")
                                    Picker("", selection: self.$magicItem.action.timingIndex) {
                                        ForEach(0 ..< 4) { index in
                                            Text(self.timing[index].rawValue )
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .background(Color(.lightGray))
                                    .cornerRadius(8)
                                }
                                HStack {
                                    Toggle(isOn: self.$magicItem.action.isAttack ) { Text("Attack?")}.frame(width: 130, height: 40)
                                    Spacer()
                                }
                                if self.magicItem.action.isAttack {
                                    AttackCreationView(action: self.$magicItem.action)
                                }
                            }
                        }
                    }.padding()
                    .background(Color(.black))
                }
                Spacer()
            }
            
            TextView(text: $magicItem.desc)
            
            Spacer()
        }
        .background(background)
        .foregroundColor(.white)
        
    }
    
    func saveMagicItem(){
        if Character.shared.model.magicItems == nil {
            Character.shared.model.magicItems = Set<MagicItem>()
        }
        if let magicItem = Character.shared.model.magicItems?.filter({$0.name == self.magicItem.name}).first {
            Character.shared.model.magicItems?.remove(magicItem)
        }
        self.magicItem.action.damageType = DamageType.shared.map({$0.value.name}).sorted()[self.magicItem.action.damageTypeIndex]

        Character.shared.model.magicItems?.insert(self.magicItem)
    }

    func deleteMagicItem() {
        if let magicItem = Character.shared.model.magicItems?.filter({$0.name == self.magicItem.name}).first {
            Character.shared.model.magicItems?.remove(magicItem)
        }
    }
    
}

struct MagicItemEditor_Previews: PreviewProvider {
    static var previews: some View {
        MagicItemEditor(magicItem: MagicItem())
    }
}
