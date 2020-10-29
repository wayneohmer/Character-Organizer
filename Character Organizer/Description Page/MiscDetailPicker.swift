//
//  SpellPicker.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 2/16/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct MiscDetailPicker: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var character: Character

    var details:[String] = ["Proficiencies","Skills","Traits","Languages"]
    @State var selectedLevel = 0
    @State var detailShowing = false
    @State var selectedPrificiency = Proficiency()
    @State var selectedSkill = Skill()
    @State var selectedTrait = Trait()
    @State var selectedLanguage = Descriptor()
    @State var selectedDetail = "Proficiencies"
    @State var selectedProficiencies = Set<Proficiency>()
    @State var selectedSkills = Set<Skill>()
    @State var selectedTraits = Set<Trait>()
    @State var selectedLanguages = Set<Descriptor>()

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Spacer()
                Button(action: {
                    Character.shared.model.proficiencies = Set(Character.shared.proficiencies).union(self.selectedProficiencies)
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Close").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
            }
            HStack {
                ForEach(details, id:\.self ) { detail in
                    Text(detail).onTapGesture {
                        self.selectedDetail = detail
                    }
                    .padding(8)
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: self.selectedDetail == detail ? 2 :0 )).foregroundColor(Color.white)
                }
            }.background(Color.white.opacity(0.1))
            
            GeometryReader { proxy in
                
                HStack {
                    VStack {
                        Text("Selected").font(Font.system(size: 25, weight: .bold, design: .default))
                            .padding(4)
                        
                        VStack(alignment: .leading) {
                            if self.selectedDetail == "Proficiencies" {
                                self.selectedProfs(proxy: proxy)
                            } else if self.selectedDetail == "Skills" {
                                self.selectedSkills(proxy: proxy)
                            } else if self.selectedDetail == "Traits" {
                                self.selectedTraits(proxy: proxy)
                            }
                        }.offset(x: 0, y: 16)
                        Spacer()
                        
                    }.frame(width:proxy.size.width/2)
                    
                    VStack {
                        Text(self.selectedDetail).font(Font.system(size: 25, weight: .bold, design: .default))
                            .padding(4)
                        ScrollView(.vertical) {
                            VStack(alignment: .leading) {
                                if self.selectedDetail == "Proficiencies" {
                                    self.allProfs(proxy: proxy)
                                } else if self.selectedDetail == "Skills" {
                                    self.allSkills(proxy: proxy)
                                } else if self.selectedDetail == "Traits" {
                                    self.allTraits(proxy: proxy)
                                }
                            }
                            Spacer()
                        }
                    }.frame(width:proxy.size.width/2)
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $detailShowing, content: {
            if self.selectedDetail == "Proficiencies" {
                DetailView(detail: self.selectedPrificiency as Viewable)
            } else if self.selectedDetail == "Skills" {
                DetailView(detail: self.selectedSkill as Viewable)
            } else if self.selectedDetail == "Traits" {
                DetailView(detail: self.selectedTrait as Viewable)
            }
        }
            
        )
            .foregroundColor(Color.white)
            .background(Color.black)
    }
    func selectedTraits(proxy: GeometryProxy) -> some View {
        return ForEach(Array(self.selectedTraits).sorted()) { thing in
            HStack {
                GrayButton(text: "-", width: 40, color: .red){
                    self.selectedTraits.remove(thing)
                }
                Text("\(thing.name)")
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .onTapGesture {
                        self.selectedTrait = thing
                        self.detailShowing = true
                }
                .padding(5)
                Spacer()
            }
            .frame(width:(proxy.size.width/2)-16)
            .background(Color.white.opacity(0.1))
            .padding(4)
        }
    }
    
    func allTraits(proxy: GeometryProxy) -> some View {
        ForEach(Trait.shared.values.sorted(), id:\.self) { thing in
            HStack {
                GrayButton(text: "+", width: 40) {
                    self.selectedTraits.insert(thing)
                }
                Text(thing.name)
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .onTapGesture {
                        self.selectedTrait = thing
                        self.detailShowing = true
                }
                .padding(5)
                Spacer()
            }
            .frame(width:(proxy.size.width/2)-16)
            .background(Color.white.opacity(0.1))
            .padding(4)
        }
    }
    
    func selectedLanguages(proxy: GeometryProxy) -> some View {
        return ForEach(Array(self.selectedLanguages).sorted()) { thing in
            HStack {
                GrayButton(text: "-", width: 40, color: .red){
                    self.selectedLanguages.remove(thing)
                }
                Text("\(thing.name)")
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .onTapGesture {
                        self.selectedLanguage = thing
                        self.detailShowing = true
                }
                .padding(5)
                Spacer()
            }
            .frame(width:(proxy.size.width/2)-16)
            .background(Color.white.opacity(0.1))
            .padding(4)
        }
    }
    
