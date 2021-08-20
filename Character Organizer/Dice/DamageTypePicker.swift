//
//  DamageTypePicker.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 4/9/21.
//  Copyright © 2021 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct DamageTypePicker: View {
   
    @Environment(\.presentationMode) var presentationMode

    @State var damageTypes = DamageType.shared.map({$0.value.name}).sorted()

    @Binding var damageDice: [FyreDice]
    @State var damageTypeIndex: Int = 0

    var body: some View {
        VStack {
            GrayButton(text: "Save", width: 200, height: 100, action: {
                self.damageDice.append(FyreDice(with: FyreDiceModel(damageType:self.damageTypes[damageTypeIndex])))
                self.presentationMode.wrappedValue.dismiss()
            })
            
            Picker("", selection: $damageTypeIndex) {
                ForEach(0 ..< self.damageTypes.count) { idx in
                    Text(String(self.damageTypes[idx]))
                }
            }
            .pickerStyle(WheelPickerStyle())
            .background(Color(.lightGray))
            .frame(width: 250, height: 100)
            .cornerRadius(8)
        }
        .padding()
        .border(Color.black, width: 2)
    }
}

struct DamageTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        DamageTypePicker(damageDice:.constant(
                            [FyreDice(with:FyreDiceModel(id: UUID(), dice: [10: 1], modifier: 2, damageType: "Slashing")),
                             FyreDice(with:FyreDiceModel(id: UUID(), dice: [6: 2], modifier: 2, damageType: "Fire")),
                             FyreDice(with:FyreDiceModel(id: UUID(), dice: [6: 2], modifier: 2, damageType: "Cold")),
                             FyreDice(with:FyreDiceModel(id: UUID(), dice: [8: 2], modifier: 2, damageType: "Radiant"))]))
    }
}
