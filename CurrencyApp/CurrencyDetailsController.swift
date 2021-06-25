//
//  CurrencyDetailsController.swift
//  CurrencyApp
//
//  Created by Sebastian Niestój on 25/06/2021.
//

import UIKit

class CurrencyDetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var startDate = UIDatePicker()
    var endDate = UIDatePicker()
    var spinner = UIActivityIndicatorView()
    var startLabel = UILabel()
    var endLabel = UILabel()
    var tableView = UITableView()
    var cellId = "cellId"
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupConstraints()
    }
    
    func setupConstraints() {
        navigationItem.title = "Nazwa Waluty"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(startDate)
        view.addSubview(endDate)
        view.addSubview(startLabel)
        view.addSubview(endLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        startDate.translatesAutoresizingMaskIntoConstraints = false
        endDate.translatesAutoresizingMaskIntoConstraints = false
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        
        startLabel.text = "Start Date"
        endLabel.text = "End Date"
        startDate.datePickerMode = .date
        endDate.datePickerMode = .date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let date = dateFormatter.date(from: "2002-01-02")
        
        startDate.minimumDate = date
        endDate.minimumDate = date
        startDate.maximumDate = Date()
        endDate.maximumDate = Date()
        
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: cellId)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 600),
            tableView.bottomAnchor.constraint(equalTo: startLabel.topAnchor, constant: -20)
        ])
            
        NSLayoutConstraint.activate([
            startLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            startLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            startDate.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 20),
            startDate.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            startDate.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            endLabel.topAnchor.constraint(equalTo: startDate.bottomAnchor, constant: 40),
            endLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            endLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            endDate.topAnchor.constraint(equalTo: endLabel.bottomAnchor, constant: 20),
            endDate.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            endDate.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func refresh(_ sender: Any) {
        self.updateViewConstraints()
        self.refreshControl.endRefreshing()
        self.spinner.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
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
