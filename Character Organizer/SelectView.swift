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
   
    @State var pairs:[(CharacterModel?,CharacterModel? )]
    @State var cloudPairs:[(CharacterModel?,CharacterModel? )]
    
    func getPairs() {
       
        let sortedModels = self.characterSet.allCharacters.sorted()
        var returnValue = [(CharacterModel?,CharacterModel?)]()
        
        for (idx, _) in sortedModels.enumerated() {
            if idx % 2 == 0  {
                if idx+1 < sortedModels.count {
                    returnValue.append((sortedModels[idx], sortedModels[idx+1]))
                } else {
                    returnValue.append((sortedModels[idx], nil))
                }
            }
        }
        self.pairs =  returnValue
    }
    
    func getCloudPairs() {
        let  sortedCloudModels = self.characterSet.cloudCharacters.sorted()

        var returnValue = [(CharacterModel?,CharacterModel?)]()
        for (idx, _) in sortedCloudModels.enumerated() {
            if idx % 2 == 0  {
                if idx+1 < sortedCloudModels.count {
                    returnValue.append((sortedCloudModels[idx], sortedCloudModels[idx+1]))
                } else {
                    returnValue.append((sortedCloudModels[idx], nil))
                }
            }
        }
        self.cloudPairs = returnValue
    }
    
    var body: some View  {
        GeometryReader { proxy in /// container size
            VStack{
                HStack{
                    GrayButton(text: "Fetch", width: 100) {
                        Character.fetchFromCloud() { self.update() }
                    }.padding()
                    Spacer()
                }
                HStack {
                    VStack {
                        if self.pairs.count > 0 {
                            ForEach ((0...self.pairs.count-1), id:\.self ) { idx in

                                HStack {
                                    self.characterCell(model: self.pairs[idx].0 ?? CharacterModel(), width: (proxy.size.width - 32.0)/2)
                                    Spacer()
                                    if self.pairs[idx].1 != nil {
                                        self.characterCell(model: self.pairs[idx].1 ?? CharacterModel(), width: (proxy.size.width - 32.0)/2)
                                    }
                                }.padding(4)
                            }.padding(4)
                        }
                        Text("----- Cloud -----")
                        if self.cloudPairs.count > 0 {
                            ForEach ((0...self.cloudPairs.count-1), id:\.self ) { idx in
                                HStack {
                                    self.characterCell(model: self.cloudPairs[idx].0 ?? CharacterModel(), isCloundCell: true, width: (proxy.size.width - 32.0)/2)
                                    Spacer()
                                    
                                    if self.cloudPairs[idx].1 != nil {
                                        self.characterCell(model: self.cloudPairs[idx].1 ?? CharacterModel(), isCloundCell: true, width: (proxy.size.width - 32.0)/2)
                                    }
                                }
                            }.padding(4)
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
        .padding(8)
        .background(Color.black)
        .foregroundColor(.white)
        .onAppear() {
            self.update()
        }
    }
    
    func update() {
        self.characterSet.allCharacters.update(with:Character.shared.model)
        self.getPairs()
        self.getCloudPairs()
    }
    
    func characterCell(model: CharacterModel, isCloundCell:Bool = false, width: CGFloat) -> some View {
        return HStack {
                Image(uiImage: UIImage(data:model.imageData ?? Data()) ?? UIImage(named: "Wayne") ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    
                    .onTapGesture {
                        if isCloundCell {
                            
                        } else {
                            self.characterSet.allCharacters.update(with:Character.shared.model)
                            Character.shared.model = model
                        }
                }
                VStack {
                    HStack {
                        Text("\(model.name)")
                        .padding(4)
                        .font(Font.system(size: 30, weight: .bold, design: .default))
                    }
                     HStack {
                        Text("\(model.raceModel?.name ?? "") \(model.characterClass?.name ?? "") (\(model.level))")
                        Spacer()
                    }.padding(4)
                    HStack {
                        if isCloundCell {
                            GrayButton(text: "Activate", width: 76) {
                                var thisModel = model
                                thisModel.isActive = true
                                self.characterSet.allCharacters.update(with:thisModel)
                                self.update()
                            }
                        } else {
                            VStack(spacing: 8) {
                                HStack{
                                     GrayButton(text: "\(model.isActive ? "Active" : "Inactive")",width: 75) {
                                        var thisModel = model
                                        thisModel.isActive.toggle()
                                        self.characterSet.allCharacters.update(with:thisModel)
                                        self.update()

                                    }
                                    GrayButton(text:"Delete", width: 75, color: .red) {
                                        self.characterSet.allCharacters.remove(model)
                                        self.update()

                                    }
                                    Spacer()
                                }
                                HStack{
                                    GrayButton(text: "Save To Cloud",width: 150) {
                                        if let saveModel = self.characterSet.allCharacters.first(where: {$0 == model}) {
                                            saveModel.saveToCloud()
                                            self.update()
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }.frame(width: width, height: 150)
            .padding(4)
            .cornerRadius(15)
            .background(Color.white.opacity(0.2))
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Character.shared.model == model ? Color.white : Color.clear, lineWidth: isCloundCell ? 0:2))
                
        }
    }



struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView(pairs: [(CharacterModel?,CharacterModel?)](), cloudPairs: [(CharacterModel?,CharacterModel?)]()).environmentObject(CharacterSet.shared)
    }
}
