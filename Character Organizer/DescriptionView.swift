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
    
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    @State var character = Character.shared
    @State var showingDice = false
    @State var selectedDetail:Viewable = Proficiency()
    @State var selectedAttack = Action()
    @State var detailShowing = false
    @State var equipmentShowing = false
    @State var spellsShowing = false
    @State var attacksShowing = false

    var body: some View {
        VStack {
            DemographicsView(character: $character, selectedDetail: $selectedDetail, detailShowing: $detailShowing)
            ScrollView{
                
                VStack {
                    
                    ProficiencieView(character: $character, selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                    SkillsView(character: $character, selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                    TraitsView(character: $character, selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                    
                }
                .sheet(isPresented: self.$detailShowing, content:  { DetailView(detail: self.selectedDetail ) })
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2)).foregroundColor(Color.white)
                .background(Color.black)
                AttacksView(character: $character, selectedAttack: $selectedAttack, detailShowing: $detailShowing, attacksShowing: $attacksShowing)
                    .sheet(isPresented: self.$attacksShowing, content:  { AttackCreationView(actionIdx: self.character.actions.firstIndex(where:
                        { self.selectedAttack.id == $0.id} ) ?? 0, oldAction:self.selectedAttack) })
                EquipmentView(character: $character, selectedDetail: $selectedDetail, detailShowing: $detailShowing, equipmentShowing: $equipmentShowing)
                    .sheet(isPresented: self.$equipmentShowing, content:  { EquipmentPicker(character: self.$character) })
                SpellsView(character: $character, selectedDetail: $selectedDetail, spellsShowing: $spellsShowing, detailShowing: $detailShowing)
                    .sheet(isPresented: self.$spellsShowing, content:  { SpellPicker(character: self.$character) })
                Spacer()
            }
            
        }
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

@Binding var character:Character
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
    
    @Binding var character:Character
    @Binding var selectedAttack:Action
    @Binding var detailShowing:Bool
    @Binding var attacksShowing:Bool
    
    
    var body: some View {
        VStack {
            HStack{
                Text("Attacks").fontWeight(.bold).foregroundColor(Color.white)
                Button(action:{
                    self.attacksShowing = true
                }) {
                    Text("+").fontWeight(.bold).foregroundColor(Color.white)
                }.padding(5)
            }
            VStack(alignment: .leading){
                HStack {
                    if character.weaponAttacks.count > 0 {
                        Text("Weapons:").font(Font.system(size: 20, weight: .bold))
                        AttackTypeView(actions: character.weaponAttacks, selectedAttack: $selectedAttack, attacksShowing: $attacksShowing)
                    }
                }
                HStack {
                    if character.spellAttacks.count > 0 {
                        Text("Spells:").font(Font.system(size: 20, weight: .bold))
                        AttackTypeView(actions: character.spellAttacks, selectedAttack: $selectedAttack, attacksShowing: $attacksShowing)
                    }
                }
                HStack {
                    Text("Others:").font(Font.system(size: 20, weight: .bold))
                    AttackTypeView(actions: character.otherAttacks, selectedAttack: $selectedAttack, attacksShowing: $attacksShowing)
                    
                }
            }.padding(8)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .background(Color.black)
        }
    }
}



struct SpellsView:  View {
    
    @Binding var character:Character
    @Binding var selectedDetail:Viewable
    @Binding var spellsShowing:Bool
    @Binding var detailShowing:Bool
    
    var body: some View {
        VStack {
            HStack{
                Text("Spells").fontWeight(.bold).foregroundColor(Color.white)
                Button(action:{
                    self.spellsShowing = true
                }) {
                    Text("+").fontWeight(.bold).foregroundColor(Color.white)
                }
            }.padding(5)
            if character.spells.count > 0 {
                VStack(alignment: .leading) {
                    HStack {
                        if character.spells.filter({ $0.level == 0 }).count > 0 {
                            Text("Cantrips:").font(Font.system(size: 20, weight: .bold))
                            SpellLevelView(spells: character.spells.filter({ $0.level == 0 }), selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                        }
                    }
                    HStack {
                        if character.spells.filter({ $0.level == 1 }).count > 0 {
                            Text("1st:").font(Font.system(size: 20, weight: .bold))
                            SpellLevelView(spells: character.spells.filter({ $0.level == 1 }), selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                        }
                    }
                    HStack {
                        if character.spells.filter({ $0.level == 2 }).count > 0 {
                            Text("2nd:").font(Font.system(size: 20, weight: .bold))
                            SpellLevelView(spells: character.spells.filter({ $0.level == 2 }), selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                        }
                    }
                    HStack {
                        if character.spells.filter({ $0.level == 3 }).count > 0 {
                            Text("3rd:").font(Font.system(size: 20, weight: .bold))
                            SpellLevelView(spells: character.spells.filter({ $0.level == 3 }), selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                        }
                    }
                    HStack {
                        if character.spells.filter({ $0.level == 4 }).count > 0 {
                            Text("4th:").font(Font.system(size: 20, weight: .bold))
                            SpellLevelView(spells: character.spells.filter({ $0.level == 4 }), selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                        }
                    }
                    HStack {
                        if character.spells.filter({ $0.level == 5 }).count > 0 {
                            Text("5th:").font(Font.system(size: 20, weight: .bold))
                            SpellLevelView(spells: character.spells.filter({ $0.level == 5 }), selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                        }
                    }
                    HStack {
                        if character.spells.filter({ $0.level == 6 }).count > 0 {
                            Text("6th:").font(Font.system(size: 20, weight: .bold))
                            SpellLevelView(spells: character.spells.filter({ $0.level == 6 }), selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                        }
                    }
                    HStack {
                        if character.spells.filter({ $0.level == 7 }).count > 0 {
                            Text("7th:").font(Font.system(size: 20, weight: .bold))
                            SpellLevelView(spells: character.spells.filter({ $0.level == 7 }), selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                        }
                    }
                    HStack {
                        if character.spells.filter({ $0.level == 8 }).count > 0 {
                            Text("8th:").font(Font.system(size: 20, weight: .bold))
                            SpellLevelView(spells: character.spells.filter({ $0.level == 8 }), selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                        }
                    }
                    HStack {
                        if character.spells.filter({ $0.level == 9 }).count > 0 {
                            Text("9th:").font(Font.system(size: 20, weight: .bold))
                            SpellLevelView(spells: character.spells.filter({ $0.level == 9 }), selectedDetail: $selectedDetail, detailShowing: $detailShowing)
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
    
    var spells:[Spell]
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack{ ForEach(spells.sorted()) { spell in
                DetailTextView(thing: spell, selectedDetail: self.$selectedDetail, detailShowing: self.$detailShowing)
                }
            }
        }
    }
}


struct EquipmentView:  View {
    
    @Binding var character:Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    @Binding var equipmentShowing:Bool
    
    var body: some View {
        VStack {
            HStack{
                Text("Equipment").fontWeight(.bold).foregroundColor(Color.white)
                Button(action:{
                    self.equipmentShowing = true
                }) {
                    Text("+").fontWeight(.bold).foregroundColor(Color.white)
                }
            }.padding(5)
            VStack(alignment: .leading){
                HStack {
                    if character.weapons.count > 0 {
                        Text("Weapons:").font(Font.system(size: 20, weight: .bold))
                        EquipmentTypeView(equipment: character.weapons , selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                    }
                }
                HStack {
                    if character.armor.count > 0 {
                        Text("Armor:").font(Font.system(size: 20, weight: .bold))
                        EquipmentTypeView(equipment: character.armor , selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                    }
                }
                HStack {
                    Text("Other Shit:").font(Font.system(size: 20, weight: .bold))
                    EquipmentTypeView(equipment: Array(character.equipment.filter({
                        $0.equipment_category != "Armor" &&  $0.equipment_category != "Weapon"
                    })) , selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                    
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
    
    
    var body: some View {
        Text(thing.name).onTapGesture {
            self.selectedDetail = self.thing
            self.detailShowing = true
        }.font(Font.system(size: 18))
            .padding(4)
            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
            .cornerRadius(8)
    }
}

struct AttackTypeView:  View {
    
    var actions:[Action]
    @Binding var selectedAttack:Action
    @Binding var attacksShowing:Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack { ForEach(actions) { action in
                Text(action.name).onTapGesture {
                    self.selectedAttack = action
                    self.attacksShowing = true
                }.font(Font.system(size: 18))
                    .padding(4)
                    .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct EquipmentTypeView:  View {
    
    var equipment:[Equipment]
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack{ ForEach(equipment.sorted()) { equipment in
                DetailTextView(thing: equipment, selectedDetail: self.$selectedDetail, detailShowing: self.$detailShowing)
                }
            }
        }
    }
}

struct ProficiencieView:  View {
    
    @Binding var character:Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    
    var body: some View {
        
        HStack {
            Text("Proficiencies:").font(Font.system(size: 20, weight: .bold))
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(character.proficiencies) ) { proficiency in
                        DetailTextView(thing: proficiency, selectedDetail: self.$selectedDetail , detailShowing: self.$detailShowing)
                    }
                }
            }
        }
    }
}

struct SkillsView:  View {
    
    @Binding var character:Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    
    var body: some View {
        HStack {
            Text("Skills:").font(Font.system(size: 20, weight: .bold))
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(character.skills) ) { skill in
                       DetailTextView(thing: skill, selectedDetail: self.$selectedDetail , detailShowing: self.$detailShowing)
                    }
                }
            }
        }
    }
}

struct TraitsView:  View {
    
    @Binding var character:Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    
    var body: some View {
        HStack {
            Text("Traits:").font(Font.system(size: 20, weight: .bold))
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(character.traits) ) { trait in
                         DetailTextView(thing: trait, selectedDetail: self.$selectedDetail , detailShowing: self.$detailShowing)
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
