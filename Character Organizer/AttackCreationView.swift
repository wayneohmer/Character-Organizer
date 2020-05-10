//
//  AttackCreationView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 3/22/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct AttackCreationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var character:Character
   
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)

    @Binding var action: Action
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextField("Name",text: self.$action.name).font(Font.system(size: 20, weight: .bold, design: .default))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(background, lineWidth: 4))
                .multilineTextAlignment(.center)
                .background(Color.white)
                .foregroundColor(Color.black)
                Spacer()
            }
            Spacer()
            
        }.foregroundColor(Color.white)
            .background(Color.black)
    }
}

struct AttackCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AttackCreationView(character: .constant(Character.shared), action: .constant(Action(name: "", desc: "")) )
    }
}
