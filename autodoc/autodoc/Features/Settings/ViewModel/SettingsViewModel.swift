//
//  SettingsViewModel.swift
//  autodoc
//
//  Created by Anatoliy on 25.05.2026.
//

import Foundation
import UIKit
import Combine

final class SettingsViewModel {
    @Published var isPagination: Bool
    @Published var isHaptic: Bool
    @Published var isAnalytics: Bool
    @Published var isDarkMode: Bool
    
    private let settingsService: SettingsService
    private var cancellables = Set<AnyCancellable>()
    
    init(settingsService: SettingsService) {
        self.settingsService = settingsService
        
        self.isPagination = settingsService.isPaginationEnabled
        self.isHaptic = settingsService.isHapticEnabled
        self.isAnalytics = settingsService.isAnalyticsEnabled
        self.isDarkMode = settingsService.appTheme == .dark
        
        settingsService.$isPaginationEnabled
            .sink { [weak self] newValue in
                self?.isPagination = newValue
            }
            .store(in: &cancellables)
        
        settingsService.$isHapticEnabled
            .sink { [weak self] newValue in
                self?.isHaptic = newValue
            }
            .store(in: &cancellables)
        
        settingsService.$isAnalyticsEnabled
            .sink { [weak self] newValue in
                self?.isAnalytics = newValue
            }
            .store(in: &cancellables)
        
        settingsService.$appTheme
            .map { $0 == .dark }
            .sink { [weak self] isDark in
                self?.isDarkMode = isDark
            }
            .store(in: &cancellables)
    }
    
    func updatePagination(enabled: Bool) {
        settingsService.updatePagination(enabled: enabled)
    }
    
    func updateHaptic(enabled: Bool) {
        settingsService.updateHaptic(enabled: enabled)
    }
    
    func updateAnalytics(enabled: Bool) {
        settingsService.updateAnalytics(enabled: enabled)
    }
    
    func updateTheme(isDark: Bool) {
        let theme: AppTheme = isDark ? .dark : .system
        settingsService.updateTheme(theme: theme)
    }
}
