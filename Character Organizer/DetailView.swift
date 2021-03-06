//
//  DetailView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var character: Character

    var detail: Viewable
    var isFromInventory = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Close").fontWeight(.bold).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
                
            }
            Text(detail.name).font(.title).padding(5)
            if detail is Equipment {
                EquipmentDetail(equipment:detail as! Equipment, isFromInventory: isFromInventory )
            } else if detail is Spell {
                SpellDetail(spell: detail as! Spell)
            } else {
                HStack {
                    Text(detail.description).fontWeight(.bold).padding(8)
                    Spacer()
                }
            }
            Spacer()
        }
        .background(Image("parchment").resizable().opacity(0.8))
        .foregroundColor(Color.black)
        .onAppear(){
            //self.character.model = Character.shared.model
        }
        
    }
}

struct EquipmentDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var character: Character

    var equipment: Equipment
    @State var detailShow = false
    @State var showAttack = false
    @State var isFromInventory: Bool
    @State var selectedDetail: Viewable = Equipment()
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 8) {
                if equipment.equipment_category == "Weapon" {
                    HStack {
                        Text("Category: ")
                        Text(equipment.category_range ?? "").bold()
                    }
                    HStack {
                        Text("Damage: ")
                        Text("\(equipment.damage?.damage_dice ?? "")").bold()
                        if equipment.damage?.damage_bonus ?? 0 > 0 {
                            Text("+\(equipment.damage?.damage_bonus ?? 0)")
                        }
                        Text(equipment.damage?.damage_type?.name ?? "").bold().onTapGesture {
                            self.selectedDetail = DamageType.shared[self.equipment.damage?.damage_type?.url ?? ""] ?? Equipment()
                            self.detailShow = true
                        }
                    }
                    if equipment.range?.long ?? 0 > 0 {
                        Text("Range:  \(equipment.range?.normal ?? 0)/\(equipment.range?.long ?? 0)").bold()
                    }
                    if equipment.properties?.count ?? 0 > 0 {
                        Text("Properties").frame(maxWidth: .infinity, alignment: .center).font(.title)
                    }
                    ForEach(equipment.properties ?? [Descriptor]() ) { property in
                        Text(property.name).bold().onTapGesture {
                            self.selectedDetail = WeaponProperties.shared[property.url] ?? Equipment()
                            self.detailShow = true
                        }
                    }.sheet(isPresented: self.$detailShow, content:  { DetailView(detail:  self.selectedDetail ) })
                    
                    ForEach(equipment.special ?? [String](), id:\.self) { line in
                        Text(line)
                    }
                    if self.isFromInventory {
                        GrayButton(text: "Make Attack", width: 150, action: {
                            self.showAttack = true
                        })
                            
                            .sheet(isPresented: self.$showAttack, content: {
                                WeaponAttackView(action: Action.fromWeapon(weapon: self.equipment))
                                
                            })
                    }
                    
                } else if equipment.equipment_category == "Armor" {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(equipment.armor_category ?? "")
                            HStack {
                                Text("Armor Class:")
                                Text("\(equipment.armor_class?.base ?? 0)")
                                if equipment.armor_class?.dex_bonus ?? false {
                                    Text("+ Dex Modifier")
                                }
                                if equipment.armor_class?.max_bonus ?? 0 > 0 {
                                    Text("(max \(equipment.armor_class?.max_bonus ?? 0))")
                                }
                            }
                            if equipment.str_minimum ?? 0 > 0 {
                                Text("Minimum Strength: \( equipment.str_minimum ?? 0 )")
                            }
                            if equipment.stealth_disadvantage ?? false {
                                Text("Stealth Disadvantage")
                            }
                        }
                        Spacer()
                    }
                } else {
                    Text(equipment.description)
                }
            }
        }.padding()
        
    }
}


struct SpellHeader: View {
    
    var spell: Spell
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Level:")
                Text("\(spell.level)")
            }
            HStack{
                Text("Range:")
                Text(spell.range).fontWeight(.bold)
            }
            HStack{
                Text("Components:")
                Text("\(spell.components)").fontWeight(.bold).minimumScaleFactor(0.5).lineLimit(1)
            }
            HStack{
                Text("Casting Time:")
                Text(spell.castingTime).fontWeight(.bold)
            }
            HStack{
                Text("School:")
                Text("\(spell.school ?? "")").fontWeight(.bold)
            }
            HStack{
                Text("Duration:")
                Text("\(spell.concentration ? "Concentration - " : "")\(spell.duration)").fontWeight(.bold)
            }
            if spell.saveType != "" {
                HStack{
                    Text("Save:")
                    Text("\(spell.saveType)").fontWeight(.bold)
                }
            }
        }
    }
}

struct SpellDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var spell: Spell
    var action: Action?
    
    @State var showAttack = false
    @State var detailShow = false
    @State var isAttack = false
    @State var showingSpellDice = false
    
    var body: some View {
        VStack(alignment: .leading) {
            SpellHeader(spell: spell)
            ScrollView {
                Text(spell.description).fontWeight(.bold)
            }
        }.padding()
    }
}

protocol Viewable {
    
    var name:String { get }
    var description:String { get }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
