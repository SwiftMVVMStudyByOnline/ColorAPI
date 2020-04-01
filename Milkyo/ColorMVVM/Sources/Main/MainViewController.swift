//
//  ViewController.swift
//  Remove
//
//  Created by Seokho on 2020/03/09.
//  Copyright © 2020 Seokho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum Cell {
    static let colorCell = "\(ColorCell.self)"
}

class MainViewController: UIViewController {
    
    weak var tableView: UITableView?
    weak var indicator: UIActivityIndicatorView?
    weak var toolBar: MainToolBar!
    
    let disposeBag = DisposeBag()
    let viewModel: MainViewModelType
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ColorCellSection>(configureCell: { dataSource, tableView, indexPath, viewModel in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.colorCell, for: indexPath) as? ColorCell else { fatalError() }
        cell.viewModel = viewModel
        return cell
    })
    
    init(viewModel: MainViewModelType = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = ColorLists.background
        self.view = view
        
        let toolbar = MainToolBar()
        self.toolBar = toolbar
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let topAnchor = toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44)
        topAnchor.priority = .defaultHigh
        topAnchor.isActive = true
        
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView = tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        tableView.register(ColorCell.self, forCellReuseIdentifier: Cell.colorCell)
        tableView.delegate = self
        
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.backgroundColor = UIColor(white: 0.3, alpha: 0.8)
        indicator.layer.cornerRadius = 10
        indicator.clipsToBounds = true
        self.indicator = indicator
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 60),
            indicator.heightAnchor.constraint(equalToConstant: 60),
            indicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        self.navigationItem.title  = "색상 목록"
        self.bind()
        self.viewModel.input.fetchData()
    }
    
    func bind() {
        
        self.viewModel.output.color
            .drive(tableView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        self.toolBar.favoriteButton!.rx.tap
            .bind(onNext: viewModel.input.favoriteButtonPressed)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.isLoading
            .drive(onNext: { [weak self] in $0 ? self?.indicator?.startAnimating() : self?.indicator?.stopAnimating() })
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.isFavorite
            .drive(toolBar.favoriteButton!.rx.isSelected)
            .disposed(by: self.disposeBag)
        
    }
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? ColorCell {
            print(cell.viewModel?.output.color)
        }
    }
}
