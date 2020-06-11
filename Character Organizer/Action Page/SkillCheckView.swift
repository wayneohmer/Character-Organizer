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
    @ObservedObject var character = Character.shared
    @State var rollShowing = false
    
    var diceDetails = DiceDetails()

    var body: some View {
        VStack{
            HStack {
                Spacer()
                VStack {
                    ForEach(skills) { skill in
                        Button(action: {
                            self.skillTouched(title: skill.name, mod: self.bonusFor(skill: skill))
                            self.rollShowing = true
                        }, label: {
                            Text("\(skill.name) - \(Character.AttributeDict[skill.ability_score?.name ?? ""] ?? "") \(self.bonusFor(skill:skill))")
                                .font(Font.system(size: 20, weight: .bold, design: .default))
                                .foregroundColor(self.nameColor(skill: skill))
                                .padding(10)
                                .frame(width: 500)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(.lightGray), .black]), startPoint: .top, endPoint: .bottom))
                                .offset(x: 0, y: -3)
                                .cornerRadius(8)
                                .padding(5)
                        })
                        
                    }
                    Spacer()
                }
                .sheet(isPresented: self.$rollShowing, content: { ModalDiceView (details: self.diceDetails, dice: self.diceDetails.dice)})
                .offset(x: 50, y: 0)
                VStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    } ) {
                        Text("Close").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                    }.frame(width: 100, height: 50, alignment: .center)
                    Spacer()
                }.offset(x: 50, y: 0)
                Spacer()
            }.padding()
            
        }
        .foregroundColor(Color.white)
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
    }
    
    func bonusFor(skill:Skill) -> Int {
        var attrbonus = 0
        if let attribute = Attribute(rawValue: skill.ability_score?.name ?? "") {
            attrbonus = self.character.attrBonusDict[attribute] ?? 0
        }
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
