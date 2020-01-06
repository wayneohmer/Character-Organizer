//
//  ClassView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//
import SwiftUI

struct ClassView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var character = Character.shared
    @State var selectedClass:Class = Class.sharedClasses[0]

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
                    ForEach(Class.sharedClasses, id:\.name) { thisClass in
                        ClassRow(thisClass: thisClass, isSelected: thisClass == self.selectedClass).onTapGesture {
                            self.selectedClass = thisClass
                        }
                    }
                    Spacer()
                }
                ScrollView {
                    VStack {
                        DescText(text: "Hit Die: \(selectedClass.hitDie)")
                        if selectedClass.proficiencyChoices != nil && (selectedClass.proficiencyChoices?.choose ?? 0) > 0 {
                            DescText(text: "Starting Proficiencies Options", alingment: .center)
                            DescText(text: "Choose \(selectedClass.proficiencyChoices?.choose ?? 0)", alingment: .center)
                            ForEach(selectedClass.proficiencyChoices?.from ?? [Descriptor](), id: \.name) { descriptor in
                                DescText(text: descriptor.name, width: 370)
                            }
                        }
                        DescText(text: "Starting Proficiencies", alingment: .center)
                        ForEach(selectedClass.proficiencies ?? [Descriptor](), id: \.name) { descriptor in
                            DescText(text: descriptor.name, width: 370)
                        }
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

struct ClassRow: View {
    
    var thisClass:Class
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

