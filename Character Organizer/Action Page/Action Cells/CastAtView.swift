//
//  CastAtView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 7/19/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct CastAtView: View {
    
    @EnvironmentObject var character: Character
    @Environment(\.presentationMode) var presentationMode

    @Binding var castTouched:Bool
    
    @State var level:Int
    @State var minlevel = 1
    var maxlevel = 9

    var body: some View {
        HStack {
            
            Text("Cast at level:").font(Font.system(size: 20, weight: .bold, design: .default))
                .padding(8)
                .offset(x: 8, y: 0)
            Text("\(self.level)")
                .frame(width: 40, height:40)
                .background(Color.white)
                .foregroundColor(Color.black)
                .shadow(radius: 2)
                .cornerRadius(8)
            GrayButton(text: " + ", width: 50, action: { self.level += 1 })
                .disabled(level == maxlevel)
            GrayButton(text: " - ", width: 50, action: { self.level -= 1 })
                .disabled(level == minlevel)
            Spacer()
            GrayButton(text: " Cast ", width: 75, action: {
                self.character.model.spellSlotsUsed[self.level]! += 1
                self.presentationMode.wrappedValue.dismiss()
                self.castTouched = true
            }
            )
                .padding()
            
        }
        .frame(width: 450, height:80)
        .foregroundColor(Color.white)
        .background(Color(.black))
        
        .onAppear() {
            self.minlevel = self.level
        }
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(.white), lineWidth: 4))
        
    }
}

struct CastAtView_Previews: PreviewProvider {
    static var previews: some View {
        CastAtView(castTouched: .constant(false), level : 3)
    }
}
