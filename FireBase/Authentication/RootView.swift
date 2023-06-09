//
//  RootView.swift
//  FireBase
//
//  Created by Kaplan2 on 01/06/23.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            SettingsView(showSignInView: $showSignInView)
        }
        .onAppear {
            let user = try? AuthenticationManager.shared.getAuthUser()
            self.showSignInView = user == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
