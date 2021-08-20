//
//  DamgeDiceDisplay.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 4/8/21.
//  Copyright © 2021 Tryal by Fyre. All rights reserved.
//

import SwiftUI

enum DamageMultiplier: String, CaseIterable, Identifiable {
    case Full
    case Half
    case Double
    case None

    var id: String { self.rawValue }
        
    var multValue: Double {
        switch self {
        case .Full:
            return 1.0
        case .Half:
            return 0.5
        case .Double:
            return 2.0
        case .None:
            return 0.0
        }
    }
}


struct DamgeDiceDisplay: View {
    
    @Binding var damageDice: [FyreDice]
    @Binding var selectedDamageIdx: Int
    @Binding var selectedDice: FyreDice
    @State var pickerItems = [UUID: DamageMultiplier]()
    @State var isShowingTypePicker = false
    
    var body: some View {
        VStack {
            ForEach (damageDice, id:\.self) { die in
                HStack {
                    Spacer()
                    Picker("DamageMultiplier", selection:  {
                        ForEach (DamageMultiplier.allCases) { text in
                            Text(text.rawValue).tag(text)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 250)
                    .background(Color(.lightGray))
                    .cornerRadius(8)
                    
                    Text("\(die.display)").frame(width:175)
                    Text("\(Int(Double(die.rollValue) * pickerItems[die.id, default: .Full].multValue))")
                        .frame(width: 40)
                        .foregroundColor(.black)
                        .background(Color(.white))
                    Text(die.damageType ?? "" )
                        .frame(width: 100, alignment: .leading)
                        .onTapGesture {
                            self.selectedDice = die
                        }
                    Spacer()
                }
                .border(Color.white, width: selectedDice == die ? 2 : 0)
                .cornerRadius(5)
            }
            HStack() {
                
                Spacer()
                Text("").frame(width: 180)
                Text("\(self.diceTotal())").font(Font.system(size: 30, weight: .bold, design: .default))
                Spacer()
                GrayButton(text:" + ",width: 45) {
                    self.isShowingTypePicker = true
                }.popover(isPresented: $isShowingTypePicker, content: {
                    DamageTypePicker(damageDice: self.$damageDice)
                })
                
            }

            
        }
        .foregroundColor(.white)
        .background(Color(.black))
    }
    
    func diceTotal() -> Int {
        var total:Int = 0
        for die in damageDice {
            total += Int(Double(die.rollValue) * Double(self.pickerItems[die.id, default: .Full].multValue))
        }
        return total
    }
}

struct DamgeDiceDisplay_Previews: PreviewProvider {
        
    static var previews: some View {
        DamgeDiceDisplay(damageDice:.constant(
                            [FyreDice(with:FyreDiceModel(id: UUID(), dice: [10: 1], modifier: 2, damageType: "Slashing")),
                             FyreDice(with:FyreDiceModel(id: UUID(), dice: [6: 2], modifier: 2, damageType: "Fire")),
                             FyreDice(with:FyreDiceModel(id: UUID(), dice: [6: 2], modifier: 2, damageType: "Cold")),
                             FyreDice(with:FyreDiceModel(id: UUID(), dice: [8: 2], modifier: 2, damageType: "Radient"))]), selectedDamageIdx: .constant(0), selectedDice: .constant(FyreDice(with:FyreDiceModel(dice: [8: 2], modifier: 2))))
    }
}
