//
//  DetailView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 1/5/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI


struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var detail:Viewable
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Text("Close").fontWeight(.bold).foregroundColor(Color.white).padding(5).offset(y:-2)
                }.frame(width: 100, height: 50, alignment: .center)
                
            }
            Text(detail.name).fontWeight(.bold).foregroundColor(Color.white).padding(5)
            HStack {
                Text(detail.description).fontWeight(.bold).foregroundColor(Color.white).padding(8)
                Spacer()
            }
            Spacer()
        }.background(Color.black)
    }
}

protocol Viewable {
    
    var name:String { get }
    var description:String { get }
}

