//
//  ContentView.swift
//  Face_APP
//
//  Created by Tipu on 26/8/24.
//

import SwiftUI
import LocalAuthentication

struct FaceIDView: View {
    @State private var isAuthenticated = false
    @State private var authenticationError: String?

    var body: some View {
        VStack {
            if isAuthenticated {
                Text("Welcome, you're authenticated!")
                    .font(.largeTitle)
                    .padding()
            } else {
                Text("Please authenticate to continue.")
                    .font(.headline)
                    .padding()

                Button(action: authenticate) {
                    Text("Authenticate with Face ID")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                if let error = authenticationError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .onAppear(perform: authenticate) // Automatically prompt for authentication when the view appears
    }

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // Check if Face ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate to proceed."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                    } else {
                        self.authenticationError = authenticationError?.localizedDescription ?? "Failed to authenticate"
                    }
                }
            }
        } else {
            self.authenticationError = error?.localizedDescription ?? "Face ID/Touch ID not available"
        }
    }
}


#Preview {
    FaceIDView()
}
