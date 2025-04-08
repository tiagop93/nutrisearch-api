//
//  ProfessionalListTests.swift
//  NutriSearch.ChallengeUITests
//
//  Created by Tiago Pereira on 08/04/2025.
//

import XCTest

final class ProfessionalListTests: XCTestCase {
    
    // MARK: - Properties
    
    private var app: XCUIApplication!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        app = .init()
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    // MARK: - UI Tests
    
    func testOpenProfessionalDetails() {
        
        let professionalListCollectionView = app.collectionViews["ProfessionalListView"]
        let progressView = professionalListCollectionView.activityIndicators["ProgressView"]
        
        XCTAssertTrue(progressView.waitForNonExistence(timeout: 5.0), "The progress view should disappear after around 5 seconds.")
        
        let initialProfessionalList = professionalListCollectionView.children(matching: .cell)
        
        XCTAssertTrue(initialProfessionalList.count > 0, "The professional list should have some elements")
        
        initialProfessionalList.element(boundBy: 0).tap()
        
        let detailsProgressView = app.activityIndicators["DetailsProgressView"]
        
        XCTAssertTrue(detailsProgressView.waitForNonExistence(timeout: 5.0), "The details progress view should disappear after around 5 seconds.")
    }
}
