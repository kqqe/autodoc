//
//  SettingsService.swift
//  autodoc
//
//  Created by Anatoliy on 25.05.2026.
//

import Combine
import UIKit

final class SettingsService {
    @Published private(set) var isPaginationEnabled: Bool
    @Published private(set) var isHapticEnabled: Bool
    @Published private(set) var isAnalyticsEnabled: Bool
    @Published private(set) var appTheme: AppTheme
    
    init() {
        self.isPaginationEnabled = UserDefaults.standard.bool(forKey: "paginationEnabled")
        self.isHapticEnabled = UserDefaults.standard.bool(forKey: "hapticEnabled")
        self.isAnalyticsEnabled = UserDefaults.standard.bool(forKey: "analyticsEnabled")
        self.appTheme = UserDefaults.standard.appTheme
    }
    
    func updatePagination(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "paginationEnabled")
        isPaginationEnabled = enabled
    }
    
    func updateHaptic(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "hapticEnabled")
        isHapticEnabled = enabled
    }
    
    func updateAnalytics(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "analyticsEnabled")
        isAnalyticsEnabled = enabled
    }
    
    func updateTheme(theme: AppTheme) {
        UserDefaults.standard.appTheme = theme
        appTheme = theme
    }
}
