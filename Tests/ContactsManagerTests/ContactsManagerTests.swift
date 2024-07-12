import XCTest
import Contacts
@testable import ContactsManager

final class ContactsManagerTests: XCTestCase {

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
