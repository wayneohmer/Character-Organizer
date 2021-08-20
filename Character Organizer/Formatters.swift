//
//  Formatters.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 5/18/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI

struct GrayButton: View {
    var text: String
    var width: CGFloat
    var height: CGFloat = 40.0
    var color: Color = Color(.lightGray)
    var action:() -> Void
    var body: some View {
        HStack {
            Button(action: action) {
                Text("\(text)").fontWeight(.bold).padding(3)
                    .frame(width: width, height: height,alignment: .center).offset(y:-2)
            }
            
            .foregroundColor(Color.white)
            .background(LinearGradient(gradient: Gradient(colors: [color, .black]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(5)
            .shadow(color: .black, radius: 5, x: 0, y: 0)
        }
    }
}

struct BrownButton: View {
    var text: String
    var width: CGFloat
    var height: CGFloat = 40.0
    var color: Color = Color.init(red: 193/255, green: 175/255, blue: 124/255)
    var action:() -> Void
    var body: some View {
        HStack {
            Button(action: action) {
                Text("\(text)").fontWeight(.bold).padding(3).frame(alignment: .center).offset(y:-2)
            }
            .frame(width: width, height: height)
            .foregroundColor(Color.white)
            .background(LinearGradient(gradient: Gradient(colors: [color, Color.init(red: 74/255, green: 44/255, blue: 35/255)]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(5)
            .shadow(color: .black, radius: 5, x: 0, y: 0)
        }
    }
}

struct HeaderBarView: View {
    
    var name:String
    var saveAction: () -> Void
    var deleteAction: () -> Void
    
    @Environment(\.presentationMode) var presentationMode

    @State var showAlert = false
    var foreground = Color(red: 0.40, green: 0.40, blue: 0.40)

    var body: some View {
        
        HStack {
            GrayButton(text: "Detete", width: 100, color:Color(.red), action: {
                self.showAlert = true
            })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Are You Sure?"),
                          primaryButton: .destructive(Text("Die"), action: {
                            self.deleteAction()
                            self.presentationMode.wrappedValue.dismiss()
                          }),
                          secondaryButton: .cancel(Text("NO!")))
            }
            Spacer()
            Text(name).font(.title).foregroundColor(Color.white).padding(5)
            Spacer()
            GrayButton(text: "Save", width: 100, color:Color(.green), action:{
                self.presentationMode.wrappedValue.dismiss()
                self.saveAction()
            })
        }
        .padding(3)
        .background(LinearGradient(gradient: Gradient(colors: [foreground, .black]), startPoint: .top, endPoint: .bottom))
    }
}
    
