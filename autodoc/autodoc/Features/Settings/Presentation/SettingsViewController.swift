//
//  SettingsViewController.swift
//  autodoc
//
//  Created by Anatoliy on 25.05.2026.
//

import UIKit
import Combine

final class SettingsViewController: UIViewController {
    private let darkModeSwitch = UISwitch()
    private let hapticSwitch = UISwitch()
    private let analyticsSwitch = UISwitch()
    private let paginationSwitch = UISwitch()
    
    private let viewModel: SettingsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        view.backgroundColor = .systemBackground
        
        setupUI()
        bind()
    }
    
    private func bind() {
        viewModel.$isPagination
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPagination in
                guard self?.paginationSwitch.isOn != isPagination else { return }
                self?.paginationSwitch.isOn = isPagination
            }
            .store(in: &cancellables)
        
        viewModel.$isHaptic
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isHaptic in
                guard self?.hapticSwitch.isOn != isHaptic else { return }
                self?.hapticSwitch.isOn = isHaptic
            }
            .store(in: &cancellables)
        
        viewModel.$isAnalytics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAnalytics in
                guard self?.analyticsSwitch.isOn != isAnalytics else { return }
                self?.analyticsSwitch.isOn = isAnalytics
            }
            .store(in: &cancellables)
        
        viewModel.$isDarkMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isDarkMode in
                guard self?.darkModeSwitch.isOn != isDarkMode else { return }
                self?.darkModeSwitch.isOn = isDarkMode
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        let darkRow = makeRow(title: "Темная тема", control: darkModeSwitch)
        let hapticRow = makeRow(title: "Тактильный отклик", control: hapticSwitch)
        let analyticsRow = makeRow(title: "Аналитика", control: analyticsSwitch)
        let paginationRow = makeRow(title: "Пагинация", control: paginationSwitch)
        
        [darkRow, hapticRow, analyticsRow, paginationRow].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        darkModeSwitch.addTarget(self, action: #selector(darkModeChanged), for: .valueChanged)
        hapticSwitch.addTarget(self, action: #selector(hapticChanged), for: .valueChanged)
        analyticsSwitch.addTarget(self, action: #selector(analyticsChanged), for: .valueChanged)
        paginationSwitch.addTarget(self, action: #selector(paginationChanged), for: .valueChanged)
    }
    
    private func makeRow(title: String, control: UISwitch) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 17)
        
        let row = UIStackView(arrangedSubviews: [label, UIView(), control])
        row.axis = .horizontal
        row.alignment = .center
        row.translatesAutoresizingMaskIntoConstraints = false
        return row
    }
    
    @objc private func darkModeChanged() {
        viewModel.updateTheme(isDark: darkModeSwitch.isOn)
        let theme: AppTheme = darkModeSwitch.isOn ? .dark : .system
        view.window?.overrideUserInterfaceStyle = theme.style
    }
    
    @objc private func hapticChanged() {
        viewModel.updateHaptic(enabled: hapticSwitch.isOn)
    }
    
    @objc private func analyticsChanged() {
        viewModel.updateAnalytics(enabled: analyticsSwitch.isOn)
    }
    
    @objc private func paginationChanged() {
        viewModel.updatePagination(enabled: paginationSwitch.isOn)
    }
}
