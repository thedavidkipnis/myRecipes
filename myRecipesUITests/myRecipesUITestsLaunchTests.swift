//
//  myRecipesUITestsLaunchTests.swift
//  myRecipesUITests
//
//  Created by David Kipnis on 5/2/23.
//

//  Default tests provided by Xcode

import XCTest

final class myRecipesUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
