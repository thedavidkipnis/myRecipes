//
//  ContentView.swift
//  myRecipes
//
//  Created by David Kipnis on 5/2/23.
//

import SwiftUI

struct ContentView: View {
    
    let recipeDataGetter: RecipeDataGetter = RecipeDataGetter()
    @State private var recipes: [Recipe] = [Recipe]()
    @State private var curRecipe: Recipe = Recipe(id: -1, name: "", imageURL: "")
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(self.recipes) { r in
                    NavigationLink(destination: DetailView(recipe: $curRecipe)) {
                        Text(r.name)
                    }.simultaneousGesture(TapGesture().onEnded {
                        Task {
                            let updatedRecipe = await recipeDataGetter.decodeDetailedRecipe(mealId: r.id)
                            curRecipe = Recipe(id: -1, name: updatedRecipe[0].strMeal, imageURL: "")
                        }
                    })
                    .simultaneousGesture(LongPressGesture().onEnded {_ in
                        curRecipe = r
                    })
                }
            }
            .padding()
        }.task {
            await recipeDataGetter.decodeRecipes()
            self.recipes = await recipeDataGetter.generateRecipes()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Recipe: Decodable, Identifiable {
    let id: Int
    let name: String
    let imageURL: String
}
