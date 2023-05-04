//
//  DataFetchTest.swift
//  myRecipesTests
//
//  Created by David Kipnis on 5/4/23.
//
//
//  Test for Data Fetching from the API

import XCTest
@testable import myRecipes

final class DataFetchTest: XCTestCase {
    
    var dataGetter: myRecipes.RecipeDataGetter!

    override func setUpWithError() throws {
        super.setUp()
        dataGetter = RecipeDataGetter()
    }

    override func tearDownWithError() throws {
        super.tearDown()
        dataGetter = nil
    }

    // Test for total data fetching
    func decodeRecipesSuccessTest() async throws {
        await dataGetter.decodeRecipes()
        XCTAssert(dataGetter.recipeData.count > 0)
    }
    
    // Test with good ID
    func decodeDetailedRecipeSuccessTest() async throws {
        let testData : [DetailedMealsData] = await dataGetter.decodeDetailedRecipe(mealId: 52905)
        XCTAssert(testData.count > 0)
    }
    
    // Test with bad ID
    func decodeDetailedRecipeFailTest() async throws {
        let testData : [DetailedMealsData] = await dataGetter.decodeDetailedRecipe(mealId: 0)
        XCTAssert(testData.count < 1)
    }
    
    func t() throws {
        XCTAssert(1 > 2)
    }

    
}
