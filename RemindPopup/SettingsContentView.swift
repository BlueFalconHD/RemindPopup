//
//  SettingsContentView.swift
//  Remind Popup
//
//  Created by Hayes Dombroski on 6/15/24.
//

import SwiftUI

struct SettingsContentView: View {
    @Environment(\.dismiss) var dismiss

    @AppStorage(AppSettingKey.applicationEnabled.rawValue) var applicationEnabled: Bool = true
    @AppStorage(AppSettingKey.popupQuoteToShow.rawValue) var popupQuoteToShow: String = "Make good choices"
    @AppStorage(AppSettingKey.popupFadeInTime.rawValue) var popupFadeInTime: TimeInterval = 1
    @AppStorage(AppSettingKey.popupFadeOutTime.rawValue) var popupFadeOutTime: TimeInterval = 1
    @AppStorage(AppSettingKey.popupSustainTime.rawValue) var popupSustainTime: TimeInterval = 3
    @AppStorage(AppSettingKey.popupEnableCooldown.rawValue) var enableCooldown: Bool = false
    @AppStorage(AppSettingKey.popupCooldownTime.rawValue) var popupCooldownTime: TimeInterval = 120
    @AppStorage(AppSettingKey.popupLastShow.rawValue) var popupLastShow: TimeInterval = Date().timeIntervalSince1970

    private let timeOptions: [Float] = [0.5, 1, 3, 5, 10, 15, 20]

    var body: some View {
        VStack {
            Form {
                Section(header: Text("General").font(.headline)) {
                    Toggle("Enable Application", isOn: $applicationEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                    TextField("Popup Quote", text: $popupQuoteToShow)
                        .textFieldStyle(.roundedBorder)
                }

                Section(header: Text("Popup Timing").font(.headline)) {
                    Picker("Fade In Time", selection: $popupFadeInTime) {
                        ForEach(timeOptions, id: \.self) { second in
                            Text("\(second, specifier: "%.1f") s").tag(TimeInterval(second))
                        }
                    }

                    Picker("Sustain Time", selection: $popupSustainTime) {
                        ForEach(timeOptions, id: \.self) { second in
                            Text("\(second, specifier: "%.1f") s").tag(TimeInterval(second))
                        }
                    }

                    Picker("Fade Out Time", selection: $popupFadeOutTime) {
                        ForEach(timeOptions, id: \.self) { second in
                            Text("\(second, specifier: "%.1f") s").tag(TimeInterval(second))
                        }
                    }
                }

                Section(header: Text("Cooldown Settings").font(.headline)) {
                    Toggle("Enable Cooldown", isOn: $enableCooldown)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    if enableCooldown {
                        Picker("Cooldown Time", selection: $popupCooldownTime) {
                            ForEach([30, 60, 120, 300, 600], id: \.self) { second in
                                Text("\(second) seconds").tag(TimeInterval(second))
                            }
                        }
                    }
                }

                Section {
                    HStack {
                        Image(systemName: "info.circle")
                            .font(.title2)
                        Text("Last popup shown: \(Date(timeIntervalSince1970: popupLastShow), formatter: dateFormatter)")
                    }
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                    .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(width: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Formatter for the date display
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    SettingsContentView()
}
