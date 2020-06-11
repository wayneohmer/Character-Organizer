//
//  DescriptionView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/19/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import Foundation
import SwiftUI

struct DescriptionView: View {
    
    enum SheetType {
        case detail, spellPicker, spellAction, attackAction, equipment, equipmentPicker
    }
   
    @EnvironmentObject var character: Character

    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    @State var showingDice = false
    @State var selectedDetail:Viewable = Proficiency()
    @State var selectedAction:Action = Action()
    @State var selectedAttack = Action()
    @State var detailShowing = false
    @State var sheetType = DescriptionView.SheetType.detail
 
    var body: some View {
        VStack {
            DemographicsView(selectedDetail: $selectedDetail, detailShowing: $detailShowing)
            VStack {
                ProficiencieView(selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType: $sheetType)
                SkillsView(selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType: $sheetType)
                TraitsView(selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType: $sheetType)
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2)).foregroundColor(Color.white)
            .background(Color.black)
            AttacksView(selectedAttack: $selectedAttack, detailShowing: $detailShowing, sheetType: $sheetType)
            EquipmentView(selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType: $sheetType)
            SpellsView(selectedAction: $selectedAction, detailShowing: $detailShowing, sheetType: $sheetType)
            Spacer()
        }.sheet(isPresented: self.$detailShowing, content:  {
            
            if self.sheetType == .detail {
                DetailView(detail: self.selectedDetail, isFromInventory: true )
            }  else if self.sheetType == .equipmentPicker {
                EquipmentPicker()
            } else if self.sheetType == .spellPicker {
                SpellPicker()
            } else if self.sheetType == .spellAction {
                SpellActionEditor(action: self.selectedAction)
            } else if self.sheetType == .attackAction {
                WeaponAttackView(action: self.selectedAttack)
            }
        })
        .foregroundColor(Color(.white))
        .background(background)
        .onAppear(){
            //forces redraw
            self.detailShowing = true
            self.detailShowing = false
        }
        
    }
}

struct DemographicsView:  View {

@EnvironmentObject var character: Character
@Binding var selectedDetail:Viewable
@Binding var detailShowing:Bool

    var body: some View {
        HStack {
            Image("Wayne").resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height:90, alignment: .top)
                .padding(3)
            VStack {
                Text(character.name)
                    .font(Font.system(size: 30, weight: .bold, design: .default))
                    .foregroundColor(Color.white)
                HStack {
                    Text("Race:").foregroundColor(Color.white)
                    Text(character.race.name).fontWeight(.bold).foregroundColor(Color.white)
                    Text("Class:").foregroundColor(Color.white)
                    Text(character.charcaterClass.name).fontWeight(.bold).foregroundColor(Color.white)
                    Text("Alignment:").foregroundColor(Color.white)
                    Text(character.alingment).fontWeight(.bold).foregroundColor(Color.white)
                    Spacer()
                }.offset(CGSize(width: 8, height: 0))
                HStack{
                    Text("Speed:").foregroundColor(Color.white)
                    Text(character.speed).fontWeight(.bold).foregroundColor(Color.white)
                    Text("Level:").foregroundColor(Color.white)
                    Text(character.level).fontWeight(.bold).foregroundColor(Color.white)
                    Spacer()
                }.offset(CGSize(width: 8, height: 0))
                HStack {
                    Text("Languages:").foregroundColor(Color.white)
                    Text(character.languageString).fontWeight(.bold)
                    Spacer()
                }.offset(CGSize(width: 8, height: 0))
            }
        }
    }
}

struct AttacksView: View {
    
    @EnvironmentObject var character: Character
    @Binding var selectedAttack:Action
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType
    
    var body: some View {
        VStack {
            HStack{
                Text("Attacks").fontWeight(.bold).foregroundColor(Color.white)
                Button(action:{
                    self.sheetType = .attackAction
                    self.detailShowing = true
                }) {
                    Text("+").fontWeight(.bold).foregroundColor(Color.white)
                }.padding(5)
            }
            if character.weaponAttacks.count + character.otherAttacks.count > 0 {
                
                VStack(alignment: .leading){
                    HStack {
                        if character.weaponAttacks.count > 0 {
                            Text("Weapons:").font(Font.system(size: 20, weight: .bold))
                            AttackTypeView(actions: character.weaponAttacks, selectedAttack: $selectedAttack, detailShowing: $detailShowing, sheetType:$sheetType )
                        }
                    }
                    if character.otherAttacks.count > 0 {
                        HStack {
                            Text("Others:").font(Font.system(size: 20, weight: .bold))
                            AttackTypeView(actions: character.otherAttacks, selectedAttack: $selectedAttack, detailShowing: $detailShowing, sheetType:$sheetType)
                            
                        }
                    }
                }.padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                    .background(Color.black)
            }
            
        }
    }
}

struct AttackTypeView:  View {
    
    var actions:[Action]
    @Binding var selectedAttack:Action
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType

    var body: some View {
        ScrollView(.horizontal) {
            HStack { ForEach(actions) { action in
                Text(action.name).onTapGesture {
                    self.selectedAttack = action
                    self.detailShowing = true
                    self.sheetType = .attackAction
                }.font(Font.system(size: 18))
                    .padding(4)
                    .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .cornerRadius(8)
                }
            }
        }
    }
}


