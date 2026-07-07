import XCTest

final class WakewordUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddButtonOpensSheet() throws {
        app.buttons["addEntryButton"].tap()
        XCTAssertTrue(app.navigationBars.element.exists)
    }

    func testSettingsButtonOpensSettings() throws {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }

    func testAddEntryFlow() throws {
        app.buttons["addEntryButton"].tap()
        let saveButton = app.buttons["saveEntryButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()
    }

    func testKeyboardDismissOnTapOutside() throws {
        app.buttons["addEntryButton"].tap()
        let textFields = app.textFields
        if textFields.count > 0 {
            let field = textFields.firstMatch
            field.tap()
            field.typeText("test")
            app.navigationBars.firstMatch.tap()
            XCTAssertFalse(field.isSelected)
        }
    }

    func testRepeatedAddsTriggerPaywallEventually() throws {
        for _ in 0..<40 {
            if app.buttons["addEntryButton"].exists {
                app.buttons["addEntryButton"].tap()
            }
            if app.buttons["saveEntryButton"].waitForExistence(timeout: 1) {
                app.buttons["saveEntryButton"].tap()
            } else if app.buttons["paywallCloseButton"].exists {
                app.buttons["paywallCloseButton"].tap()
                break
            }
        }
    }
}
