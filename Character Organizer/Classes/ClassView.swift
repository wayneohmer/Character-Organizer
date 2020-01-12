//
//  CharacterClassView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//
import SwiftUI

struct ClassView: View {
    
    @State var showProficiencyOptions = true
    @State var profShowing = false
    @State var selectedSkill = Skill()
    @State var selectedProfs = Set<Proficiency>()

    @Environment(\.presentationMode) var presentationMode
    @State var character = Character.shared
    @State var selectedClass:CharacterClass = CharacterClass.sharedClasses[0]
    var classes = CharacterClass.sharedClasses
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    Character.shared.charcaterClass = self.selectedClass
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Save").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
            }.background(Color.black)
            HStack {
                VStack {
                    ForEach(CharacterClass.sharedClasses) { thisClass in
                        ClassRow(thisClass: thisClass, isSelected: thisClass == self.selectedClass) .onTapGesture {
                            self.selectedClass = thisClass
                            self.selectedProfs.removeAll()
                        }
                    }
                    Spacer()
                }
                ScrollView {
                    VStack {
                        DescText(text: "Hit Die: \(selectedClass.hitDie)")
                        self.proficiencyOptionsView()
                        StartingProficiencyView(selectedClass: selectedClass)
                        DescText(text: "Saving Throws", alingment: .center)
                        ForEach(selectedClass.savingThrows ?? [Descriptor](), id: \.name) { descriptor in
                            DescText(text: descriptor.name, width: 370)
                        }
                        
                        
                    }
                }
            }.background(Color.black)
        }
    }
    
    func proficiencyOptionsView() -> some View {
        
        let background = Color(red: 0.15, green: 0.15, blue: 0.15)
        var choose:Int { return self.selectedClass.proficiencyChoices.choose ?? 0 }
        var chooseColor:Color { return self.selectedClass.selectedProficiencies.count == choose ? .white : .red }

        var imageName: String  { return showProficiencyOptions ? "arrowDown" : "arrowLeft" }
        return VStack {
                HStack{
                    Text("Starting Proficiencies Options")
                            .frame(width: 360, height:50 ,alignment: .center)
                            .foregroundColor(chooseColor)
                            .font(Font.system(size: 25, weight: .bold, design: .default))

                        .onTapGesture {
                            self.showProficiencyOptions.toggle()
                        }
                        Image(imageName).resizable().frame(width: 40, height: 40
                            , alignment: .center)
                    }.background(background)
                if self.showProficiencyOptions {
                    DescText(text: "Choose \(self.selectedClass.proficiencyChoices.choose ?? 0)", alingment: .center)
                    ForEach(self.selectedClass.proficiencyChoices.proficiencies, id:\.name ) { proficiency in
                        HStack{
                            if self.selectedProfs.contains(proficiency) {
                                DescText(text: proficiency.name, width: 370).onTapGesture {
                                    self.selectedClass.selectedProficiencies.remove(proficiency)
                                    self.selectedProfs.remove(proficiency)
                                }
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                            } else {
                                DescText(text: proficiency.name, width: 370).onTapGesture {
                                    if self.selectedClass.selectedProficiencies.count == choose {
                                        self.selectedProfs.removeFirst()
                                        self.selectedClass.selectedProficiencies.removeFirst()
                                    }
                                    self.selectedClass.selectedProficiencies.insert(proficiency)
                                    self.selectedProfs.insert(proficiency)
                                }
                            }
                            Button(action: {
                                if let skill = proficiency.skill {
                                    self.selectedSkill = skill
                                    self.profShowing = true
                                }},
                                   label: { Text("  ?  " )})
                        }
                    }.sheet(isPresented: self.$profShowing, content:  { DetailView(detail: self.selectedSkill as Viewable ) })
                }
            }
        }
}

struct StartingProficiencyView: View {
    
    @State var selectedClass:CharacterClass
    @State var showProficiencyOptions = true
    var imageName: String  { return showProficiencyOptions ? "arrowDown" : "arrowLeft" }
    let background = Color(red: 0.15, green: 0.15, blue: 0.15)

    var body: some View {
        VStack {
            HStack{
                Text("Starting Proficiencies")
                    .frame(width: 360, height:50 ,alignment: .center)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 25, weight: .bold, design: .default))

                
                Image(imageName).resizable().frame(width: 40, height: 40
                    , alignment: .center)
            }.background(background)
            .onTapGesture {
                self.showProficiencyOptions.toggle()
            }

            if self.showProficiencyOptions {
                ForEach(selectedClass.proficiencies ?? [Descriptor](), id: \.name) { descriptor in
                    DescText(text: descriptor.name, width: 370)
                }
            }
        }
        
    }
}


//struct ProficiencyOptionsView: View  {
//
//    @State var selectedSkill = Skill()
//    @State var showProficiencyOptions = true
//
//    @State var selectedProfs = Set<Proficiency>()
//
//    let background = Color(red: 0.15, green: 0.15, blue: 0.15)
//    var choose:Int { return profObject.proficiencyChoices.choose ?? 0 }
//    var chooseColor:Color { return selectedProfs.count == choose ? .white : .red }
//
//
//    var imageName: String  { return showProficiencyOptions ? "arrowDown" : "arrowLeft" }
//
//    var profObject:HasProfOptions
//
//    var body: some View {
//        VStack {
//            HStack{
//                Text("Starting Proficiencies Options")
//                        .frame(width: 360, height:50 ,alignment: .center)
//                        .foregroundColor(chooseColor)
//                        .font(Font.system(size: 25, weight: .bold, design: .default))
//
//                    .onTapGesture {
//                        self.showProficiencyOptions.toggle()
//                    }
//                    Image(imageName).resizable().frame(width: 40, height: 40
//                        , alignment: .center)
//                }.background(background)
//            if self.showProficiencyOptions {
//                DescText(text: "Choose \(profObject.proficiencyChoices.choose ?? 0)", alingment: .center)
//                ForEach(profObject.proficiencyChoices.proficiencies, id:\.name ) { proficiency in
//                    HStack{
//                        if self.selectedProfs.contains(proficiency) {
//                            DescText(text: proficiency.name, width: 370).onTapGesture {
//                                self.selectedProfs.remove(proficiency)
//                            }
//                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
//                        } else {
//                            DescText(text: proficiency.name, width: 370).onTapGesture {
//                                if self.selectedProfs.count == self.choose {
//                                    self.selectedProfs.removeFirst()
//                                }
//                                self.selectedProfs.insert(proficiency)
//                            }
//                        }
//                        Button(action: {
//                            if let skill = proficiency.skill {
//                                self.selectedSkill = skill
//                                self.profShowing = true
//                            }},
//                               label: { Text("  ?  " )})
//                    }
//                }.sheet(isPresented: self.$profShowing, content:  { DetailView(detail: self.selectedSkill as Viewable ) })
//            }
//        }
//    }
//}


struct ClassRow: View {
    
    var thisClass: CharacterClass
    var isSelected = false
    
    var body: some View {
        VStack {
            if isSelected {
                
                Text("\(self.thisClass.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .foregroundColor(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 4))
                    .font(Font.system(size: 25, weight: .bold, design: .default)).padding(4)
                
            } else  {
                Text("\(self.thisClass.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 25, weight: .bold, design: .default)).padding(4)
                
            }
        }
    }
}

struct ClassView_Previews: PreviewProvider {
    static var previews: some View {
        ClassView()
    }
}
