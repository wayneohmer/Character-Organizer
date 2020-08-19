//
//  SelectView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 6/4/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct SelectView: View {
    
    @EnvironmentObject var characterSet:CharacterSet
    
    var body: some View {
        VStack{
            HStack{
                GrayButton(text: "Fetch", width: 100) {
                    Character.fetchFromCloud()
                }.padding()
                Spacer()
                
            }
            HStack {
                
                VStack {
                    
                    ForEach (characterSet.allCharacters.sorted(), id:\.self ) { model in
                        HStack {
                            Text("\(model.name)").onTapGesture {
                                self.characterSet.allCharacters.update(with:Character.shared.model)
                                Character.shared.model = model
                            }
                            .padding(4)
                            .font(Font.system(size: 25, weight: .bold, design: .default))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Character.shared.model == model ? Color.white : Color.black, lineWidth: 2))
                            
                            Button(action: {
                                var thisModel = model
                                thisModel.isActive.toggle()
                                self.characterSet.allCharacters.update(with:thisModel)
                                
                            }, label: { Text ("\(model.isActive ? "Active" : "Inactive")") })
                            Button(action: {
                                self.characterSet.allCharacters.remove(model)
                            }, label: { Text (" - ") })
                            Button(action: {
                                model.saveToCloud()
                            }, label: { Text("Cloud") })
                            Spacer()
                        }
                    }.padding(4)
                    Text("------------")
                    ForEach (characterSet.cloudCharacters.sorted(), id:\.self ) { model in
                        HStack {
                            Text("\(model.name)").onTapGesture {
                                self.characterSet.allCharacters.update(with:Character.shared.model)
                                Character.shared.model = model
                            }
                            .padding(4)
                            .font(Font.system(size: 25, weight: .bold, design: .default))
                            
                            Button(action: {
                                var thisModel = model
                                thisModel.isActive = true
                                self.characterSet.allCharacters.update(with:thisModel)
                                
                            }, label: { Text ("Activate") })
                            Spacer()

                            
                        }
                    }.padding(4)
                    Spacer()
                }
                Spacer()
            }
        }
        .background(Color.black)
        .foregroundColor(.white)
        
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
    }
}
