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
    
    var body: some View {
        Text(recipe.name)
        Text(recipe.instructions)
        Text(recipe.imageURL)
    }
}
