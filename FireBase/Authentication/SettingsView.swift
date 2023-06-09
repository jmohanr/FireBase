//
//  SettingsView.swift
//  FireBase
//
//  Created by Kaplan2 on 01/06/23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewViewModel()
    @Binding var showSignInView: Bool
    @State var showAlert: Bool = false
    
    var body: some View {
        List {
            Button("Logout") {
                do {
                   try viewModel.signOut()
                    showSignInView = true
                } catch {
                    print(error)
                }
            }
            emailSection
        }.navigationTitle(Text("Settings"))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}

extension SettingsView {
    
    private var emailSection: some View {
       Section("Emaail Section") {
            Button("Rest Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        showAlert = true
                    } catch {
                        print(error)
                    }
                }
            } .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Alert"),
                    message: Text("An reset link shared to u r mail id"),
                    dismissButton: .default(Text("OK"))
                )
            }
            Button("Update Email") { }
            Button("Update Password") {}
        }
    }
}
