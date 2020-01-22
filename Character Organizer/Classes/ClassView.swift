//
//  CharacterClassView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//
import SwiftUI

struct ClassView: View {
    
    @State var showProficiencyOptions = true
    @State var showProficiencies = true

    @State var profShowing = false
    @State var selectedSkill = Skill()
    @State var selectedProfs = Set<Proficiency>()

    @Environment(\.presentationMode) var presentationMode
    @State var character = Character.shared
    @State var selectedClass:CharacterClass = CharacterClass.shared[0]
    var classes = CharacterClass.shared
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(Font.system(size: 30, weight: .bold, design: .default)).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 150, height: 70, alignment: .center)
                Spacer()
                Button(action: {
                    Character.shared.charcaterClass = self.selectedClass
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Save")
                        .font(Font.system(size: 30, weight: .bold, design: .default)).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 150, height: 70, alignment: .center)
                
            }.background(Color.black)
            HStack {
                VStack {
                    ForEach(CharacterClass.shared) { thisClass in
                        ClassRow(thisClass: thisClass, isSelected: thisClass == self.selectedClass).onTapGesture {
                            self.selectedClass = thisClass
                            self.selectedProfs.removeAll()
                        }
                    }
                    Spacer()
                }
                ScrollView {
                    VStack {
                        DescText(text: "Hit Die: \(selectedClass.hitDie)")
                        self.proficiencyOptionsView()
                        startingProficiencyView()
                        HeadingView(text: "Saving Throws")
                        ForEach(selectedClass.savingThrows ?? [Descriptor](), id: \.name) { descriptor in
                            DescText(text: descriptor.name, offset: CGSize(width: 15, height: 0))
                        }
                        
                        
                    }
                }
            }.background(Color.black)
        }
    }
    
    func startingProficiencyView() -> some View {
        
        var imageName: String  { return self.showProficiencies ? "arrowDown" : "arrowLeft" }
        let background = Color(red: 0.15, green: 0.15, blue: 0.15)
        
        return VStack {
            HStack{
                HeadingView(text: "Starting Proficiencies", imageName: imageName)
                
            }.background(background)
                .onTapGesture {
                    self.showProficiencies.toggle()
            }
            
            if self.showProficiencies {
                ForEach(selectedClass.proficiencies, id: \.name) { descriptor in
                    DescText(text: descriptor.name, offset: CGSize(width: 15, height: 0))
                }
            }
        }
        
    }
    
    func proficiencyOptionsView() -> some View {
        
        let background = Color(red: 0.15, green: 0.15, blue: 0.15)
        var choose:Int { return self.selectedClass.proficiencyChoices.choose ?? 0 }
        var chooseColor:Color { return self.selectedClass.selectedProficiencies.count == choose ? .white : .red }

        var imageName: String  { return showProficiencyOptions ? "arrowDown" : "arrowLeft" }
        return VStack {
                HStack{
                    HeadingView(text: "Starting Proficiencies Options", imageName: imageName)

                        .onTapGesture {
                            self.showProficiencyOptions.toggle()
                        }
                    }.background(background)
                if self.showProficiencyOptions {
                    DescText(text: "Choose \(self.selectedClass.proficiencyChoices.choose ?? 0)",
                        alingment: .center, forgroundcolor: chooseColor)
                    ForEach(self.selectedClass.proficiencyChoices.proficiencies, id:\.name ) { proficiency in
                        HStack{
                            if self.selectedProfs.contains(proficiency) {
                                DescText(text: proficiency.name, offset: CGSize(width: 15, height: 0)).onTapGesture {
                                    self.selectedClass.selectedProficiencies.remove(proficiency)
                                    self.selectedProfs.remove(proficiency)
                                }
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                            } else {
                                DescText(text: proficiency.name, offset: CGSize(width: 15, height: 0)).onTapGesture {
                                    if self.selectedClass.selectedProficiencies.count == choose {
                                        self.selectedProfs.removeFirst()
                                        self.selectedClass.selectedProficiencies.removeFirst()
                                    }
                                    self.selectedClass.selectedProficiencies.insert(proficiency)
                                    self.selectedProfs.insert(proficiency)
                                }
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

struct ClassView_Previews: PreviewProvider {
    static var previews: some View {
        ClassView()
    }
}
