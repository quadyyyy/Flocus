//
//  NewTaskFlowUITests.swift
//  FlocusUITests
//
//  Created by Timofei Kupriianov on 15.05.2026.
//

import XCTest

final class NewTaskFlowUITests: XCTestCase {

    let app = XCUIApplication()
    let todayID = UIIdentifiers.TodayView.self
    let newTaskID = UIIdentifiers.NewTaskView.self
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("--skipOnboarding")
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }
    
    func test_newTask_flow() throws {
        app.buttons[todayID.newTaskButton].tap()
        
        let titleTextField = app.textFields[newTaskID.taskTitleTextField]
        titleTextField.tap()
        titleTextField.typeText("Buy some milk")
        
        let descriptionTextField = app.textFields[newTaskID.taskDescriptionTextField]
        descriptionTextField.tap()
        descriptionTextField.typeText("Buy two gallons at Walmart")
        
        app.buttons[newTaskID.tagPickerHomeButton].tap()       
        app.buttons[newTaskID.saveButton].tap()

        XCTAssertTrue(app.staticTexts["Buy some milk"].waitForExistence(timeout: 3))
    }
}
