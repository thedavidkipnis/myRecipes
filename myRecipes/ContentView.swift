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
    @State private var curRecipe: DetailedRecipe = DetailedRecipe(id: -1, name: "", imageURL: "", instructions: "", ingredients: [])
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(self.recipes) { r in
                    NavigationLink(destination: DetailView(recipe: $curRecipe)) {
                        Text(r.name)
                    }.simultaneousGesture(TapGesture().onEnded {
                        Task {
                            let fetch = await recipeDataGetter.decodeDetailedRecipe(mealId: r.id)[0]
                            let newId = Int(fetch.idMeal) ?? -1
                            curRecipe = DetailedRecipe(id: newId, name: fetch.strMeal, imageURL: fetch.strMealThumb, instructions: fetch.strInstructions, ingredients: [])
                        }
                    })
//                    .simultaneousGesture(LongPressGesture().onEnded {_ in
//                        curRecipe = r
//                    })
                }
            }
            .frame(maxWidth: .infinity)
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
