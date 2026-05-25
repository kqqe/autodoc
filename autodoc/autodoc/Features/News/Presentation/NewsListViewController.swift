//
//  NewsListViewController.swift
//  autodoc
//
//  Created by Anatoliy on 19.05.2026.
//
import UIKit
import Combine

final class NewsListViewController: UIViewController {
    private let viewModel: NewsListViewModel
    private var layoutMode: NewsLayoutMode = .list
    private var items: [NewsItem] = []
    private var cancellables = Set<AnyCancellable>()

    private let modeControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Список", "Сетка"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: NewsLayoutFactory.makeLayout(mode: layoutMode))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.dataSource = self
        view.delegate = self
        view.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.reuseIdentifier)
        return view
    }()

    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новости"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground

        setupUI()
        bind()

        modeControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        viewModel.loadInitial()
    }
}


// MARK: UICollectionViewDataSource
extension NewsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewsCell.reuseIdentifier,
            for: indexPath
        ) as! NewsCell

        let item = items[indexPath.item]

        switch layoutMode {
        case .list:
            cell.configureList(with: item)
        case .grid:
            cell.configureGrid(with: item)
        }
        return cell
    }
}

// MARK: UICollectionViewDataSource
extension NewsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        viewModel.select(item)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard indexPath.item == items.count - 1 else { return }
        guard let item = items.last else { return }
        viewModel.loadNextPageIfNeeded(currentItem: item)
    }
}

// MARK: Private
private extension NewsListViewController {
        func bind() {
            viewModel.$items
                .receive(on: DispatchQueue.main)
                .sink { [weak self] items in
                    guard let self else { return }
                    self.items = items
                    self.collectionView.reloadData()
                }
                .store(in: &cancellables)

            viewModel.$isLoading
                .receive(on: DispatchQueue.main)
                .sink { isLoading in
                    print("loading:", isLoading)
                }
                .store(in: &cancellables)
        }

        @objc func modeChanged() {
            layoutMode = modeControl.selectedSegmentIndex == 0 ? .list : .grid
            collectionView.setCollectionViewLayout(
                NewsLayoutFactory.makeLayout(mode: layoutMode),
                animated: true
            )
            collectionView.reloadData()
        }
}

// MARK: SetupUI
private extension NewsListViewController {
    private func setupUI() {
        view.addSubview(modeControl)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            modeControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            modeControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modeControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: modeControl.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
