//
//  CurrencyDetailsController.swift
//  CurrencyApp
//
//  Created by Sebastian Niestój on 25/06/2021.
//

import UIKit
import SwiftyJSON

class CurrencyDetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var startDate = UIDatePicker()
    var endDate = UIDatePicker()
    var spinner = UIActivityIndicatorView()
    var startLabel = UILabel()
    var endLabel = UILabel()
    var tableView = UITableView()
    var refreshControl = UIRefreshControl()
    
    var cellId = "cellId"
    var passedName = String()
    var passedCode = String()
    var passedTableType = String()
    var jsonData = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupConstraints()
        getData(type: passedTableType)
    }
    
    func setupConstraints() {
        navigationItem.title = passedName
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
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.date(from: "2002-01-02")
        
        startDate.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        endDate.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        startDate.date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        endDate.date = Date()
        startDate.minimumDate = date
        endDate.minimumDate = date
        startDate.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        endDate.maximumDate = Date()
        
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: cellId)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 600),
            tableView.bottomAnchor.constraint(equalTo: startLabel.topAnchor, constant: -20)
        ])
            
        NSLayoutConstraint.activate([
            startLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            startDate.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 20),
            startDate.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            endLabel.topAnchor.constraint(equalTo: startDate.bottomAnchor, constant: 40),
            endLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            endDate.topAnchor.constraint(equalTo: endLabel.bottomAnchor, constant: 20),
            endDate.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        if (startDate.date > endDate.date) {
            endDate.date = Date()
            getData(type: passedTableType)
        } else {
            getData(type: passedTableType)
        }
        
    }
    
    @objc func refresh(_ sender: Any) {
        getData(type: passedTableType)
        self.updateViewConstraints()
        self.refreshControl.endRefreshing()
        self.spinner.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData["rates"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! CurrencyCell
        cell.date.text = jsonData["rates"][indexPath.row]["effectiveDate"].stringValue
        cell.currencyName.text = passedName
        cell.currencyCode.text = passedCode
        if(passedTableType == "C") {
            cell.averageValue.text = String(format: "%.4f", jsonData["rates"][indexPath.row]["bid"].floatValue)
        } else {
            cell.averageValue.text = String(format: "%.4f", jsonData["rates"][indexPath.row]["mid"].floatValue)
        }
        return cell
    }
    
    func getData(type: String) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "YYYY-MM-dd"
        let task = URLSession.shared.dataTask(with: URL(string: "http://api.nbp.pl/api/exchangerates/rates/\(type)/\(passedCode)/\(timeFormatter.string(from: startDate.date))/\(timeFormatter.string(from: endDate.date))/")!) { data, response, error in
            guard let data=data else { return }
            do {
                self.jsonData = try JSON(data: data)
                DispatchQueue.main.async {
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
