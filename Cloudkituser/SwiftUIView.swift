//
//  SwiftUIView.swift
//  Triangle
//
//  Created by Ciaran Mullen on 23/01/2025.
//

import SwiftUI
import CloudKit

class SwiftUIViewModel: ObservableObject {
    
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    
    init () {
        getiCloudStatus()
    }
    
    private func getiCloudStatus() {
        CKContainer.default().accountStatus {[weak self] returnedStatus, returnedError in DispatchQueue.main.async {
                
                switch returnedStatus {
                case .available:
                    self?.isSignedInToiCloud = true
                case .noAccount:
                    self?.error = CloudKitError.iCloudAccountNotFound.localizedDescription
                case .couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccountNotDetermined.localizedDescription
                case .restricted:
                    self?.error = CloudKitError.iCloudAccountRestricted.localizedDescription
                case .temporarilyUnavailable:
                    self?.error = CloudKitError.iCloudAccountUnknown.localizedDescription
                }
            }
        }
    }
        enum CloudKitError: LocalizedError {
            case iCloudAccountNotFound
            case iCloudAccountNotDetermined
            case iCloudAccountRestricted
            case iCloudAccountUnknown

        }
        
    }




struct SwiftUIView: View {
    
    @StateObject private var vm = SwiftUIViewModel()
    
    var body: some View {
        Text("you are in SwiftUIView")
        Text("IS Signed in: \(vm.isSignedInToiCloud.description.uppercased())")
    }
}

#Preview {
    SwiftUIView()
}
