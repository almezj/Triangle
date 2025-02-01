//
//  CloudKitManager.swift
//  Triangle
//
//  Created by Ciaran Mullen on 30/01/2025.
//
import CloudKit

class CloudKitManager {
    static let shared = CloudKitManager() // Singleton instance

    private let container = CKContainer.default()
    private let privateDatabase = CKContainer.default().privateCloudDatabase

    func checkiCloudStatus(completion: @escaping (Bool) -> Void) {
        container.accountStatus { status, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error checking iCloud status: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                switch status {
                case .available:
                    print("✅ iCloud Available")
                    completion(true)
                case .noAccount:
                    print("⚠️ No iCloud Account - Please sign in to iCloud.")
                    completion(false)
                case .restricted:
                    print("⛔ iCloud is Restricted - Check parental controls or MDM settings.")
                    completion(false)
                case .couldNotDetermine:
                    print("❓ iCloud Status Unknown - Try again later.")
                    completion(false)
                case .temporarilyUnavailable:
                    print("❓ iCloud Status Unknown - Try again later.")
                    completion(false)
                @unknown default: // ✅ Required for Swift 6
                    print("🚨 Unknown iCloud status - Future case.")
                    completion(false)
                }
            }
        }
    }



    /// Fetch an existing user from CloudKit (for login verification)
    func fetchUser(username: String, completion: @escaping (Bool, CKRecord?, Error?) -> Void) {
        let predicate = NSPredicate(format: "username == %@", username)
        let query = CKQuery(recordType: "TriangleUsers", predicate: predicate)

        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1 // ✅ Limits to 1 record (best practice for login)
        
        var fetchedRecord: CKRecord?

        queryOperation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                fetchedRecord = record
            case .failure(let error):
                print("⚠️ Error fetching user: \(error.localizedDescription)")
                completion(false, nil, error)
            }
        }

        queryOperation.queryResultBlock = { result in
            DispatchQueue.main.async {
                if let record = fetchedRecord {
                    print("✅ User found: \(record["username"] ?? "Unknown")")
                    completion(true, record, nil)
                } else {
                    print("⚠️ User not found")
                    completion(false, nil, nil)
                }
            }
        }

        privateDatabase.add(queryOperation) // ✅ Use CKQueryOperation instead of deprecated method
    }

    /// Save a new user to CloudKit (Prevents duplicate usernames)
    func saveUser(username: String, email: String,password: String, completion: @escaping (Bool, Error?) -> Void) {
        // Step 1: Check if the username already exists
        fetchUser(username: username) { exists, _, error in
            if let error = error {
                completion(false, error)
                return
            }

            if exists {
                let usernameTakenError = NSError(domain: "CloudKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Username is already taken."])
                completion(false, usernameTakenError)
                return
            }

            // Step 2: Username is available, create a new CloudKit record
            let record = CKRecord(recordType: "TriangleUsers")
            record["username"] = username as CKRecordValue
            record["email"] = email as CKRecordValue

            self.privateDatabase.save(record) { savedRecord, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Error saving user: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("✅ User saved: \(username)")
                        completion(true, nil)
                    }
                }
            }
        }
    }
}
