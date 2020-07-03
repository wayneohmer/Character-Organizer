//
//  CreateView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct CreateView: View {
    
    @ObservedObject var character = Character.shared
    
    @State var raceShowing = false
    @State var classShowing = false
    @State var statsShowing = false
    @State var alignment1Idx = 1
    @State var alignment2Idx = 1
    @State var oldname = ""
    
    var background = Color(red: 0.15, green: 0.15, blue: 0.15)
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    let new = Character.create()
                    self.character.model = new.model
                    self.oldname = new.name
                    
                }, label: { Text("+")
                    .font(Font.system(size: 25, weight: .bold, design: .default))
                    .frame(width: 45, height:45)

                    .background(Color.black)
                    .foregroundColor(Color.white)
                } )
                Spacer()
                TextField("Name",text: $character.name).font(Font.system(size: 25, weight: .bold, design: .default))
                    .frame(width: 300, height:45)
                    .multilineTextAlignment(.center)
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                    .offset(x: -22, y: 0)
                    .padding()
                    .onTextEditCommit(perform: {
                        let newName = self.character.name
                        self.character.name = self.oldname
                        CharacterSet.shared.allCharacters.remove(self.character.model)
                        self.character.name = newName
                        CharacterSet.shared.allCharacters.update(with:self.character.model)
                    })
                Spacer()
            }
            HStack{
                Button(action: { self.raceShowing = true }, label: { formatedText("Race", width: 200) })
                    .sheet(isPresented: $raceShowing, content:  { RaceView() })
                formatedText(character.race.name, width: 200)
                
                Spacer()
            }
            HStack {
                Button(action: { self.classShowing = true }, label: { formatedText("Class", width: 200) })
                    .sheet(isPresented: $classShowing, content:  { ClassView() })
                formatedText(character.charcaterClass.name, width: 200)
                Spacer()
            }
            HStack {
                Button(action: { self.statsShowing = true }, label: { formatedText("Stats", width: 200) })
                    .sheet(isPresented: $statsShowing, content:  { StatCreationView() })
                VStack{
                    HStack {
                        formatedText("Str:\(character.str) \(character.strMod)", width: 170).padding(3)
                        formatedText("Dex:\(character.dex) \(character.dexMod)", width: 170).padding(3)
                        formatedText("Con:\(character.con) \(character.conMod)", width: 170).padding(3)
                     }
                    HStack {
                        formatedText("Wis:\(character.int) \(character.intMod)", width: 170).padding(3)
                        formatedText("Int:\(character.wis) \(character.wisMod)", width: 170).padding(3)
                        formatedText("Cha:\(character.cha) \(character.chaMod)", width: 170).padding(3)
                    }
                }

                Spacer()
            }
            HStack {
                formatedText("Alignment", width: 200)
                VStack {
                    Picker("Alignment", selection: $character.model.alingment1Idx) {
                        ForEach(0 ..< Character.aligment1.count) { index in
                            Text(Character.aligment1[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color(.lightGray))
                    .cornerRadius(8)
                    Picker("Alignment", selection: $character.model.alingment2Idx) {
                        ForEach(0 ..< Character.aligment2.count) { index in
                            Text(Character.aligment2[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color(.lightGray))
                    .cornerRadius(8)
                    
                }
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
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
}


struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
