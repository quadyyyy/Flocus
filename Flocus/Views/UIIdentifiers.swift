//
//  UIIdentifiers 2.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 14.05.2026.
//


//
//  UIIdentifiers.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 14.05.2026.
//

import Foundation


enum UIIdentifiers {
    
    enum FirstOnboardingView {
        static let continueButton: String = "FirstOnboardingView.continueButton"
    }
    
    enum SecondOnboardingView {
        static let continueButton: String = "SecondOnboardingView.continueButton"
    }
    
    enum ThirdOnboardingView {
        static let textField: String = "ThirdOnboardingView.textField"
        static let continueButton: String = "ThirdOnboardingView.continueButton"
    }
    
    enum FourthOnboardingView {
        static let startFocusButton: String = "FourthOnboardingView.startFocusButton"
    }
    
    enum TodayView {
        static let newTaskButton: String = "TodayView.newTaskButton"
    }
    
    enum NewTaskView {
        static let taskTitleTextField: String = "NewTaskView.taskTitleTextField"
        static let taskDescriptionTextField: String = "NewTaskView.taskDescriptionTextField"
        static let tagPickerHomeButton: String = "NewTaskView.tagPicker.home"
        static let datePicker: String = "NewTaskView.datePicker"
        static let saveButton: String = "NewTaskView.saveButton"
    }
}
