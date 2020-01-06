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
    @State var character = Character.shared
    @State var selectedRace:Race = Race.sharedRaces[0]
    
    let background = Color(red: 0.15, green: 0.15, blue: 0.15)

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    Character.shared.race = self.selectedRace
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Save").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
            }.background(Color.black)
            HStack {
                VStack {
                    ForEach(Race.sharedRaces) { race in
                        RaceRow(race: race, isSelected: race == self.selectedRace).onTapGesture {
                            self.selectedRace = race
                        }
                    }
                    Spacer()
                }
                ScrollView {
                    VStack {
                        DescText(text: "Speed: \(selectedRace.speed)")
                        DescText(text: "Size: \(selectedRace.size)")
                        DescText(text: "\(selectedRace.sizeDescription)", fontSize: 20)
                        DescText(text: "Ability Bonuses", alingment: .center)
                        ForEach(selectedRace.abilityBonuses ?? [Ability](), id: \.name) { bonus in
                            DescText(text: "\(bonus.name): +\(bonus.bonus)", width: 370)
                        }
                        if selectedRace.startingProficiencies?.count ?? 0 > 0 {
                            DescText(text: "Starting Proficiencies", alingment: .center)
                            
                            ForEach(selectedRace.startingProficiencies ?? [Descriptor](), id: \.name) { descriptor in
                                DescText(text: descriptor.name, width: 370)
                            }
                        }
                        if selectedRace.startingProficiencies != nil && (selectedRace.startingChooseableOption?.choose ?? 0) > 0 {
                            DescText(text: "Starting Proficiencies Options", alingment: .center)
                            DescText(text: "Choose \(selectedRace.startingChooseableOption?.choose ?? 0)", alingment: .center)
                            ForEach(selectedRace.startingChooseableOption?.from ?? [Descriptor](), id: \.name) { descriptor in
                                DescText(text: descriptor.name, width: 370)
                            }
                        }
                        VStack {
                            Languages(race: selectedRace)
                            if selectedRace.traits?.count ?? 0 > 0 {
                                Traits(race: selectedRace)
                            }
                        }
                        DescText(text: "Age: \(selectedRace.age)", fontSize: 20)
                        
                        Spacer()
                    }
                }
                
            }
        }.background(Color.black)
    }
}

struct Traits: View {
    
    var race:Race
    @State var traitShowing = false
    @State var selectedTrait = Trait()

    var body: some View {
        VStack {
            DescText(text: "Traits", alingment: .center)
            ForEach(race.traits ?? [Descriptor](), id: \.name) { descriptor in
                DescText(text: descriptor.name, width: 370).onTapGesture {
                    self.selectedTrait = Trait.sharedTraits[descriptor.url] ?? Trait()
                    self.traitShowing = true
                }
            }
        }.sheet(isPresented: self.$traitShowing, content:  { TraitView(trait: self.selectedTrait) })
    }
    
}

struct Languages: View {
    
    var race:Race
    
    var body: some View {
        VStack {
            DescText(text: "Languages", alingment: .center)
            
            ForEach(race.languages ?? [Descriptor](), id: \.name) { descriptor in
                DescText(text: descriptor.name, width: 370)
            }
            if race.languageOptions != nil && (race.languageOptions?.choose ?? 0) > 0 {
                DescText(text: "Language Options", alingment: .center)
                DescText(text: "Choose \(race.languageOptions?.choose ?? 0)", alingment: .center)
                ForEach(race.languageOptions?.from ?? [Descriptor](), id: \.name) { descriptor in
                    DescText(text: descriptor.name, width: 370)
                }
            }
        }
    }
}

struct DescText: View {
    
    var text = ""
    var width = CGFloat(400)
    var alingment:Alignment = .leading
    var fontSize = CGFloat(25)
    let background = Color(red: 0.15, green: 0.15, blue: 0.15)
    

    var body: some View {
        Text(text).frame(width: width, alignment: alingment)
        .padding(4)
        .foregroundColor(Color.white)
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
                
                Text("\(self.race.isSubrace ? "   " : "")\(self.race.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .foregroundColor(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 4))
                    .font(Font.system(size: 25, weight: .bold, design: .default)).padding(4)
                
            } else  {
                Text("\(self.race.isSubrace ? "   " : "")\(self.race.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 25, weight: .bold, design: .default)).padding(4)
                
            }
        }
    }
    
}


struct RaceView_Previews: PreviewProvider {
    static var previews: some View {
        RaceView()
    }
}
