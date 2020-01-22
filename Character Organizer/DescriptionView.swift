//
//  DescriptionView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/19/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import Foundation
import SwiftUI

struct DescriptionView: View {
    
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    @State var character = Character.shared
    @State var showingDice = false
    @State var selectedDetail:Viewable = Proficiency()
    @State var detailShowing = false
    
    var body: some View {
        VStack {
            HStack {
                Image("Wayne").resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height:90, alignment: .top)
                    .padding(3)
                VStack {
                    Text(character.name)
                        .font(Font.system(size: 30, weight: .bold, design: .default))
                        .foregroundColor(Color.white)
                    HStack {
                        Text("Race:").foregroundColor(Color.white)
                        Text(character.race.name).fontWeight(.bold).foregroundColor(Color.white)
                        Text("Class:").foregroundColor(Color.white)
                        Text(character.charcaterClass.name).fontWeight(.bold).foregroundColor(Color.white)
                        Text("Alignment:").foregroundColor(Color.white)
                        Text(character.alingment).fontWeight(.bold).foregroundColor(Color.white)
                        Spacer()
                    }.offset(CGSize(width: 8, height: 0))
                    HStack{
                        Text("Speed:").foregroundColor(Color.white)
                        Text(character.speed).fontWeight(.bold).foregroundColor(Color.white)
                        Text("Level:").foregroundColor(Color.white)
                        Text(character.level).fontWeight(.bold).foregroundColor(Color.white)
                        Spacer()
                    }.offset(CGSize(width: 8, height: 0))
                    HStack {
                        Text("Languages:").foregroundColor(Color.white)
                        Text(character.languageString).fontWeight(.bold).foregroundColor(Color.white)
                        Spacer()
                    }.offset(CGSize(width: 8, height: 0))
                }
            }
            HStack {
                VStack {
                    Text("Proficiencies:").fontWeight(.bold).foregroundColor(Color.white)
                    ScrollView {
                        ForEach(Array(character.proficiencies) ) { proficiency in
                            Text(proficiency.name).foregroundColor(Color.white).padding(3).onTapGesture {
                                    self.selectedDetail = proficiency
                                    self.detailShowing = true
                            }
                        }
                    }.frame(height: 150)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                        .background(Color.black)
                    
                }
                VStack {
                    Text("Skills:").fontWeight(.bold).foregroundColor(Color.white)
                    ScrollView {
                        ForEach(Array(character.skills) ) { skill in
                            Text(skill.name).foregroundColor(Color.white).padding(3)
                                .onTapGesture {
                                    self.selectedDetail = skill
                                    self.detailShowing = true
                            }
                        }
                    }.frame(height: 150)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                        .background(Color.black)
                    
                }
                VStack {
                    Text("Traits:").fontWeight(.bold).foregroundColor(Color.white)
                    ScrollView {
                        ForEach(Array(character.traits)) { trait in
                            Text(trait.name).foregroundColor(Color.white).padding(3)
                                .onTapGesture {
                                    self.selectedDetail = trait
                                    self.detailShowing = true
                            }
                        }
                    }.frame(height: 150)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                        .background(Color.black)
                    
                }
                .sheet(isPresented: self.$detailShowing, content:  { DetailView(detail: self.selectedDetail ) })
                Spacer()
            }.padding(8)
            Spacer()
        }.background(background)
        .onAppear(){
            //forces redraw
            self.detailShowing = true
            self.detailShowing = false
        }
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView()
    }
}
