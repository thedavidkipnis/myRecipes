//
//  DataFetch.swift
//  myRecipes
//
//  Created by David Kipnis on 5/2/23.
//
//  Class that communicates with themealdb API and fetches data from its two endpoints:
//  - Desserts section
//  - Looking up recipe by ID

import SwiftUI

class RecipeDataGetter {
    
    // Variables for storing URLS for accessing endpoints
    var API_URL: String = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    var API_DETAIL_URL: String = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
    
    // Holds list of Recipe structs fetched from API_URL
    var recipeData: [RecipeData]
    
    // Holds list of Detailed Recipes fetched from API_DETAILED_URL
    var detailedRecipeData: [Int:DetailedMealsData]
    
    // Makes call to API and fetches all data from the Desserts category
    // Uses RecipeTotalData struct
    func decodeRecipes() async {
        guard let url = URL(string: API_URL) else {
            print("Invalid URL")
            return
        }
        do {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let decodedResponse = try? JSONDecoder().decode(RecipeTotalData.self, from: data) {
            recipeData = decodedResponse.meals
        }
        } catch {
            print("Error fetching data from " + API_URL)
        }
    }
    
    // Generates a comprehensive list of Recipes from the data gathered by the recipe decoder
    func generateRecipes() async -> [Recipe] {
            var recipes = [Recipe]()
            for r in recipeData {
                let newRecipe = Recipe(id: Int(r.idMeal) ?? -1, name: r.strMeal, imageURL: r.strMealThumb)
                recipes.append(newRecipe)
            }
            return recipes
        }
    
    
    // Makes call to API to fetch specific recipe by ID to generate a detailed recipe
    func decodeDetailedRecipe(mealId: Int) async -> [DetailedMealsData] {
        var ret: [DetailedMealsData] = []
        guard let url = URL(string: API_DETAIL_URL + String(mealId)) else {
            print("Invalid URL")
            return ret
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(DetailData.self, from: data) {
                
                ret.append(decodedResponse.meals[0])
                
            }
        } catch {
            print("Error fetching detailed recipe with id " + String(mealId))
            return []
        }
        return ret
    }    
    
    init() {
        self.recipeData = []
        self.detailedRecipeData = [:]
    }
}

// Used by recipe decoder to fetch data from API
struct RecipeTotalData: Decodable {
    
    let meals: [RecipeData]
    
}

// Used by recipe decoder to fetch data from API
struct RecipeData: Decodable {
    
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
}

// Used by detailed recipe decoder to fetch data from API
struct DetailData: Decodable {
    
    let meals: [DetailedMealsData]
    
}

// Used by detailed recipe decoder to fetch data from API
struct DetailedMealsData: Decodable {
        
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String
    
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    
    // Turns list of optionals into actual ingredients
    func getIngredients() -> [String] {
        
        var ret: [String] = [String]()
        
        ret.append(strIngredient1 ?? "")
        ret.append("+++")
        ret.append(strMeasure1 ?? "")
        ret.append("~")
        ret.append(strIngredient2 ?? "")
        ret.append("+++")
        ret.append(strMeasure2 ?? "")
        ret.append("~")
        ret.append(strIngredient3 ?? "")
        ret.append("+++")
        ret.append(strMeasure3 ?? "")
        ret.append("~")
        ret.append(strIngredient4 ?? "")
        ret.append("+++")
        ret.append(strMeasure4 ?? "")
        ret.append("~")
        ret.append(strIngredient5 ?? "")
        ret.append("+++")
        ret.append(strMeasure5 ?? "")
        ret.append("~")
        ret.append(strIngredient6 ?? "")
        ret.append("+++")
        ret.append(strMeasure6 ?? "")
        ret.append("~")
        ret.append(strIngredient7 ?? "")
        ret.append("+++")
        ret.append(strMeasure7 ?? "")
        ret.append("~")
        ret.append(strIngredient8 ?? "")
        ret.append("+++")
        ret.append(strMeasure8 ?? "")
        ret.append("~")
        ret.append(strIngredient9 ?? "")
        ret.append("+++")
        ret.append(strMeasure9 ?? "")
        ret.append("~")
        ret.append(strIngredient10 ?? "")
        ret.append("+++")
        ret.append(strMeasure10 ?? "")
                
        let ingString = ret.joined(separator: "")
        let separateIng = ingString.split(separator: "~")
        
        var true_ret = [String]()
        
        for i in separateIng {
            let new_string_parts = i.split(separator: "+++")
            var new_string = ""
            for part in new_string_parts {
                if new_string.count > 1 {
                    new_string += " - " + part
                } else {
                    new_string += part
                }
            }
            true_ret.append(new_string)
        }

        return true_ret
    }
    
}
