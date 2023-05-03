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
            
            VStack {
                
                Text("Recipes")
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 20)
                    .font(.largeTitle)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    
                
                ScrollView {
                    
                    ForEach(self.recipes) { r in
                        NavigationLink(destination: DetailView(recipe: $curRecipe)) {
                            RecipeContainer(title: r.name)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            
                            Task {
                                let fetch = await recipeDataGetter.decodeDetailedRecipe(mealId: r.id)[0]
                                let ingredients = fetch.getIngredients()
                                let newId = Int(fetch.idMeal) ?? -1
                                curRecipe = DetailedRecipe(id: newId, name: fetch.strMeal, imageURL: fetch.strMealThumb, instructions: fetch.strInstructions, ingredients: ingredients)
                            }
                            
                        })
                        .simultaneousGesture(LongPressGesture().onEnded {_ in
                            Task {
                                let fetch = await recipeDataGetter.decodeDetailedRecipe(mealId: r.id)[0]
                                let newId = Int(fetch.idMeal) ?? -1
                                curRecipe = DetailedRecipe(id: newId, name: fetch.strMeal, imageURL: fetch.strMealThumb, instructions: fetch.strInstructions, ingredients: [])
                            }
                        })
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .scrollIndicators(.hidden)
            }.task {
                await recipeDataGetter.decodeRecipes()
                self.recipes = await recipeDataGetter.generateRecipes()
            }
        }.tint(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
