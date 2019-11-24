//
//  DiceView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 11/24/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct ToggleModel {
    var advantage = false {
        didSet {
            if advantage {
                disadvantage = false
            }
        }
    }
    var disadvantage = false {
        didSet {
            if disadvantage {
                advantage = false
            }
        }
    }
}

struct DiceView: View {
    
    @State var toggleModel = ToggleModel()
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("2d6(6)")
                        .padding(8)
                        .font(Font.system(size: 20, weight: .bold, design: .default))
                    Text("2d6(6)")
                        .padding(8)
                        .font(Font.system(size: 20, weight: .bold, design: .default))
                }.frame(width: 150)
                Text("20").padding(8)
                    .font(Font.system(size: 50, weight: .bold, design: .default)).frame(width: 150)
            }
            HStack {
                Toggle(isOn: $toggleModel.advantage) { Text ("ADV") }.padding(16).frame(width: 150)
                Toggle(isOn: $toggleModel.disadvantage) { Text ("DADV") }.padding(16).frame(width: 150)
            }
            Spacer()
        }
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView()
    }
}

