//
//  DetailView.swift
//  myRecipes
//
//  Created by David Kipnis on 5/2/23.
//

import Foundation
import SwiftUI

struct DetailView: View {
    
    @Binding var recipe: DetailedRecipe
    
    let width: CGFloat = UIScreen.main.bounds.width
    let height: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        
        if recipe.id == -1 {
            Text("Loading")
        } else {
            
            VStack(spacing: 0) {
                
                HStack {
                    Text(recipe.name)
                        .frame(width: width, height: height / 20)
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding([.bottom], UIScreen.main.bounds.height / 40)
                        .underline()
                }.background(Color.blue)

                
                ScrollView {
                    
                    SectionTextBox(width: width, height: height / 20, text: "Ingredients")
                    
                    ForEach(recipe.ingredients, id: \.self) { ing in
                        if ing.count > 3 {
                            Text(ing)
                        }
                    }
                    
                    SectionTextBox(width: width, height: height / 20, text: "Instructions")
                    
                    Text(recipe.instructions)
                        .lineSpacing(10)
                        .padding([.leading, .trailing], width / 20)
                    
                }
            }.frame(maxWidth: .infinity, alignment: .top)
        }
    }
}

struct SectionTextBox: View {
    
    @State var width: CGFloat
    @State var height: CGFloat
    @State var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title2)
                .foregroundColor(Color.white)
                .frame(width: width, height: height)
                .background(Color.orange)
        }.frame(maxWidth: .infinity, maxHeight: height, alignment: .leading)
    }
}
