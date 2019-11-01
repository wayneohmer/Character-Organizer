//
//  ContentView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 10/31/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @State private var character = Character.shared
    var lightGray = Color(.lightGray)
    
    var demographics: some View {
        HStack {
            Text("Name:").fontWeight(.bold)
            TextField("name", text: self.$character.name).offset(y:2)
                .offset(x: 3)
                .border(Color.black, width: 1)
            Text("Race:").fontWeight(.bold)
            TextField("race", text: self.$character.race).offset(y:2)
                .offset(x: 3)
                .border(Color.black, width: 1)
            Text("Level:").fontWeight(.bold)
            TextField("name", text: self.$character.level).multilineTextAlignment(.center)
                .frame(maxWidth: 55)
                .offset(y: 2)
                .border(Color.black, width: 1)
        }.padding(8)
    }
    
    var hitPoints: some View {
        VStack(spacing: 3){
            Text("Hit Points").fontWeight(.bold).frame(maxWidth: 100)
            TextField("0", text: self.$character.currentHP)
                .font(Font.system(size: 45, weight: .bold, design: .default))
                .frame(minHeight: 80)
                .border(Color.black, width: 2)
                .frame(maxWidth: 100)
                .multilineTextAlignment(.center)
            self.attributes
        }
    }
    
    var attributes: some View {
        
        VStack(spacing:3 ){
            
            HStack {
                Button(action: { self.attributeTouched() }) {
                    Text("STR:").fontWeight(.bold).padding(3).frame(width: 60)
                }.foregroundColor(Color.white)
                    .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(5)
                TextField("str", text: self.$character.str).multilineTextAlignment(.center)
                    .frame(maxWidth: 55.0)
                    .offset(y: 2)
                    .border(Color.black, width: 1)
            }.padding(3)
            HStack {
                Button(action: { self.attributeTouched() }) {
                    Text("DEX:").fontWeight(.bold).padding(3).frame(width: 60)
                }.foregroundColor(Color.white)
                .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(5)
                TextField("dex", text: self.$character.dex).multilineTextAlignment(.center)
                    .frame(maxWidth: 55.0)
                    .offset(y: 2)
                    .border(Color.black, width: 1)
            }.padding(3)
            HStack {
                Button(action: { self.attributeTouched() }) {
                    Text("CON:").fontWeight(.bold).padding(3).frame(width: 60)
                }.foregroundColor(Color.white)
                .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(5)
                TextField("con", text: self.$character.con).multilineTextAlignment(.center)
                    .frame(maxWidth: 55.0)
                    .offset(y: 2)
                    .border(Color.black, width: 1)
            }.padding(3)
            HStack {
                Button(action: { self.attributeTouched() }) {
                    Text("INT:").fontWeight(.bold).padding(3).frame(width: 60)
                }.foregroundColor(Color.white)
                .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(5)
                TextField("int", text: self.$character.int).multilineTextAlignment(.center)
                    .frame(maxWidth: 55.0)
                    .offset(y: 2)
                    .border(Color.black, width: 1)
            }.padding(3)
            HStack {
                Button(action: { self.attributeTouched() }) {
                    Text("WIS:").fontWeight(.bold).padding(3).frame(width: 60)
                }.foregroundColor(Color.white)
                .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(5)
                TextField("wis", text: self.$character.wis).multilineTextAlignment(.center)
                    .frame(maxWidth: 55.0)
                    .offset(y: 2)
                    .border(Color.black, width: 1)
            }.padding(3)
            HStack {
                Button(action: { self.attributeTouched() }) {
                    Text("CHA:").fontWeight(.bold).padding(3).frame(width: 60)
                }.foregroundColor(Color.white)
                .background(LinearGradient(gradient: Gradient(colors: [lightGray, .black]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(5)
                TextField("cha", text: self.$character.cha).multilineTextAlignment(.center)
                    .frame(maxWidth: 55.0)
                    .offset(y: 2)
                    .border(Color.black, width: 1)
            }.padding(3)
        }
    }
    
    var body: some View {
            TabView(selection: self.$selection){
                VStack {
                    self.demographics
                    HStack {
                        self.hitPoints
                        Spacer()
                    }
                    Spacer()
                }
                    
                .tabItem {
                    VStack {
                        Image("first")
                        Text("First")
                    }
                }
                .tag(0)
                
                
                Text("Second View")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image("second")
                            Text("Second")
                        }
                }
                .tag(1)
            }
        }
    
    func attributeTouched() {
        print("touched")
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
