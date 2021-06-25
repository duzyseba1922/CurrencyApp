//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Sebastian Niestój on 24/06/2021.
//

import UIKit

class CurrencyListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableTypeSwitcher = UISegmentedControl()
    let refreshControl = UIRefreshControl()
    var tableView = UITableView()
    var cellId = "cellId"
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        tableTypeSwitcher.translatesAutoresizingMaskIntoConstraints = false
        let items = ["A", "B", "C"]
        tableTypeSwitcher = UISegmentedControl(items: items)
        tableTypeSwitcher.selectedSegmentIndex = 0
        let frame = UIScreen.main.bounds
        tableTypeSwitcher.frame = CGRect(x: frame.minX + 10, y: frame.minY + 50,
                                width: frame.width - 20, height: frame.height * 0.1)
        tableTypeSwitcher.layer.cornerRadius = 5
        tableTypeSwitcher.backgroundColor = UIColor.white
        tableTypeSwitcher.tintColor = UIColor.gray
        self.view.addSubview(tableTypeSwitcher)
        
        NSLayoutConstraint.activate([
            tableTypeSwitcher.topAnchor.constraint(equalTo: view.topAnchor),
            tableTypeSwitcher.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableTypeSwitcher.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableTypeSwitcher.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: cellId)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc func refresh(_ sender: Any) {
        self.updateViewConstraints()
        self.refreshControl.endRefreshing()
        self.spinner.stopAnimating()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CurrencyDetailsController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! CurrencyCell
        cell.date.text = "24.06.21"
        cell.currencyName.text = "Euro"
        cell.currencyCode.text = "EUR"
        cell.averageValue.text = "4,53"
        return cell
    }
}

