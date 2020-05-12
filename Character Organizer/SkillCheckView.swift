//
//  SkillsView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 5/12/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct SkillCheckView: View {
    
    @Environment(\.presentationMode) var presentationMode

    let skills = Skill.shared.map({$1}).sorted(by: {  $0.name < $1.name })
    @ObservedObject var character = ObCharacer().character
    @State var rollShowing = false
    
    var diceDetails = DiceDetails()


    var body: some View {
        VStack{
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Close").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
            }
            VStack {
                ForEach(skills) { skill in
                    Text("\(skill.name) - \(skill.ability_score?.name ?? "") \(self.bonusFor(skill:skill))")
                        .font(Font.system(size: 25, weight: .bold, design: .default))
                        .padding(8)
                        .foregroundColor(self.nameColor(skill: skill))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture {
                            self.skillTouched(title: skill.name, mod: self.bonusFor(skill: skill))
                            self.rollShowing = true
                    }
                    .sheet(isPresented: self.$rollShowing, content: {DiceView(details: self.diceDetails, dice: self.diceDetails.dice)})
                }
                Spacer()
            }.padding()
            Spacer()
        }
        .foregroundColor(Color.white)
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
    }
    
    func bonusFor(skill:Skill) -> Int {
        let attrbonus = self.character.bonusDict[skill.ability_score?.name ?? ""] ?? 0
        let profbonus = self.character.skills.contains(skill) ? self.character.model.proficiencyBonus : 0
        return attrbonus + profbonus
    }
    
    func nameColor(skill:Skill) -> Color {
        return self.character.skills.contains(skill) ? Color(.green) : Color(.white)
    }
    
    func skillTouched(title:String, mod:Int) {
        //self.showingDice = true
        self.diceDetails.title = title
        self.diceDetails.isSave = false
        self.diceDetails.dice = FyreDice(with: [20:1], modifier: mod)
    }
}

struct SkillCheckView_Previews: PreviewProvider {
    static var previews: some View {
        SkillCheckView()
    }
}
