//
//  ContentView.swift
//  myRecipes
//
//  Created by David Kipnis on 5/2/23.
//

import SwiftUI

struct ContentView: View {
    
    //class that fetches all the data from API
    let recipeDataGetter: RecipeDataGetter = RecipeDataGetter()
    
    // List of all recipes
    @State private var recipes: [Recipe] = [Recipe]()
    
    @State private var RecipeCache: [Int:DetailedRecipe] = [:]
    
    private let dummyRecipe: DetailedRecipe = DetailedRecipe(id: -1, name: "", imageURL: "", instructions: "", ingredients: [])
    
    // Current recipe that is being used to update detailed view
    @State private var curRecipe: DetailedRecipe
    
    // Main Screen
    var body: some View {
        NavigationView {
            
            VStack(spacing: 0) {
                
                // Page Title
                HStack {
                    Text("Recipes")
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 20)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .padding([.bottom], UIScreen.main.bounds.height / 40)
                }.background(Color.blue)
                
                // Display of all recipes
                ScrollView {
                    ForEach(self.recipes) { r in
                        NavigationLink(destination: DetailView(recipe: $curRecipe)) {
                            RecipeContainer(title: r.name)
                        }
                        .simultaneousGesture(TapGesture().onEnded { // method that updates the DetailedView
                            if RecipeCache[r.id] == nil {
                                Task {
                                    let fetchData = await recipeDataGetter.decodeDetailedRecipe(mealId: r.id)
                                    let fetch = fetchData[0]
                                    let ingredients = fetch.getIngredients()
                                    let newId = Int(fetch.idMeal) ?? -1
                                    curRecipe = DetailedRecipe(id: newId, name: fetch.strMeal, imageURL: fetch.strMealThumb, instructions: fetch.strInstructions, ingredients: ingredients)
                                    RecipeCache[r.id] = curRecipe
                                }
                            } else {
                                curRecipe = RecipeCache[r.id] ?? dummyRecipe
                            }
                            
                        })
                    }
                }
                .frame(maxWidth: .infinity)
                .scrollIndicators(.hidden)
                .onAppear {
                    self.curRecipe = dummyRecipe
                }
            }.task {
                await recipeDataGetter.decodeRecipes()
                self.recipes = await recipeDataGetter.generateRecipes()
            }
        }.tint(Color.white)
    }
    
    init() {
        self.curRecipe = dummyRecipe
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
