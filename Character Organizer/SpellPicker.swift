//
//  SpellPicker.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 2/16/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct SpellPicker: View {
    
    var levels:[Int] = [1,2,3,4,5,6,7,8,9]
    var classes:[String] = ["Bard","Cleric","Druid","Paladin","Sorcerer","Warlock","Wizard"]
    @State var selectedLevel = 1
    @State var detailShowing = false
    @State var selectedSpell = Spell()
    @State var selectedClass:Set<String> = Set(["Bard"])
    @State var selectedSpells:Set<Spell> = Set<Spell>()
    
    var body: some View {
        HStack{
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(classes, id:\.self ) { cls in
                            Text(cls).onTapGesture {
                                if self.selectedClass.contains(cls) {
                                    self.selectedClass.remove(cls)
                                } else  {
                                    self.selectedClass.insert(cls)
                                }
                            }
                            .padding(5)
                            .font(Font.system(size: 20, weight: .bold, design: .default))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: self.selectedClass.contains(cls) ? 2 :0 )).foregroundColor(Color.white)
                        }.padding()
                    }
                    VStack {
                        ForEach(levels, id:\.self ){ index in
                            Text("\(index)").onTapGesture {
                                self.selectedLevel = index
                            }
                            .font(Font.system(size: 20, weight: .bold, design: .default))
                                
                            .frame(width: 40, height: 40, alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: self.selectedLevel == index ? 2 :0 )).foregroundColor(Color.white)
                        }.padding(6)
                    }
                    Spacer()
                }
                VStack {
                    Text("Selected").font(Font.system(size: 25, weight: .bold, design: .default))
                    VStack {
                        ForEach(Array(self.selectedSpells).sorted()) { spell in
                            HStack {
                                Button(action: {
                                    self.selectedSpells.remove(spell)
                                    
                                }, label: {
                                    Text(" - ").font(Font.system(size: 25, weight: .bold, design: .default))
                                })
                                Text("\(spell.name) (\(spell.level))")
                                    .font(Font.system(size: 20, weight: .bold, design: .default))
                                    .onTapGesture {
                                        self.selectedSpell = spell
                                        self.detailShowing = true
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(5)
                            }
                        }
                    }
                    Spacer()
                }
            }.frame(width: 250)
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(Spell.shared.filter({
                        $0.level == selectedLevel && $0.hasClass(self.selectedClass)
                    }).sorted()) { spell in
                        HStack {
                            Button(action: {
                                self.selectedSpells.insert(spell)
                                
                            }, label: {
                                Text(" + ").font(Font.system(size: 25, weight: .bold, design: .default))
                            })
                            Text(spell.name)
                                .font(Font.system(size: 20, weight: .bold, design: .default))
                                .onTapGesture {
                                    self.selectedSpell = spell
                                    self.detailShowing = true
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .padding(5)
                        }
                    }
                }
                Spacer()
            }.padding(5)
                
            Spacer()
        }.sheet(isPresented: $detailShowing, content: { SpellDetail(spell: self.selectedSpell) } )
        .foregroundColor(Color.white)
        .background(Color.black)
    }
}

struct SpellPicker_Previews: PreviewProvider {
    static var previews: some View {
        SpellPicker()
    }
}
