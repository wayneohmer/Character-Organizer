//
//  RaceView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct RaceView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var character = Character.shared
    @State var selectedRace:Race = Race.shared[0]
    
    @State var showProficiencyOptions = true
    @State var showProficiencies = true
    @State var selectedProfs = Set<Proficiency>()
    @State var profShowing = false
    @State var selectedSkill = Skill()

    let background = Color(red: 0.15, green: 0.15, blue: 0.15)

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
                    Character.shared.race = self.selectedRace
                    Character.shared.model.raceModel = self.selectedRace.model
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Save").font(Font.system(size: 30, weight: .bold, design: .default)).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
            }.background(Color.black)
            HStack {
                VStack {
                    ForEach(Race.shared) { race in
                        RaceRow(race: race, isSelected: race == self.selectedRace).onTapGesture {
                            self.selectedRace = race
                        }
                    }
                    Spacer()
                }
                ScrollView {
                    VStack {
                        
                        HeadingView(text: "Ability Bonuses")
                        ForEach(selectedRace.abilityBonuses ?? [Ability](), id: \.name) { bonus in
                            DescText(text: "\(bonus.name): +\(bonus.bonus)", offset: CGSize(width: 15, height: 0))
                        }
                        if selectedRace.startingProficiencies?.count ?? 0 > 0 {
                            HeadingView(text: "Starting Proficiencies")
                            
                            ForEach(selectedRace.startingProficiencies ?? [Descriptor](), id: \.name) { descriptor in
                                DescText(text: descriptor.name)
                            }
                        }
                        if selectedRace.startingProficiencies != nil && (selectedRace.proficiencyChoices.choose ?? 0) > 0 {
                            proficiencyOptionsView()
                            
                        }
                        VStack {
                            Languages(race: selectedRace)
                            if selectedRace.traits?.count ?? 0 > 0 {
                                Traits(race: selectedRace)
                            }
                            HeadingView(text: "Fluff")

                        }
                        DescText(text: "Speed: \(selectedRace.speed)")
                        DescText(text: "Size: \(selectedRace.size)")
                        DescText(text: "\(selectedRace.sizeDescription)", fontSize: 20)
                        DescText(text: "Age: \(selectedRace.age)", fontSize: 20)
                        
                        Spacer()
                    }
                }
                
            }
        }.background(Color.black)
    }
    
    func proficiencyOptionsView() -> some View {
    
    let background = Color(red: 0.15, green: 0.15, blue: 0.15)
    var choose:Int { return self.selectedRace.proficiencyChoices.choose ?? 0 }
    var chooseColor:Color { return self.selectedRace.selectedProficiencies.count == choose ? .white : .red }

    var imageName: String  { return showProficiencyOptions ? "arrowDown" : "arrowLeft" }
    return VStack {
            HStack{
                HeadingView(text: "Starting Proficiencies Options", imageName: imageName)

                    .onTapGesture {
                        self.showProficiencyOptions.toggle()
                    }
                }.background(background)
            if self.showProficiencyOptions {
                DescText(text: "Choose \(self.selectedRace.proficiencyChoices.choose ?? 0)",
                    alingment: .center, forgroundcolor: chooseColor)
                ForEach(self.selectedRace.proficiencyChoices.proficiencies, id:\.name ) { proficiency in
                    HStack{
                        if self.selectedProfs.contains(proficiency) {
                            DescText(text: proficiency.name, offset: CGSize(width: 15, height: 0)).onTapGesture {
                                self.selectedRace.selectedProficiencies.remove(proficiency)
                                self.selectedProfs.remove(proficiency)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                        } else {
                            DescText(text: proficiency.name, offset: CGSize(width: 15, height: 0)).onTapGesture {
                                if self.selectedRace.selectedProficiencies.count == choose {
                                    self.selectedProfs.removeFirst()
                                    self.selectedRace.selectedProficiencies.removeFirst()
                                }
                                self.selectedRace.selectedProficiencies.insert(proficiency)
                                self.selectedProfs.insert(proficiency)
                            }
                        }
                    }
                }.sheet(isPresented: self.$profShowing, content:  { DetailView(detail: self.selectedSkill as Viewable ) })
            }
        }
    }
}

struct Traits: View {
    
