import Foundation
import Contacts

public class ContactsManager {

    private let store: CNContactStore

      public init(store: CNContactStore = CNContactStore()) {
          self.store = store
      }

    public func requestAccess(completion: @escaping (Result<Bool, Error>) -> Void) {
        store.requestAccess(for: .contacts) { granted, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(granted))
            }
        }
    }

    public func fetchAllContacts(completion: @escaping (Result<[CNContact], Error>) -> Void) {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)

        var contacts: [CNContact] = []

        do {
            try store.enumerateContacts(with: request) { contact, _ in
                contacts.append(contact)
            }
            completion(.success(contacts))
        } catch {
            completion(.failure(error))
        }
    }

    public func addContact(givenName: String, familyName: String, email: String?, phoneNumber: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        let contact = CNMutableContact()
        contact.givenName = givenName
        contact.familyName = familyName
        if let email = email {
            contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: email as NSString)]
        }
        if let phoneNumber = phoneNumber {
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: phoneNumber))]
        }

        let request = CNSaveRequest()
        request.add(contact, toContainerWithIdentifier: nil)

        do {
            try store.execute(request)
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }

    public func updateContact(identifier: String, givenName: String?, familyName: String?, email: String?, phoneNumber: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            let contact = try store.unifiedContact(withIdentifier: identifier, keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor])

            let mutableContact = contact.mutableCopy() as! CNMutableContact
            if let givenName = givenName {
                mutableContact.givenName = givenName
            }
            if let familyName = familyName {
                mutableContact.familyName = familyName
            }
            if let email = email {
                mutableContact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: email as NSString)]
            }
            if let phoneNumber = phoneNumber {
                mutableContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: phoneNumber))]
            }

            let request = CNSaveRequest()
            request.update(mutableContact)

            try store.execute(request)
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }

    public func deleteContact(identifier: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            let contact = try store.unifiedContact(withIdentifier: identifier, keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor])
            let mutableContact = contact.mutableCopy() as! CNMutableContact

            let request = CNSaveRequest()
            request.delete(mutableContact)

            try store.execute(request)
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
}
