//
//  OboardingUITests.swift
//  FlocusUITests
//
//  Created by Timofei Kupriianov on 13.05.2026.
//

import XCTest

final class OnboardingUITests: XCTestCase {

    let app = XCUIApplication()
    let firstOnboardingID = UIIdentifiers.FirstOnboardingView.self
    let secondOnboardingID = UIIdentifiers.SecondOnboardingView.self
    let thirdOnboardingID = UIIdentifiers.ThirdOnboardingView.self
    let fourthOnboardingID = UIIdentifiers.FourthOnboardingView.self

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("--resetOnboarding")
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }
    
    func test_onboarding_ui_works_correct() throws {
        app.buttons[firstOnboardingID.continueButton].tap()
        app.buttons[secondOnboardingID.continueButton].tap()
        
        app.textFields[thirdOnboardingID.textField].tap()
        app.textFields[thirdOnboardingID.textField].typeText("Oleg")
        app.buttons[thirdOnboardingID.continueButton].tap()
        app.buttons["avatar2"].firstMatch.tap()
        app.buttons[fourthOnboardingID.startFocusButton].tap()
        
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 3))
    }

}
