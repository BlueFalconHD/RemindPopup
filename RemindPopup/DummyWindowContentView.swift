//
//  DummyWindowContentView.swift
//  RemindPopup
//
//  Created by Hayes Dombroski on 6/19/24.
//

import SwiftUI

struct DummyWindowContentView: View {
    // import window dismiss enviornment
    @Environment(\.dismiss) var dismiss
    
    var appSettings: AppSettings = AppSettings()
    
    var body: some View {
        VStack {
            Text("Welcome to RemindPopup")
                .font(.title)
                .padding()
            
            Text("This is your first time opening the application. We will now set the default options for you. Click the hourglass icon in your menu bar to access the settings.")
                .padding()
        }
            .onAppear(perform: {
                // check if this is the first open of the application
                if !appSettings.applicationHasOpenedBefore {
                    // set the application has opened before to true
                    UserDefaults.standard.set(true, forKey: AppSettingKey.applicationHasOpenedBefore.rawValue)
                    
                    // set the default options
                    appSettings.setDefaultOptions()
                } else {
                    dismiss()
                }
            })
    }
}
