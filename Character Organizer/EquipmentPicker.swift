//
//  EquipmentPicker.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 2/4/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct EquipmentPicker: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var detailShowing = false
    @Binding var character:Character

    @State var selectedCatetory = "Armor"
    @State var selectedSubCatetory = "Heavy"
    @State var selectedEquipment:Viewable = Equipment()
    @State var stateEquipment = Character.shared.model.equipment


    let categories:[String] = {
        return Array(Set(Equipment.shared.values.map( { $0.equipment_category } ))).sorted()
    }()
    
    var subcategories:[String]  {
        return Array(Set(Equipment.shared.values.filter(
            { $0.equipment_category == self.selectedCatetory } ).map( { $0.subcategory } ))).sorted()
    }
    
    var equipment:[Equipment]  {
        return Equipment.shared.values.filter(
            { $0.equipment_category == self.selectedCatetory && $0.subcategory == self.selectedSubCatetory} ).sorted()
    }
    
    var body: some View {
        GeometryReader { metrics in
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    } ) {
                        Text("Close").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                    }.frame(width: 100, height: 50, alignment: .center)
                }
                HStack {
                    
                    VStack(alignment: .center) {
                        Text("Category").font(Font.system(size: 25, weight: .bold, design: .default))
                        VStack(alignment: .leading) {
                            
                            ForEach(self.categories, id:\.self) { category in
                                Text(category).onTapGesture {
                                    self.selectedCatetory = category
                                    self.selectedSubCatetory = self.subcategories[0]
                                }.frame(alignment:.leading).padding(5)
                                    .font(Font.system(size: 20, weight: .bold, design: .default))
                                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: self.selectedCatetory == category ? 4 : 0 ))
                            }
                        }.frame(width:metrics.size.width * 0.333)
                        Text("Current:").font(Font.system(size: 25, weight: .bold, design: .default))
                        VStack(alignment: .leading) {
                            ForEach(self.stateEquipment ) { equipment in
                                HStack {
                                    Button(action: {
                                        self.character.model.equipment.removeAll(where: {
                                            $0 == equipment
                                        })
                                        self.stateEquipment = self.character.model.equipment
                                    }, label: {
                                        Text(" - ").font(Font.system(size: 25, weight: .bold, design: .default))
                                    })
                                    Text(equipment.name).frame(alignment:.center).padding(5)
                                        .font(Font.system(size: 20, weight: .bold, design: .default))
                                }
                            }
                        }.frame(width:metrics.size.width * 0.333)
                        
                        Spacer()
                        
                    }
                    VStack(alignment: .center) {
                        Text("SubCategory").font(Font.system(size: 25, weight: .bold, design: .default))

                            VStack(alignment: .leading) {

                                ForEach(self.subcategories, id:\.self) { subcategory in
                                    Text(subcategory).onTapGesture {
                                        self.selectedSubCatetory = subcategory
                                    }.frame(alignment:.leading).padding(5)
                                        .font(Font.system(size: 20, weight: .bold, design: .default))
                                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: self.selectedSubCatetory == subcategory ? 4 : 0 ))
                                }
                            }.frame(width:metrics.size.width * 0.333)
                        Spacer()
                    }
                   
                    VStack(alignment: .center) {
                        Text("Choose:").font(Font.system(size: 25, weight: .bold, design: .default))
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(self.equipment ) { equipment in
                                    HStack {
                                        Button(action: {
                                            self.character.model.equipment.append(equipment)
                                            self.stateEquipment = self.character.model.equipment

                                        }, label: {
                                            Text(" + ").font(Font.system(size: 25, weight: .bold, design: .default))
                                        })
                                    Text(equipment.name).frame(alignment:.center).padding(5)
                                        .font(Font.system(size: 20, weight: .bold, design: .default))
                                    }.onTapGesture {
                                        self.selectedEquipment = equipment
                                        self.detailShowing = true
                                    }
                                    .sheet(isPresented: self.$detailShowing, content:  { DetailView(detail:  self.selectedEquipment ) })

                                }
                            }.frame(width:metrics.size.width * 0.333)
                        }
                    }
                    Spacer()
                }
            }.background(Color(.black)).foregroundColor(Color(.white))
        }
    }
}

struct EquipmentPicker_Previews: PreviewProvider {

    static var previews: some View {
       EquipmentPicker(character: .constant(Character.shared))
    }
}

