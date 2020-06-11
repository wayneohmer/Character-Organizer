//
//  SpellPicker.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 2/16/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct SpellPicker: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var character: Character

    var levels:[Int] = [0,1,2,3,4,5,6,7,8,9]
    var classes:[String] = ["Bard","Cleric","Druid","Paladin","Ranger","Sorcerer","Warlock","Wizard"]
    @State var selectedLevel = 0
    @State var detailShowing = false
    @State var selectedSpell = Spell()
    @State var selectedClass:Set<String> = Set(["Bard"])
    @State var selectedSpells:Set<Spell> = Set<Spell>()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    let newSpells = Set(Character.shared.spells).union(self.selectedSpells)
                    Character.shared.model.spells = Array(newSpells)
                    for spell in self.selectedSpells {
                        Character.shared.addSpellAction(spell)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Close").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
            }
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
                            Spacer()
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
                        ForEach(Spell.shared.values.filter({
                            $0.level == selectedLevel && $0.hasClass(self.selectedClass)
                        }).sorted(), id:\.self) { spell in
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
            }
        }.sheet(isPresented: $detailShowing, content: { DetailView(detail: self.selectedSpell as Viewable) } )
        .foregroundColor(Color.white)
        .background(Color.black)
    }
}

struct SpellPicker_Previews: PreviewProvider {
    static var previews: some View {
        SpellPicker()
    }
}
