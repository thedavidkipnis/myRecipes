//
//  Recipe.swift
//  myRecipes
//
//  Created by David Kipnis on 5/3/23.
//
//  Contains structs and data for Recipe and Detailed Recipe views

import SwiftUI

// Variables for setting dimensions
let width: CGFloat = UIScreen.main.bounds.width
let height: CGFloat = UIScreen.main.bounds.height

struct Recipe: Identifiable {
    let id: Int
    let name: String
    let imageURL: String
}

struct RecipeContainer: View {
    
    @State var title: String
    
    var body: some View {
        HStack {
            Label(title, systemImage: "circle.fill")
                .padding([.leading], width / 12)
        }
        .font(.headline)
        .frame(width: width - width / 20, height: height / 10, alignment: .leading)
        .background(Color.blue)
        .foregroundColor(Color.white)
        .cornerRadius(30)
        .padding([.bottom, .top], height / 80)
    }
}

struct DetailedRecipe: Identifiable {
    let id: Int
    let name: String
    let imageURL: String
    let instructions: String
    let ingredients: [String]
}

struct DetailView: View {
    
    // Recipe that gets passed to this view from main view
    @Binding var recipe: DetailedRecipe
    
    var body: some View {
        
        // Sets loading screen while waiting for information retrieval
        if recipe.id == -1 {
            Text("Loading Recipe...")
        } else {
            
            VStack(spacing: 0) {
                
                // Main page header with title
                HStack {
                    Text(recipe.name)
                        .frame(width: width, height: height / 20)
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding([.bottom], UIScreen.main.bounds.height / 40)
                        .underline()
                }.background(Color.blue)

                
                // Scrollview containing the ingredients and instructions sections
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

// Struct for section header
// Used by DetailView struct
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
