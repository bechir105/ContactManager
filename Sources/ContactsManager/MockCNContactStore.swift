//
//  File.swift
//  
//
//  Created by Bechir Kefi on 12/7/2024.
//

import Contacts

class MockContactStore: ContactStoreProtocol {
    var granted: Bool = true
    var contacts: [CNContact] = []

    func requestAccess(for entityType: CNEntityType, completionHandler: @escaping (Bool, Error?) -> Void) {
        completionHandler(granted, nil)
    }

    func enumerateContacts(with fetchRequest: CNContactFetchRequest, usingBlock block: @escaping (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws {
        for contact in contacts {
            block(contact, UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1))
        }
    }

    func unifiedContact(withIdentifier identifier: String, keysToFetch keys: [CNKeyDescriptor]) throws -> CNContact {
        if let contact = contacts.first(where: { $0.identifier == identifier }) {
            return contact
        } else {
            throw NSError(domain: "MockCNContactStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Contact not found"])
        }
    }

    func execute(_ saveRequest: CNSaveRequest) throws {
        // Handle add, update, and delete contact operations
    }
}

protocol ContactStoreProtocol {
    func requestAccess(for entityType: CNEntityType, completionHandler: @escaping (Bool, Error?) -> Void)
    func enumerateContacts(with fetchRequest: CNContactFetchRequest, usingBlock block: @escaping (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws
    func unifiedContact(withIdentifier identifier: String, keysToFetch keys: [CNKeyDescriptor]) throws -> CNContact
    func execute(_ saveRequest: CNSaveRequest) throws
}

extension CNContactStore: ContactStoreProtocol {}