struct SpellsView:  View {

    @EnvironmentObject var character: Character
    @Binding var selectedAction:Action
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType

    var levelNames = ["Cantrips","1st","2nd","3rd","4th","5th","6th","7th","8th","9th"]

    var body: some View {
        VStack {
            HStack{
                Text("Spells").fontWeight(.bold).foregroundColor(Color.white)
                Button(action:{
                    self.detailShowing = true
                    self.sheetType = .spellPicker
                }) {
                    Text("+").fontWeight(.bold).foregroundColor(Color.white)
                }
            }.padding(5)
            if character.spells.count > 0 {
                VStack(alignment: .leading) {
                    ForEach ( 0 ..< 9) { index in
                        HStack {
                            if self.character.spells.filter({ $0.level == index }).count > 0 {
                                Text("\(self.levelNames[index] ):").font(Font.system(size: 20, weight: .bold))
                                SpellLevelView(spells: self.character.spellActions.filter({ $0.spell?.level == index}), selectedAction: self.$selectedAction, detailShowing: self.$detailShowing, sheetType: self.$sheetType)
                            }
                        }
                    }
                }.padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                    .background(Color.black)
            }
        }
    }
}

struct SpellLevelView:  View {

    var spells:[Action]
    @Binding var selectedAction:Action
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType

    var body: some View {
        ScrollView(.horizontal) {
            HStack{
                ForEach(spells.sorted()) { action in
                    DetailTextActionView(action: action, selectedAction: self.$selectedAction, detailShowing: self.$detailShowing, sheetType: self.$sheetType )
                }
            }
        }
    }
}


struct EquipmentView:  View {

    @EnvironmentObject var character: Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType

    var body: some View {
        VStack {
            HStack{
                Text("Equipment").fontWeight(.bold).foregroundColor(Color.white)
                Button(action:{
                    self.sheetType = .equipmentPicker
                    self.detailShowing = true
                }) {
                    Text("+").fontWeight(.bold).foregroundColor(Color.white)
                }
            }.padding(5)
            VStack(alignment: .leading){
                HStack {
                    if character.weapons.count > 0 {
                        Text("Weapons:").font(Font.system(size: 20, weight: .bold))
                        EquipmentTypeView(equipment: character.weapons , selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType:$sheetType)
                    }
                }
                HStack {
                    if character.armor.count > 0 {
                        Text("Armor:").font(Font.system(size: 20, weight: .bold))
                        EquipmentTypeView(equipment: character.armor , selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType:$sheetType)
                    }
                }
                HStack {
                    Text("Other Shit:").font(Font.system(size: 20, weight: .bold))
                    EquipmentTypeView(equipment: Array(character.equipment.filter({
                        $0.equipment_category != "Armor" &&  $0.equipment_category != "Weapon"
                    })) , selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType:$sheetType)

                }
            }.padding(8)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .background(Color.black)
        }
    }
}

struct DetailTextView:  View {
    
    let thing:Viewable
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType

    var body: some View {
        Text(thing.name).onTapGesture {
            self.selectedDetail = self.thing
            self.sheetType = .detail
            self.detailShowing = true
        }.font(Font.system(size: 18))
            .padding(4)
            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
            .cornerRadius(8)
    }
}

struct DetailTextActionView:  View {

    let action:Action
    @Binding var selectedAction:Action
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType


    var body: some View {
        Text(action.name).onTapGesture {
            self.selectedAction = self.action
            self.detailShowing = true
            self.sheetType = .spellAction
        }.font(Font.system(size: 18))
            .padding(4)
            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
            .cornerRadius(8)
    }
}


struct EquipmentTypeView:  View {
    
    var equipment:[Equipment]
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType

    
    var body: some View {
        ScrollView(.horizontal) {
            HStack{ ForEach(equipment.sorted()) { equipment in
                DetailTextView(thing: equipment, selectedDetail: self.$selectedDetail, detailShowing: self.$detailShowing, sheetType: self.$sheetType)
                }
            }
        }
    }
}

struct ProficiencieView:  View {
    
    @EnvironmentObject var character: Character

    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType

    var body: some View {
        
        HStack {
            Text("Proficiencies:").font(Font.system(size: 20, weight: .bold))
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(character.proficiencies) ) { proficiency in
                        DetailTextView(thing: proficiency, selectedDetail: self.$selectedDetail , detailShowing: self.$detailShowing, sheetType:self.$sheetType)
                    }
                }
            }
        }
    }
}

struct SkillsView:  View {
    
    @EnvironmentObject var character: Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType

    var body: some View {
        HStack {
            Text("Skills:").font(Font.system(size: 20, weight: .bold))
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(character.skills) ) { skill in
                        DetailTextView(thing: skill, selectedDetail: self.$selectedDetail , detailShowing: self.$detailShowing, sheetType:self.$sheetType)
                    }
                }
            }
        }
    }
}

struct TraitsView:  View {
    
    @EnvironmentObject var character: Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType

    var body: some View {
        HStack {
            Text("Traits:").font(Font.system(size: 20, weight: .bold))
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(character.traits) ) { trait in
                        DetailTextView(thing: trait, selectedDetail: self.$selectedDetail , detailShowing: self.$detailShowing, sheetType:self.$sheetType)
                    }
                }
            }
        }
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView()
    }
}
