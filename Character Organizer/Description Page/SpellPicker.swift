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
    @State var selectedClass = "Bard"
    @State var selectedSpells:Set<Spell> = Set<Spell>()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
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
            HStack {
                ForEach(classes, id:\.self ) { cls in
                    Text(cls).onTapGesture {
                        self.selectedClass = cls
                    }
                    .padding(8)
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: self.selectedClass == cls ? 2 :0 )).foregroundColor(Color.white)
                }
            }.background(Color.white.opacity(0.1))
            HStack {
                ForEach(levels, id:\.self ){ index in
                    Text("\(index)").onTapGesture {
                        self.selectedLevel = index
                    }
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                        
                    .frame(width: 40, height: 40, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: self.selectedLevel == index ? 2 :0 )).foregroundColor(Color.white)
                }.padding(6)
            }.background(Color.white.opacity(0.1))
            GeometryReader { proxy in
                
                HStack {
                    VStack {
                        Text("Selected").font(Font.system(size: 25, weight: .bold, design: .default))
                            .padding(4)

                            VStack(alignment: .leading) {
                                ForEach(Array(self.selectedSpells).sorted()) { spell in
                                    HStack {
                                        GrayButton(text: "-", width: 40, color: .red){
                                            self.selectedSpells.remove(spell)
                                        }
                                        Text("\(spell.name) (\(spell.level))")
                                            .font(Font.system(size: 20, weight: .bold, design: .default))
                                            .onTapGesture {
                                                self.selectedSpell = spell
                                                self.detailShowing = true
                                        }
                                        .padding(5)
                                        Spacer()
                                    }
                                    .frame(width:(proxy.size.width/2)-16)
                                    .background(Color.white.opacity(0.1))
                                    .padding(4)
                                }
                        }.offset(x: 0, y: 16)
                        Spacer()
                       
                    }.frame(width:proxy.size.width/2)
                    
                    VStack {
                        Text("Spells").font(Font.system(size: 25, weight: .bold, design: .default))
                            .padding(4)
                        ScrollView(.vertical) {
                            VStack(alignment: .leading) {
                                ForEach(Spell.shared.values.filter({
                                    $0.level == self.selectedLevel && $0.hasClass(Set([self.selectedClass]))
                                }).sorted(), id:\.self) { spell in
                                    HStack {
                                        GrayButton(text: "+", width: 40) {
                                            self.selectedSpells.insert(spell)
                                        }
                                        Text(spell.name)
                                            .font(Font.system(size: 20, weight: .bold, design: .default))
                                            .onTapGesture {
                                                self.selectedSpell = spell
                                                self.detailShowing = true
                                        }
                                        .padding(5)
                                        Spacer()
                                    }
                                    .frame(width:(proxy.size.width/2)-16)
                                    .background(Color.white.opacity(0.1))
                                    .padding(4)
                                }
                            }
                            Spacer()
                        }
                    }.frame(width:proxy.size.width/2)

                    Spacer()
                }
            }
        }.sheet(isPresented: $detailShowing, content: { DetailView(detail: self.selectedSpell as Viewable) } )
            .foregroundColor(Color.white)
            .background(Color.black)
            .onAppear(){
                self.selectedClass = self.character.charcaterClass.name
                
        }
    }
}

struct SpellPicker_Previews: PreviewProvider {
    static var previews: some View {
        SpellPicker().environmentObject(Character.shared)
    }
}