    var race:Race
    @State var traitShowing = false
    @State var selectedTrait = Trait()

    var body: some View {
        VStack {
            HeadingView(text: "Traits")
            ForEach(race.traits ?? [Descriptor](), id: \.name) { descriptor in
                DescText(text: descriptor.name, offset: CGSize(width: 15, height: 0)).onTapGesture {
                    self.selectedTrait = Trait.shared[descriptor.url] ?? Trait()
                    self.traitShowing = true
                }
            }
        }.sheet(isPresented: self.$traitShowing, content:  { DetailView(detail: self.selectedTrait as Viewable ) })
    }
    
}

struct Languages: View {
    
    var race:Race
    @State var selectedLanguages = Set<Descriptor>()
    var choose:Int { return race.languageOptions?.choose ?? 0 }
    var chooseColor:Color { return selectedLanguages.count == choose ? .white : .red }
    
    var body: some View {
        VStack {
            HeadingView(text: "Languages")

            ForEach(race.languages ?? [Descriptor](), id: \.name) { descriptor in
                DescText(text: descriptor.name,offset: CGSize(width: 15, height: 0))
            }
            if race.languageOptions != nil && (race.languageOptions?.choose ?? 0) > 0 {
                HeadingView(text: "Language Options")
                DescText(text: "Choose \(choose)", alingment: .center, forgroundcolor:self.chooseColor)

                ForEach(race.languageOptions?.from ?? [Descriptor]()) { descriptor in
                    if self.selectedLanguages.contains(descriptor) {
                        DescText(text: descriptor.name, offset: CGSize(width: 15, height: 0) ).onTapGesture {
                            self.selectedLanguages.remove(descriptor)
                            self.race.selectedLanguages.remove(descriptor)
                        }
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                    } else {
                        DescText(text: descriptor.name, offset: CGSize(width: 15, height: 0)).onTapGesture {
                            if self.selectedLanguages.count == self.choose {
                                self.selectedLanguages.removeFirst()
                                self.race.selectedLanguages.removeFirst()
                            }
                            self.selectedLanguages.insert(descriptor)
                            self.race.selectedLanguages.insert(descriptor)
                        }
                    }
                }
            }
        }
    }
}

struct HeadingView: View {
    
    let background = Color(red: 0.25, green: 0.25, blue: 0.25)
    
    var text = ""
    var imageName:String?
    
    var body: some View {
        HStack {
            Text(text).frame(alignment: .center)
                .padding(5)
                .foregroundColor(Color.white)
                .font(Font.system(size: 30, weight: .bold, design: .default))
            self.imageView()
           
            }.frame(width:500).background(background)
    }
    
    func imageView() -> AnyView {
        if let imageName = self.imageName {
            return  AnyView(Image(imageName).resizable().frame(width: 40, height: 40, alignment: .center))
        } else {
            return AnyView(EmptyView())
        }
    }
    
}


struct DescText: View {
    
    var text = ""

    var alingment:Alignment = .leading
    var width = CGFloat(500)
    var fontSize = CGFloat(25)
    var offset = CGSize(width: 0, height: 0)
    var forgroundcolor = Color.white
    let background = Color(red: 0.15, green: 0.15, blue: 0.15)

    var body: some View {
        Text(text).frame(width: width, alignment: alingment)
        .offset(offset)
        .padding(5)
        .foregroundColor(forgroundcolor)
        .background(background)
        .font(Font.system(size: fontSize, weight: .bold, design: .default))
        .padding(2)

    }
}

struct RaceRow: View {
    
    var race:Race
    var isSelected = false
    
    var body: some View {
        VStack {
            if isSelected {
                
                Text(self.race.isSubrace ? "   \(self.race.name.replacingOccurrences(of: race.model.name, with: ""))" : self.race.name )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .foregroundColor(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 4))
                    .font(Font.system(size: 20, weight: .bold, design: .default)).padding(4)
                
            } else  {
                Text(self.race.isSubrace ? "   \(self.race.name.replacingOccurrences(of: race.model.name, with: ""))" : self.race.name )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 20, weight: .bold, design: .default)).padding(4)
                
            }
        }
    }
    
}


struct RaceView_Previews: PreviewProvider {
    static var previews: some View {
        RaceView()
    }
}
