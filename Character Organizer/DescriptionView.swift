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
    @State var detailShowing = false
    @State var equipmentShowing = false

    var body: some View {
        VStack {
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
                        Text(character.languageString).fontWeight(.bold).foregroundColor(Color.white)
                        Spacer()
                    }.offset(CGSize(width: 8, height: 0))
                }
            }
            HStack {
                ProficiencieView(character: $character, selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                SkillsView(character: $character, selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                TraitsView(character: $character, selectedDetail: $selectedDetail, detailShowing: $detailShowing)
                .sheet(isPresented: self.$detailShowing, content:  { DetailView(detail: self.selectedDetail ) })
                Spacer()
            }.padding(8)
            HStack{
                
                EquipmentView(character: $character, selectedDetail: $selectedDetail, detailShowing: $detailShowing, equipmentShowing: $equipmentShowing)
                Spacer()
                
            }.sheet(isPresented: self.$equipmentShowing, content:  { EquipmentPicker(character: self.$character) })
           
            Spacer()
        }.background(background)
        .onAppear(){
            //forces redraw
            self.detailShowing = true
            self.detailShowing = false
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
            }
            ScrollView {
                VStack(alignment: .leading){
                    if character.weapons.count > 0 {
                        Text("Weapons:").font(Font.system(size: 25, weight: .bold))
                        ScrollView(.horizontal) {
                            HStack{ ForEach(character.weapons) { equipment in
                                Text(equipment.name).onTapGesture {
                                    self.selectedDetail = equipment
                                    self.detailShowing = true
                                }.font(Font.system(size: 20))
                                }
                            }.padding(3)
                        }
                    }
                    if character.armor.count > 0 {

                    Text("Armor:").font(Font.system(size: 25, weight: .bold))
                    ScrollView(.horizontal) {
                        HStack{
                            ForEach(character.armor) { equipment in
                                Text(equipment.name).padding(3).onTapGesture {
                                    self.selectedDetail = equipment
                                    self.detailShowing = true
                                }
                            }
                        }
                    }
                    }
                    Text("Other Shit:").font(Font.system(size: 25, weight: .bold))
                    ScrollView(.horizontal) {
                        HStack{
                            ForEach(Array(character.equipment.filter({
                                $0.equipment_category != "Armor" &&  $0.equipment_category != "Weapon"
                            })) ) { equipment in
                                Text(equipment.name).padding(3).onTapGesture {
                                    self.selectedDetail = equipment
                                    self.detailShowing = true
                                }
                            }
                        }
                    }
                }.padding(8)
            }.frame(height: 250, alignment: .leading)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
            .background(Color.black)
            
            }.foregroundColor(Color.white)
    }
}

struct ProficiencieView:  View {
    
    @Binding var character:Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    
    var body: some View {
        
        VStack {
            Text("Proficiencies:").fontWeight(.bold).foregroundColor(Color.white)
            ScrollView {
                ForEach(Array(character.proficiencies) ) { proficiency in
                    Text(proficiency.name).foregroundColor(Color.white).padding(3).onTapGesture {
                        self.selectedDetail = proficiency
                        self.detailShowing = true
                    }
                }
            }.frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .background(Color.black)
            
        }
    }
}

struct SkillsView:  View {
    
    @Binding var character:Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    
    var body: some View {
        VStack {
            Text("Skills:").fontWeight(.bold).foregroundColor(Color.white)
            ScrollView {
                ForEach(Array(character.skills) ) { skill in
                    Text(skill.name).foregroundColor(Color.white).padding(3)
                        .onTapGesture {
                            self.selectedDetail = skill
                            self.detailShowing = true
                    }
                }
            }.frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .background(Color.black)
        }
    }
}

struct TraitsView:  View {
    
    @Binding var character:Character
    @Binding var selectedDetail:Viewable
    @Binding var detailShowing:Bool
    
    var body: some View {
        VStack {
            Text("Traits:").fontWeight(.bold).foregroundColor(Color.white)
            ScrollView {
                ForEach(Array(character.traits)) { trait in
                    Text(trait.name).foregroundColor(Color.white).padding(3)
                        .onTapGesture {
                            self.selectedDetail = trait
                            self.detailShowing = true
                    }
                }
            }.frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .background(Color.black)
            
        }
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView()
    }
}
