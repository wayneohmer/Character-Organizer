//
//  TraitView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct TraitView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var trait:Trait
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Close").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
                
            }
            Text(trait.name).fontWeight(.bold).foregroundColor(Color.white).padding(5)
            Text(trait.desc.joined(separator: "\n\n")).fontWeight(.bold).foregroundColor(Color.white).padding(5)
            Spacer()
        }.background(Color.black)
    }
}
