//
//  CreateView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct CreateView: View {
    
    @State var character = Character.shared

    @State var raceShowing = false
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)

    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextField("Name",text: $character.name).font(Font.system(size: 25, weight: .bold, design: .default))
                    .frame(width: 300, height:45)
                    .multilineTextAlignment(.center)
                    .background(Color.black)
                    .foregroundColor(Color.white)
                Spacer()
            }
            HStack{
                Button(action: { self.raceShowing = true }, label: { formatedText("Race", width: 200) })
                    .sheet(isPresented: $raceShowing, content:  { RaceView() })
                formatedText(character.race.name, width: 200, align: .leading)
                Spacer()
            }
            Spacer()

        }.background(background)
    }
}

func formatedText(_ text:String, width: CGFloat, height: CGFloat = 45, align:Alignment = .center ) -> some View {
    
    return Text(text).font(Font.system(size: 25, weight: .bold, design: .default))
        .frame(width: width, height: height, alignment: align)
        .background(Color.black)
        .foregroundColor(Color.white)
}


struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
