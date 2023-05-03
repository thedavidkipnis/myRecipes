//
//  DataFetch.swift
//  myRecipes
//
//  Created by David Kipnis on 5/2/23.
//

import SwiftUI

class RecipeDataGetter {
    
    var API_URL: String = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    var API_DETAIL_URL: String = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
    var recipeData: [RecipeData]
    var detailedRecipeData: [Int:DetailedMealsData]
    
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
    
    func generateRecipes() async -> [Recipe] {
            var recipes = [Recipe]()
            for r in recipeData {
                let newRecipe = Recipe(id: Int(r.idMeal) ?? -1, name: r.strMeal, imageURL: r.strMealThumb)
                recipes.append(newRecipe)
            }
            return recipes
        }
    
    
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
            print("Error fetching data from " + API_URL)
        }
        return ret
    }    
    
    init() {
        self.recipeData = []
        self.detailedRecipeData = [:]
    }
}

struct RecipeTotalData: Decodable {
    
    let meals: [RecipeData]
    
}

struct RecipeData: Decodable {
    
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
}

struct DetailData: Decodable {
    
    let meals: [DetailedMealsData]
    
}

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
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    
    func getIngredients() -> [String] {
        var ret: Set = Set<String>()
        
        ret.insert(strIngredient1 ?? "")
        ret.insert(strIngredient2 ?? "")
        ret.insert(strIngredient3 ?? "")
        ret.insert(strIngredient4 ?? "")
        ret.insert(strIngredient5 ?? "")
        ret.insert(strIngredient6 ?? "")
        ret.insert(strIngredient7 ?? "")
        ret.insert(strIngredient8 ?? "")
        ret.insert(strIngredient9 ?? "")
        ret.insert(strIngredient10 ?? "")
        ret.insert(strIngredient11 ?? "")
        ret.insert(strIngredient12 ?? "")
        ret.insert(strIngredient13 ?? "")
        ret.insert(strIngredient14 ?? "")
        ret.insert(strIngredient15 ?? "")
        ret.insert(strIngredient16 ?? "")
        ret.insert(strIngredient17 ?? "")
        ret.insert(strIngredient18 ?? "")
        ret.insert(strIngredient19 ?? "")
        ret.insert(strIngredient20 ?? "")
        
        ret.remove("")
        
        return Array(ret)
    }
    
}
