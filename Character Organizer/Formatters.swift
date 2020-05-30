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
                Text("\(text)").fontWeight(.bold).padding(3).frame(alignment: .center).offset(y:-2)
            }
            .frame(width: width, height: height)
            .foregroundColor(Color.white)
            .background(LinearGradient(gradient: Gradient(colors: [color, .black]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(5)
            
        }
    }
}
    
