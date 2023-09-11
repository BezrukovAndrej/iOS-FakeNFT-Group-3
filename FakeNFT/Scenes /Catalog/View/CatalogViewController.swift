import UIKit

final class CatalogViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private let viewModel: CatalogViewModelProtocol
    private var alertService: AlertServiceProtocol?
    private var alertModel: AlertModel?

    init(viewModel: CatalogViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupNavigationItem()
        setupView()
        setupConstraints()

        bind()
        viewModel.initialize()

        initializeAlertService()
    }

    private func bind() {
        viewModel.collectionsObserve.bind(action: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    private func initializeAlertService() {
        alertService = AlertService(viewController: self)
        alertModel = AlertModel(
            title: NSLocalizedString("sort", comment: "Sorting alert title"),
            message: nil,
            style: .actionSheet,
            actions: [
                AlertActionModel(
                    title: NSLocalizedString("sort.byName", comment: "Sorting alert by name button"),
                    style: .default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.viewModel.sort {
                            $0.name < $1.name
                        }
                    }),
                AlertActionModel(
                    title: NSLocalizedString("sort.byAmount", comment: "Sorting alert by amount button"),
                    style: .default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.viewModel.sort {
                            $0.nfts.count > $1.nfts.count
                        }
                    }),
                AlertActionModel(
                    title: NSLocalizedString("close", comment: "Sorting alert close button"),
                    style: .cancel,
                    handler: nil)

            ],
            textFieldPlaceholder: nil)
    }

    @objc
    private func sortButtonTapped() {
        guard let alertService = alertService,
            let alertModel = alertModel else {
            return
        }
        alertService.showAlert(model: alertModel)
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let collection = viewModel.collection(at: indexPath) else {
            return UITableViewCell()
        }
        let cell: CatalogCell = tableView.dequeueReusableCell()
        cell.viewModel = viewModel.getCellViewModel(for: collection)
        cell.selectedBackgroundView = UIView()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }

}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let collection = viewModel.collection(at: indexPath) else {
            return
        }

        let vc = UINavigationController(
            rootViewController: NFTCollectionViewController(
                viewModel: NFTCollectionViewModel(with: collection)))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - UI
private extension CatalogViewController {
    func setupNavigationItem() {
        let barItem = UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped))
        barItem.tintColor = .unBlack
        navigationItem.rightBarButtonItem = barItem
    }

    func setupView() {
        view.addViewWithNoTAMIC(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
