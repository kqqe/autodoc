//
//  PlaceholderViewController.swift
//  autodoc
//
//  Created by Anatoliy on 25.05.2026.
//

import UIKit

final class PlaceholderViewController: UIViewController {
    private let titleText: String
    private let color: UIColor

    init(titleText: String, color: UIColor) {
        self.titleText = titleText
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
        title = titleText
    }
}
