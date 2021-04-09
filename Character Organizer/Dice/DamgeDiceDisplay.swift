//
//  DamgeDiceDisplay.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 4/8/21.
//  Copyright © 2021 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct DamgeDiceDisplay: View {
    
    @State var damage: [FyreDiceModel]
    @State var pickerItems:[String] = ["Full","Full","Full","Full","Full","Full","Full"]
    @State var selected = "Full"
    @State var pickerText = ["Full","Half","Double","None"]
    
    var body: some View {
        VStack{
            ForEach (0 ..< damage.count) { idx in
                HStack {
                    Spacer()
                    Picker("Alignment", selection: $pickerItems[idx]) {
                        ForEach (pickerText, id:\.self) { text in
                            Text(text)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 250)
                    .background(Color(.lightGray))
                    .cornerRadius(8)
                    Text(damage[idx].display)
                        .frame(width: 75)

                    Text(damage[idx].damageType ?? "" )
                        .frame(width: 100, alignment: .leading)

                    Spacer()
                }
                
            }
        }
        .foregroundColor(.white)
        .background(Color(.black))
    }
}

struct DamgeDiceDisplay_Previews: PreviewProvider {
        
    static var previews: some View {
        DamgeDiceDisplay(damage:
        [FyreDiceModel(id: UUID(), dice: [10: 1], modifier: 2, damageType: "Slashing"),
         FyreDiceModel(id: UUID(), dice: [6: 2], modifier: 2, damageType: "Fire"),
        FyreDiceModel(id: UUID(), dice: [8: 2], modifier: 2, damageType: "Radient")])
    }
}
