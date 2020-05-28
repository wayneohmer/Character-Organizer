//
//  StatCreationView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/8/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct StatDetail : Identifiable {
    
    var id:String { return label }
    var label:String
    var value:Int
    var fontSize:CGFloat
    var currentPosition = CGSize.zero
    var newPosition = CGSize.zero
    var idx: Int
}

struct StatCreationView: View {
    
    @State var character = Character.shared
    @Environment(\.presentationMode) var presentationMode

    @State var newPosition = CGSize.zero

    @State var details:[StatDetail] = [
        StatDetail(label: "Strength", value: 15, fontSize: 30, idx: 0),
        StatDetail(label: "Dexterity", value: 14, fontSize: 30, idx: 1),
        StatDetail(label: "Constitution", value: 13, fontSize: 30, idx: 2),
        StatDetail(label: "Intelligence", value: 12, fontSize: 30, idx: 3),
        StatDetail(label: "Wisdom", value: 10, fontSize: 30, idx: 4),
        StatDetail(label: "Charisma", value: 8, fontSize: 30, idx: 5)
    ]
    
    var mods:[Int] { return [self.character.race.abilityBonuses?.first(where:{ $0.name == "STR" })?.bonus ?? 0 ,
                             self.character.race.abilityBonuses?.first(where:{ $0.name == "DEX" })?.bonus ?? 0 ,
                             self.character.race.abilityBonuses?.first(where:{ $0.name == "CON" })?.bonus ?? 0 ,
                             self.character.race.abilityBonuses?.first(where:{ $0.name == "INT" })?.bonus ?? 0 ,
                             self.character.race.abilityBonuses?.first(where:{ $0.name == "WIS" })?.bonus ?? 0 ,
                             self.character.race.abilityBonuses?.first(where:{ $0.name == "CHA" })?.bonus ?? 0 ]
    }
    
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
                    Character.shared.str = "\(self.details[0].value + self.mods[0])"
                    Character.shared.dex = "\(self.details[1].value + self.mods[1])"
                    Character.shared.con = "\(self.details[2].value + self.mods[2])"
                    Character.shared.int = "\(self.details[3].value + self.mods[3])"
                    Character.shared.wis = "\(self.details[4].value + self.mods[4])"
                    Character.shared.cha = "\(self.details[5].value + self.mods[5])"
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Save")
                        .font(Font.system(size: 30, weight: .bold, design: .default)).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 150, height: 70, alignment: .center)
            }
            HStack {
                Button(action: {
                    var stats:[Int] = [0,0,0,0,0,0]
                    for idx in 0 ... 5 {
                        var roll = [Int]()
                        let die = FyreDice(with: [6:1], modifier: 0)
                        for _ in 0 ... 3 {
                            die.roll(silent: true)
                            roll.append(die.rollValue)
                        }
                        var answer = roll.sorted()
                        answer.removeFirst()
                        stats[idx] = answer.reduce(0, +)
                    }
                    stats.sort(by: { $0 > $1 })
                    for idx in 0 ... 5 {
                        self.details[idx].value = stats[idx]
                    }
                    
                }) {
                    Text("ROLL").font(Font.system(size: 30, weight: .bold, design: .default))
                        .foregroundColor(Color.white).padding(10).offset(y:-2)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                }.padding()
                Spacer()
            }
            ForEach(self.details) { detail in
                HStack {
                    Text(detail.label)
                        .font(Font.system(size: detail.fontSize, weight: .bold, design: .default))
                        .frame(width: 300, height: 30, alignment: .trailing)
                        .offset(x:-10)
                    .foregroundColor(Color.white)
                    HStack {
                        Text("\(detail.value)").frame(width: 60, height: 60, alignment: .center)
                            .frame(width: 60, height: 60, alignment: .center)
                            .font(Font.system(size: 25, weight: .bold, design: .default))
                            
                            .foregroundColor(Color.white)
                            .animation(.easeInOut(duration: 0.25))
                            .offset(x: self.details[detail.idx].currentPosition.width, y: self.details[detail.idx].currentPosition.height)
                            .gesture(DragGesture()
                                .onChanged { value in
                                    print("\(value.translation.height)")
                                    self.details[detail.idx].currentPosition = CGSize(width:0, height: value.translation.height + self.newPosition.height)
                                    let bigIdx = Int(value.translation.height/55) + detail.idx
                                    
                                    for det in self.details {
                                        if det.idx == bigIdx && det.idx != detail.idx {
                                            self.details[det.idx].fontSize = 40
                                        } else {
                                            self.details[det.idx].fontSize =  30
                                        }
                                    }
                            }
                                
                            .onEnded { value in
                                let bigIdx = Int(value.translation.height/55) + detail.idx
                                if bigIdx != detail.idx {
                                    let tmp = self.details[detail.idx].value
                                    self.details[detail.idx].value = self.details[bigIdx].value
                                    self.details[bigIdx].value = tmp
                                }
                                self.details[detail.idx].currentPosition = .zero
                                for det in self.details {
                                    self.details[det.idx].fontSize =  30
                                }
                                }
                            
                        )}.overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                    Text("\(detail.value + self.mods[detail.idx])").frame(width: 60, height: 60, alignment: .center)
                        .frame(width: 60, height: 60, alignment: .center)
                        .font(Font.system(size: 25, weight: .bold, design: .default))
                        
                        .foregroundColor(self.mods[detail.idx] == 0 ? Color.white : Color.yellow)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                    Text(self.character.modString(detail.value + self.mods[detail.idx])).frame(width: 60, height: 60, alignment: .center)
                        .frame(width: 40, height: 30, alignment: .center)
                        .font(Font.system(size: 20, weight: .bold, design: .default))
                        
                        .foregroundColor(Color.white)
                    Spacer()
                }
            }
            Spacer()
        }.background(Color.black)
    }
    
}

struct StatCreationView_Previews: PreviewProvider {
    static var previews: some View {
        StatCreationView()
    }
}
