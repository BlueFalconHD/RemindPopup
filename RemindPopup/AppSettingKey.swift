//
//  AppSettingKey.swift
//  MakeGoodChoices
//
//  Created by Hayes Dombroski on 6/19/24.
//

import Foundation

enum AppSettingKey: String {
    case applicationEnabled = "application.enabled"
    case applicationHasOpenedBefore = "application.hasOpenedBefore"
    case popupQuoteToShow = "popup.quoteToShow"
    case popupFadeInTime = "popup.fadeTime.in"
    case popupSustainTime = "popup.sustainTime"
    case popupFadeOutTime = "popup.fadeTime.out"
    case popupEnableCooldown = "popup.enableCooldown"
    case popupCooldownTime = "popup.cooldownTime"
    case popupLastShow = "popup.lastShow"
}

struct AppSettings {
    var applicationEnabled: Bool {
        return UserDefaults.standard.bool(forKey: AppSettingKey.applicationEnabled.rawValue)
    }
    
    var applicationHasOpenedBefore: Bool {
        return UserDefaults.standard.bool(forKey: AppSettingKey.applicationHasOpenedBefore.rawValue)
    }

    var popupQuoteToShow: String {
        return UserDefaults.standard.string(forKey: AppSettingKey.popupQuoteToShow.rawValue) ?? "Make good choices"
    }

    var popupFadeInTime: TimeInterval {
        return UserDefaults.standard.double(forKey: AppSettingKey.popupFadeInTime.rawValue)
    }

    var popupFadeOutTime: TimeInterval {
        return UserDefaults.standard.double(forKey: AppSettingKey.popupFadeOutTime.rawValue)
    }

    var popupSustainTime: TimeInterval {
        return UserDefaults.standard.double(forKey: AppSettingKey.popupSustainTime.rawValue)
    }

    var enableCooldown: Bool {
        return UserDefaults.standard.bool(forKey: AppSettingKey.popupEnableCooldown.rawValue)
    }

    var popupCooldownTime: TimeInterval {
        return UserDefaults.standard.double(forKey: AppSettingKey.popupCooldownTime.rawValue)
    }

    var popupLastShow: TimeInterval {
        return UserDefaults.standard.double(forKey: AppSettingKey.popupLastShow.rawValue)
    }
    
    
    func setDefaultOptions() {
        UserDefaults.standard.set(true, forKey: AppSettingKey.applicationEnabled.rawValue)
        UserDefaults.standard.set("Make good choices", forKey: AppSettingKey.popupQuoteToShow.rawValue)
        UserDefaults.standard.set(1.0, forKey: AppSettingKey.popupFadeInTime.rawValue)
        UserDefaults.standard.set(1.0, forKey: AppSettingKey.popupFadeOutTime.rawValue)
        UserDefaults.standard.set(3.0, forKey: AppSettingKey.popupSustainTime.rawValue)
        UserDefaults.standard.set(false, forKey: AppSettingKey.popupEnableCooldown.rawValue)
        UserDefaults.standard.set(120.0, forKey: AppSettingKey.popupCooldownTime.rawValue)
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: AppSettingKey.popupLastShow.rawValue)
    }
}
