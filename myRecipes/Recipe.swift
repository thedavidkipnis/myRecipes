//
//  Recipe.swift
//  myRecipes
//
//  Created by David Kipnis on 5/3/23.
//

import SwiftUI

struct Recipe: Identifiable {
    let id: Int
    let name: String
    let imageURL: String
}

struct RecipeContainer: View {
    
    @State var title: String
    
    let width: CGFloat = UIScreen.main.bounds.width
    let height: CGFloat = UIScreen.main.bounds.height / 10
    
    var body: some View {
        HStack {
            Label(title, systemImage: "circle.fill")
                .padding([.leading], width / 12)
                .font(.headline)
        }
        .frame(width: width - width / 20, height: height, alignment: .leading)
        .background(Color.blue)
        .foregroundColor(Color.white)
        .cornerRadius(30)
        .padding([.bottom], height / 30)
    }
}

struct DetailedRecipe: Identifiable {
    let id: Int
    let name: String
    let imageURL: String
    let instructions: String
    let ingredients: [String]
}
