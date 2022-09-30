//
//  tawkiOSTestTests.swift
//  tawkiOSTestTests
//
//  Created by Apple on 29/09/22.
//

import XCTest
import CoreData
@testable import tawkiOSTest

final class tawkiOSTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //----------------------------------------------------------------------------
    // MARK: - Save / Fetch / Update operations check
    //----------------------------------------------------------------------------
    func testSaveDataInCoreData() {
        /// Add Static Data in Coredata
        let managedContext = viewContext
        let newUsers = DatabaseHandler().getNewManageObject()
        newUsers.setValue("test name", forKey: "login")
        newUsers.setValue("test blog", forKey: "blog")
        newUsers.setValue(1, forKey: "id")
        DatabaseHandler().save()
        
        /// Fetch Data From Static ID
        let result =  DatabaseHandler().fetchDataFromID(idValue: 1)
        
        XCTAssertEqual("test name", result.value(forKey: "login") as? String ?? "")
    }

    
    func testUpdateDataInCoreData() {
        
        /// Add Static Data in Coredata
        let managedContext = viewContext
        let newUsers = DatabaseHandler().getNewManageObject()
        newUsers.setValue("test name", forKey: "login")
        newUsers.setValue(2, forKey: "id")
        DatabaseHandler().save()
        
        /// Fetch Data From Static ID
        let result =  DatabaseHandler().fetchDataFromID(idValue: 2)
        result.setValue("testing name", forKey: "login")
        DatabaseHandler().save()

        /// Fetch Data From Static ID
        let resultNew =  DatabaseHandler().fetchDataFromID(idValue: 2)
        
        XCTAssertEqual("testing name", resultNew.value(forKey: "login") as? String ?? "")
    }
    
}
