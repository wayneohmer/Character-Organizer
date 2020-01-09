//
//  CharacterClassView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//
import SwiftUI

struct ClassView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var character = Character.shared
    @State var selectedClass:CharacterClass = CharacterClass.sharedClasses[0]
    var classes = CharacterClass.sharedClasses
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    Character.shared.charcaterClass = self.selectedClass
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Save").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
            }.background(Color.black)
            HStack {
                VStack {
                    ForEach(CharacterClass.sharedClasses) { thisClass in
                        ClassRow(thisClass: thisClass, isSelected: thisClass == self.selectedClass) .onTapGesture {
                            self.selectedClass = thisClass
                        }
                    }
                    Spacer()
                }
                ScrollView {
                    VStack {
                        DescText(text: "Hit Die: \(selectedClass.hitDie)")
                        ProficiencyOptionsView(profObject: self.selectedClass)
                        StartingProficiencyView(selectedClass: selectedClass)
                        DescText(text: "Saving Throws", alingment: .center)
                        ForEach(selectedClass.savingThrows ?? [Descriptor](), id: \.name) { descriptor in
                            DescText(text: descriptor.name, width: 370)
                        }
                        
                        
                    }
                }
            }.background(Color.black)
        }
    }
}

struct StartingProficiencyView: View {
    
    @State var showProficiencyOptions = true
    @State var selectedClass:CharacterClass
    
    var body: some View {
        VStack {
            DescText(text: "Starting Proficiencies", alingment: .center).onTapGesture {
                self.showProficiencyOptions.toggle()
            }
            if self.showProficiencyOptions {
                ForEach(selectedClass.proficiencies ?? [Descriptor](), id: \.name) { descriptor in
                    DescText(text: descriptor.name, width: 370)
                }
            }
        }
        
    }
}


struct ProficiencyOptionsView: View  {

    @State var selectedSkill = Skill()
    @State var showProficiencyOptions = true
    @State var profShowing = false

    var profObject:CharacterClass

    var body: some View {
        VStack {
            DescText(text: "Starting Proficiencies Options", alingment: .center).onTapGesture {
                self.showProficiencyOptions.toggle()
            }
            if self.showProficiencyOptions {
                DescText(text: "Choose \(profObject.proficiencyChoices.choose ?? 0)", alingment: .center)
                ForEach(profObject.proficiencyChoices.proficiencies, id:\.name ) { proficiency in
                    DescText(text: proficiency.name, width: 370).onTapGesture {
                        if let skill = proficiency.skill {
                            self.selectedSkill = skill
                            self.profShowing = true
                        }
                    }
                }.sheet(isPresented: self.$profShowing, content:  { DetailView(detail: self.selectedSkill as Viewable ) })
            }
        }
    }
}


struct ClassRow: View {
    
    var thisClass: CharacterClass
    var isSelected = false
    
    var body: some View {
        VStack {
            if isSelected {
                
                Text("\(self.thisClass.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .foregroundColor(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 4))
                    .font(Font.system(size: 25, weight: .bold, design: .default)).padding(4)
                
            } else  {
                Text("\(self.thisClass.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 25, weight: .bold, design: .default)).padding(4)
                
            }
        }
    }
}

