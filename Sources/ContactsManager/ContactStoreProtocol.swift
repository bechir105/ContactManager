import Contacts

public protocol ContactStoreProtocol {
    func requestAccess(for entityType: CNEntityType, completionHandler: @escaping (Bool, Error?) -> Void)
    func enumerateContacts(with fetchRequest: CNContactFetchRequest, usingBlock block: @escaping (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws
    func unifiedContact(withIdentifier identifier: String, keysToFetch keys: [CNKeyDescriptor]) throws -> CNContact
    func execute(_ saveRequest: CNSaveRequest) throws
}

extension CNContactStore: ContactStoreProtocol {}
