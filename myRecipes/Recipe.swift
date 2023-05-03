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

struct DetailedRecipe: Identifiable {
    let id: Int
    let name: String
    let imageURL: String
    let instructions: String
    let ingredients: [String]
}
