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
        case detail, spellPicker, miscAction, spellAction, attackAction, equipment, equipmentPicker, image, miscEditor, magicItem
    }
   
    @EnvironmentObject var character: Character

    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    @State var showingDice = false
    @State var selectedDetail:Viewable = Proficiency()
    @State var selectedAction:Action = Action()
    @State var selectedItem:MagicItem = MagicItem()
    @State var selectedAttack = Action()
    @State var detailShowing = false
    @State var sheetType = DescriptionView.SheetType.detail
    @State var image:UIImage?
    
    @State var spellShowing = true
    @State var actionsShowing = true
    @State var attacksShowing = true
    @State var itemsShowing = true
    @State var magicItemsShowing = true
    @State var miscShowing = true

    var body: some View {
        VStack {
            DemographicsView(selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType: $sheetType)
            HStack {
                GrayButton(text: "Long Rest", width: 100) {
                    self.character.longRest()
                }
                Spacer()
            }
            ScrollView(.vertical) {
                if character.model.isSpellCaster {
                    SpellsView(selectedAction: $selectedAction, detailShowing: $detailShowing, sheetType: $sheetType, spellShowing: $spellShowing)
                }
                
                MagicItemsView(selectedItem: $selectedItem, detailShowing: $detailShowing, sheetType: $sheetType, actionsShowing: $magicItemsShowing)
                MiscActionsView(selectedAction: $selectedAction, detailShowing: $detailShowing, sheetType: $sheetType, actionsShowing: $actionsShowing)
                AttacksView(selectedAttack: $selectedAttack, detailShowing: $detailShowing, sheetType: $sheetType, attacksShowing: $attacksShowing)
                EquipmentView(selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType: $sheetType, itemsShowing: $itemsShowing)
                MiscDetailsView(selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType: $sheetType, miscShowing: $miscShowing)
               
            }
            Spacer()
        }
        .sheet(isPresented: self.$detailShowing, content:  {

            if self.sheetType == .detail {
                DetailView(detail: self.selectedDetail, isFromInventory: true )
            }  else if self.sheetType == .equipmentPicker {
                EquipmentPicker()
            } else if self.sheetType == .spellPicker {
                SpellPicker().environmentObject(Character.shared)
            } else if self.sheetType == .spellAction {
                SpellActionEditor(action: self.selectedAction)
            } else if self.sheetType == .miscAction {
                MiscActionEditor(action: self.selectedAction)
            } else if self.sheetType == .attackAction {
                WeaponAttackView(action: self.selectedAttack)
            } else if self.sheetType == .miscEditor {
                MiscDetailPicker()
            } else if self.sheetType == .magicItem {
               MagicItemEditor(magicItem: self.selectedItem)
            } else if self.sheetType == .image {
                ImagePicker(image: self.$image, isPresented: self.$detailShowing).onDisappear(perform: {
                    self.character.image = self.image ?? UIImage()
                })
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

struct MagicItemsView: View {
    
    @EnvironmentObject var character: Character
    @Binding var selectedItem:MagicItem
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType
    @Binding var actionsShowing:Bool
    
    var body: some View {
        VStack {
            HStack{
                Button( action: {
                    withAnimation(.default,  { self.actionsShowing.toggle() } )
                }, label: { Image(self.actionsShowing ? "arrowDown" : "arrowLeft").resizable() })
                .frame(width: 30, height: 30)
                Spacer()
                Text("Magic Items").fontWeight(.bold).foregroundColor(Color.white)
                if self.character.itemsAttuned > 0 {
                    Text(" \(self.character.itemsAttuned) Attuned")
                    .foregroundColor( self.character.itemsAttuned > 3 ? Color.red : Color.white)
                }
                Spacer()
                GrayButton(text:"+",width: 40) {
                    self.sheetType = .magicItem
                    self.selectedItem = MagicItem()
                    self.detailShowing = true
                }
            }.frame(height: 45)
            if actionsShowing {
                if character.magicItems.count > 0 {
                    VStack(alignment: .leading){
                        HStack {
                            Text("Attuned:").font(Font.system(size: 20, weight: .bold))
                            MagicItemsListView(items: Array(character.magicItems.filter( { $0.attuned } )), selectedItem: $selectedItem, detailShowing: $detailShowing, sheetType:$sheetType )
                        }
                        HStack {
                            Text("Other:").font(Font.system(size: 20, weight: .bold))
                            MagicItemsListView(items: Array(character.magicItems.filter( { !$0.attuned } )), selectedItem: $selectedItem, detailShowing: $detailShowing, sheetType:$sheetType )
                        }
                        
                    }.padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                    .background(Color.black)
                }
            }
        }
    }
}

struct DemographicsView:  View {
    
    @EnvironmentObject var character: Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType
    @State var showingLevel = false
    @State var showingXP = false

    var body: some View {
        HStack {
            Image(uiImage: character.image).resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height:90)
                .padding(3)
                .onTapGesture {
                    self.detailShowing = true
                    self.sheetType = .image
            }
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
                }
                HStack{
                    Text("Speed:").foregroundColor(Color.white)
                    Text(character.speed).fontWeight(.bold).foregroundColor(Color.white)
                    Text("Level:").foregroundColor(Color.white)
                    Text(character.level).fontWeight(.bold)
                        .foregroundColor(self.character.levelUp ? Color.red : Color.white)
                        .onTapGesture(perform: { self.showingLevel.toggle() })
                        
                        .popover(isPresented: $showingLevel, content: {
                            NumberEditor(value: "0", modifiedValue: self.$character.model.level , isHP: false)
                        })
                    Text("XP:").foregroundColor(Color.white)
                    Text(character.experiencePoints).fontWeight(.bold).foregroundColor(Color.white)
                        .onTapGesture(perform: { self.showingXP.toggle() })

                        .popover(isPresented: $showingXP, content: {
                            NumberEditor(value: "0", modifiedValue: self.$character.model.experiencePoints , isHP: false)
                        })
                    Spacer()
                }
            }
        }
    }
}



struct MiscActionsView: View {
    
    @EnvironmentObject var character: Character
    @Binding var selectedAction:Action
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType
    @Binding var actionsShowing:Bool

    var body: some View {
        VStack {
            HStack{
                Button( action: {
                    withAnimation(.default,  { self.actionsShowing.toggle() } )
                }, label: { Image(self.actionsShowing ? "arrowDown" : "arrowLeft").resizable() })
                    .frame(width: 30, height: 30)
                Spacer()
                Text("Actions").fontWeight(.bold).foregroundColor(Color.white)
                Spacer()
                GrayButton(text:"+",width: 40) {
                    self.sheetType = .miscAction
                    self.selectedAction = Action()
                    self.detailShowing = true
                }
            }.frame(height: 45)
            if actionsShowing {
                if character.actions.count > 0 {
                    
                    VStack(alignment: .leading){
                        HStack {
                            Text("All:").font(Font.system(size: 20, weight: .bold))
                            MiscTypeView(actions: Array(character.miscActions), selectedAction: $selectedAction, detailShowing: $detailShowing, sheetType:$sheetType )
                        }
                        
                    }.padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                        .background(Color.black)
                }
            }
        }
    }
}


struct AttacksView: View {
    
    @EnvironmentObject var character: Character
    @Binding var selectedAttack:Action
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType
    @Binding var attacksShowing:Bool

    var body: some View {
    
        VStack {
            HStack{
                Button( action: {
                    withAnimation(.default,  { self.attacksShowing.toggle() } )
                }, label: { Image(self.attacksShowing ? "arrowDown" : "arrowLeft").resizable() })
                    .frame(width: 30, height: 30)
                Spacer()
                Text("Attacks").fontWeight(.bold).foregroundColor(Color.white)
                Spacer()
                GrayButton(text:"+",width: 40) {
                    self.sheetType = .attackAction
                    self.detailShowing = true
                }
            }.frame(height: 45)
            if character.weaponAttacks.count + character.otherAttacks.count > 0  && attacksShowing {
                
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


struct MiscTypeView: View {
    
    var actions:[Action]
    @Binding var selectedAction:Action
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType

    var body: some View {
        ScrollView(.horizontal) {
            HStack { ForEach(actions) { action in
                Text(action.name).onTapGesture {
                    self.selectedAction = action
                    self.detailShowing = true
                    self.sheetType = .miscAction
                }.font(Font.system(size: 18))
                    .padding(4)
                    .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct MagicItemsListView: View {
    
    var items:[MagicItem]
    @Binding var selectedItem:MagicItem
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(items) { item in
                    Text("\(item.name)").onTapGesture {
                        self.sheetType = .magicItem
                        self.selectedItem = item
                        self.detailShowing = true
                        
                    }.font(Font.system(size: 18))
                    .padding(4)
                    .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct AttackTypeView: View {
    
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


struct SpellsView: View {

    @EnvironmentObject var character: Character
    @Binding var selectedAction:Action
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType
    @Binding var spellShowing:Bool

    @State var selectedSpellLevels = Set<Int>()

    var levelNames = ["Cantrips","1st","2nd","3rd","4th","5th","6th","7th","8th","9th"]

    var body: some View {
        VStack {
            HStack{
                Button( action: {
                    withAnimation(.default,  { self.spellShowing.toggle() } )
                }, label: { Image(self.spellShowing ? "arrowDown" : "arrowLeft").resizable() })
                    .frame(width: 30, height: 30)
                
                Spacer()
                Text("Spells").fontWeight(.bold).foregroundColor(Color.white)
                Spacer()
                GrayButton(text:"+",width: 40) {
                    self.detailShowing = true
                    self.sheetType = .spellPicker
                }
            }.frame(height: 45)
            if self.spellShowing {
                HStack {
                    SpellsUsedGrid(selectedSpellLevels: $selectedSpellLevels, isActionPage: false)
                    Spacer()
                }
                
                if character.spells.count > 0 {
                    VStack(alignment: .leading) {
                        ForEach ( 0 ..< 10) { index in
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
}

struct SpellLevelView: View {

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


struct EquipmentView: View {

    @EnvironmentObject var character: Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType
    @Binding var itemsShowing:Bool


    var body: some View {
        VStack {
            HStack{
                Button( action: {
                    withAnimation(.default,  { self.itemsShowing.toggle() } )
                }, label: { Image(self.itemsShowing ? "arrowDown" : "arrowLeft").resizable() })
                    .frame(width: 30, height: 30)
                Spacer()
                Text("Items").fontWeight(.bold).foregroundColor(Color.white)
                Spacer()
                GrayButton(text:"+",width: 40) {
                    self.sheetType = .equipmentPicker
                    self.detailShowing = true
                }
            }.frame(height: 45)
            if itemsShowing {
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
}

struct MiscDetailsView: View {
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType
    @Binding var miscShowing:Bool
    
    var body: some View {
        VStack {
            HStack{
                Button( action: {
                    withAnimation(.default,  { self.miscShowing.toggle() } )
                }, label: { Image(self.miscShowing ? "arrowDown" : "arrowLeft").resizable() })
                    .frame(width: 30, height: 30)
                Spacer()
                Text("Misc").fontWeight(.bold).foregroundColor(Color.white)
                Spacer()
                GrayButton(text:"+",width: 40) {
                    self.sheetType = .miscEditor
                    self.detailShowing = true
                }
            }.frame(height: 45)
            if miscShowing {
                VStack {
                    ProficiencieView(selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType: $sheetType)
                    SkillsView(selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType: $sheetType)
                    TraitsView(selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType: $sheetType)
                    LanguagesView(selectedDetail: $selectedDetail, detailShowing: $detailShowing, sheetType: $sheetType)
                }
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2)).foregroundColor(Color.white)
                .background(Color.black)
            }
            
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

struct LanguagesView: View {
    
    @EnvironmentObject var character: Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    @Binding var sheetType:DescriptionView.SheetType

    var body: some View {
        HStack {
            Text("Languages:").font(Font.system(size: 20, weight: .bold))
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(character.languages)) { language in
                        DetailTextView(thing: language, selectedDetail: self.$selectedDetail , detailShowing: self.$detailShowing, sheetType:self.$sheetType)
                    }
                }
            }
        }
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView().environmentObject(Character.shared)
    }
}
