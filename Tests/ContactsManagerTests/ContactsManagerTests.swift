import XCTest
import CoreData
@testable import ContactsManager

final class ContactsManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Optionally clear the database before each test
    }

    override func tearDown() {
        // Optionally clear the database after each test
        super.tearDown()
    }

    func testRequestAccess() {
        let expectation = self.expectation(description: "Access Request")

        let contactsManager = ContactsManager()
        contactsManager.requestAccess { result in
            switch result {
            case .success(let granted):
                XCTAssertTrue(granted, "Access should be granted.")
            case .failure(let error):
                XCTFail("Request access failed with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchAllContacts() {
        let expectation = self.expectation(description: "Fetch Contacts")

        let contactsManager = ContactsManager()
        contactsManager.fetchAllContacts { result in
            switch result {
            case .success(let contacts):
                XCTAssertNotNil(contacts, "Contacts should not be nil.")
                XCTAssertFalse(contacts.isEmpty, "Contacts should not be empty.")
            case .failure(let error):
                XCTFail("Fetch contacts failed with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