//    func allLanguages (proxy: GeometryProxy) -> some View {
//        ForEach(.shared.values.sorted(), id:\.self) { thing in
//            HStack {
//                GrayButton(text: "+", width: 40) {
//                    self.selectedTraits.insert(thing)
//                }
//                Text(thing.name)
//                    .font(Font.system(size: 20, weight: .bold, design: .default))
//                    .onTapGesture {
//                        self.selectedTrait = thing
//                        self.detailShowing = true
//                }
//                .padding(5)
//                Spacer()
//            }
//            .frame(width:(proxy.size.width/2)-16)
//            .background(Color.white.opacity(0.1))
//        }
//    }
    
    func selectedSkills(proxy: GeometryProxy) -> some View {
        return ForEach(Array(self.selectedSkills).sorted()) { thing in
            HStack {
                GrayButton(text: "-", width: 40, color: .red){
                    self.selectedSkills.remove(thing)
                }
                Text("\(thing.name)")
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .onTapGesture {
                        self.selectedSkill = thing
                        self.detailShowing = true
                }
                .padding(5)
                Spacer()
            }
            .frame(width:(proxy.size.width/2)-16)
            .background(Color.white.opacity(0.1))
            .padding(4)
        }
    }
    
    func allSkills(proxy: GeometryProxy) -> some View {
        ForEach(Skill.shared.values.sorted(), id:\.self) { thing in
            HStack {
                GrayButton(text: "+", width: 40) {
                    self.selectedSkills.insert(thing)
                }
                Text(thing.name)
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .onTapGesture {
                        self.selectedSkill = thing
                        self.detailShowing = true
                }
                .padding(5)
                Spacer()
            }
            .frame(width:(proxy.size.width/2)-16)
            .background(Color.white.opacity(0.1))
            .padding(4)
        }
    }
    func selectedProfs(proxy: GeometryProxy) -> some View {
        return ForEach(Array(self.selectedProficiencies).sorted()) { thing in
            HStack {
                GrayButton(text: "-", width: 40, color: .red){
                    self.selectedProficiencies.remove(thing)
                }
                Text("\(thing.name)")
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .onTapGesture {
                        self.selectedPrificiency = thing
                        self.detailShowing = true
                }
                .padding(5)
                Spacer()
            }
            .frame(width:(proxy.size.width/2)-16)
            .background(Color.white.opacity(0.1))
            .padding(4)
        }
    }
    func allProfs(proxy: GeometryProxy) -> some View {
        ForEach(Proficiency.shared.values.sorted(), id:\.self) { prof in
            HStack {
                GrayButton(text: "+", width: 40) {
                    self.selectedProficiencies.insert(prof)
                }
                Text(prof.name)
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .onTapGesture {
                        self.selectedPrificiency = prof
                        self.detailShowing = true
                }
                .padding(5)
                Spacer()
            }
            .frame(width:(proxy.size.width/2)-16)
            .background(Color.white.opacity(0.1))
            .padding(4)
        }
    }
}

struct MiscDetailPicker_Previews: PreviewProvider {
    static var previews: some View {
        MiscDetailPicker().environmentObject(Character.shared)
    }
}
