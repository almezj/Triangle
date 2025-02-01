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

    /// Check if iCloud is available
    func checkiCloudStatus(completion: @escaping (Bool) -> Void) {
        container.accountStatus { status, error in
            DispatchQueue.main.async {
                switch status {
                case .available:
                    print("✅ iCloud Available")
                    completion(true)
                case .noAccount:
                    print("⚠️ No iCloud Account")
                    completion(false)
                case .restricted:
                    print("⛔ iCloud Restricted")
                    completion(false)
                case .couldNotDetermine:
                    print("❓ iCloud Status Unknown")
                    completion(false)
                @unknown default:
                    completion(false)
                }
            }
        }
    }

    /// Fetch the user's CloudKit record ID (Apple ID)
    func fetchUserRecord(completion: @escaping (CKRecord.ID?) -> Void) {
        container.fetchUserRecordID { recordID, error in
            DispatchQueue.main.async {
                if let recordID = recordID {
                    print("✅ User Record ID: \(recordID.recordName)")
                    completion(recordID)
                } else {
                    print("⚠️ Error fetching user record: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                }
            }
        }
    }

    /// Save a new user to CloudKit
    func saveUser(username: String, email: String, completion: @escaping (Bool, Error?) -> Void) {
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

    /// Fetch an existing user from CloudKit
    func fetchUser(username: String, completion: @escaping (CKRecord?) -> Void) {
        let predicate = NSPredicate(format: "username == %@", username)
        let query = CKQuery(recordType: "TriangleUsers", predicate: predicate)

        self.privateDatabase.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                if let record = records?.first {
                    print("✅ User found: \(record["username"] ?? "Unknown")")
                    completion(record)
                } else {
                    print("⚠️ User not found")
                    completion(nil)
                }
            }
        }
    }
}
