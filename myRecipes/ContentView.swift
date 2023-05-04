//
//  ContentView.swift
//  myRecipes
//
//  Created by David Kipnis on 5/2/23.
//
//  Main view of the app that includes all individual recipes

import SwiftUI

struct ContentView: View {
    
    //class that fetches all the data from API
    let recipeDataGetter: RecipeDataGetter = RecipeDataGetter()
    
    // List of all recipes
    @State private var recipes: [Recipe] = [Recipe]()
    
    // Cache for keeping loaded recipe data in app to avoid having to call API too many times
    @State private var RecipeCache: [Int:DetailedRecipe] = [:]
    
    // Recipe that gets assigned to detail view when app is launched
    private let dummyRecipe: DetailedRecipe = DetailedRecipe(id: -1, name: "", imageURL: "", instructions: "", ingredients: [])
    
    // Current recipe that is being used to update detailed view
    @State private var curRecipe: DetailedRecipe
    
    @State private var loaded: Bool = false
    
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
                
                if !loaded {
                    Text("Loading...")
                }
                
                // Display of all recipes
                ScrollView {
                    ForEach(self.recipes) { r in
                        NavigationLink(destination: DetailView(recipe: $curRecipe)) {
                            RecipeContainer(title: r.name)
                        }
                        .simultaneousGesture(TapGesture().onEnded { // method that updates the DetailedView
                            
                            // Case where the cache doesn't have the recipe data loaded
                            if RecipeCache[r.id] == nil {
                                Task {
                                    let fetchData = await recipeDataGetter.decodeDetailedRecipe(mealId: r.id)
                                    let fetch = fetchData[0]
                                    let ingredients = fetch.getIngredients()
                                    let newId = Int(fetch.idMeal) ?? -1
                                    curRecipe = DetailedRecipe(id: newId, name: fetch.strMeal, imageURL: fetch.strMealThumb, instructions: fetch.strInstructions, ingredients: ingredients)
                                    RecipeCache[r.id] = curRecipe
                                }
                            // Case where recipe data is already in cache
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
                
            // The initialization tasks for the recipe data getter
            // Generates all the recipes with the initial call to API
            }.task {
                await recipeDataGetter.decodeRecipes()
                self.recipes = await recipeDataGetter.generateRecipes()
                self.loaded.toggle()
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
