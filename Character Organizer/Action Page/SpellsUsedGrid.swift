//
//  SpellsUsedGrid.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 7/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct SpellsUsedGrid: View {
    
    @EnvironmentObject var character: Character
    
    @Binding var selectedSpellLevels:Set<Int>
    
    @State var showingEditor = false
    @State var slotsIdx = Int(0)
    @State var usedIdx = Int(0)
    @State var data = Int(0)
    var isActionPage = true

    var body: some View {
        HStack {
            HStack {
                VStack {
                    if isActionPage {
                        Text("Level:").frame(width: 90, height: 25, alignment: .leading).cornerRadius(5)
                        Text("Remaining:").frame(width: 90, height: 35, alignment: .leading).cornerRadius(5)
                        
                    } else {
                        Text("Level:").frame(width: 60, height: 25, alignment: .leading).cornerRadius(5)
                        Text("Slots:").frame(width: 60, height: 35, alignment: .leading).cornerRadius(5)
                        Text("Used:").frame(width: 60, height: 35, alignment: .leading).cornerRadius(5)
                    }
                }
                ForEach ( 1..<10 ) { idx in
                    VStack(spacing: 3) {
                        Text("\(idx)").frame(width: 35, height: 25, alignment: .center).cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: self.selectedSpellLevels.contains(idx) ? 2 :0 ))
                            .onTapGesture {
                                if self.selectedSpellLevels.contains(idx) {
                                    self.selectedSpellLevels.remove(idx)
                                } else {
                                    self.selectedSpellLevels.insert(idx)
                                }
                        }
                        if self.isActionPage {
                            Text("\(self.character.model.spellSlots[idx]! - self.character.model.spellSlotsUsed[idx]!)").frame(width: 35, height: 35, alignment: .center)
                                .background(Color(.white)).foregroundColor(.black).cornerRadius(5).shadow(color: .black, radius: 3, x: 2, y: 2)
                        } else {
                            Text("\(self.character.model.spellSlots[idx]!)").frame(width: 35, height: 35, alignment: .center)
                                .background(Color(.white)).foregroundColor(.black).cornerRadius(5).shadow(color: .black, radius: 3, x: 2, y: 2).onTapGesture {
                                    self.data = self.character.model.spellSlots[idx]  ?? 0
                                    self.showingEditor = true
                                    self.usedIdx = 0
                                    self.slotsIdx = idx
                            }
                            Text("\(self.character.model.spellSlotsUsed[idx]!)").frame(width: 35, height: 35, alignment: .center)
                                .background(Color(.white)).foregroundColor(.black).cornerRadius(5).shadow(color: .black, radius: 3, x: 2, y: 2).onTapGesture {
                                    self.data = self.character.model.spellSlotsUsed[idx] ?? 0
                                    self.showingEditor = true
                                    self.usedIdx = idx
                                    self.slotsIdx = 0
                            }
                        }
                    }
                }.popover(isPresented: $showingEditor, arrowEdge: .trailing, content: {
                    if self.slotsIdx > 0 {
                        NumberEditor(value: "0", modifiedValue: self.$data, isHP: false).onDisappear (perform: {
                            self.character.model.spellSlots[self.slotsIdx] = self.data
                        })
                    } else {
                        NumberEditor(value: "0", modifiedValue: self.$data, isHP: false).onDisappear (perform: {
                            self.character.model.spellSlotsUsed[self.usedIdx] = self.data
                        })
                    }
                }
                )
            }
            .cornerRadius(5)
            .background(isActionPage ?  Color.clear : Color.black)
            .foregroundColor(isActionPage ? .black : .white)
            .padding(4)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(isActionPage ? Color.black : Color.white, lineWidth: 2))
            Spacer()
        }
    }
}

struct SpellsUsedGrid_Previews: PreviewProvider {
    static var previews: some View {
        SpellsUsedGrid(selectedSpellLevels: .constant(Set<Int>()))
    }
}
