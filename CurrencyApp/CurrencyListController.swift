//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Sebastian Niestój on 24/06/2021.
//

import UIKit
import SwiftyJSON

class CurrencyListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableTypeSwitcher = UISegmentedControl()
    let refreshControl = UIRefreshControl()
    var tableView = UITableView()
    var cellId = "cellId"
    var spinner = UIActivityIndicatorView()
    var jsonData = JSON()
    var chosenTableType = "A"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(type: chosenTableType)
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
        tableTypeSwitcher.addTarget(self, action: #selector(changeTableType(_:)), for: .valueChanged)
        
        view.addSubview(tableTypeSwitcher)
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
        
    }
    
    @objc func changeTableType(_ sender: UISegmentedControl) {
        self.spinner.startAnimating()
        switch sender.selectedSegmentIndex {
        case 1:
            chosenTableType = "B"
        case 2:
            chosenTableType = "C"
        default:
            chosenTableType = "A"
        }
        getData(type: chosenTableType)
        self.spinner.stopAnimating()
    }
    
    @objc func refresh(_ sender: Any) {
        getData(type: chosenTableType)
        self.updateViewConstraints()
        self.refreshControl.endRefreshing()
        self.spinner.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CurrencyDetailsController()
        vc.passedName = jsonData[0]["rates"][indexPath.row]["currency"].stringValue
        vc.passedCode = jsonData[0]["rates"][indexPath.row]["code"].stringValue
        vc.passedTableType = chosenTableType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData[0]["rates"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! CurrencyCell
        if(chosenTableType == "C") {
            cell.date.text = jsonData[0]["tradingDate"].stringValue
        } else {
            cell.date.text = jsonData[0]["effectiveDate"].stringValue
        }
        cell.currencyName.text = jsonData[0]["rates"][indexPath.row]["currency"].stringValue
        cell.currencyCode.text = jsonData[0]["rates"][indexPath.row]["code"].stringValue
        if(chosenTableType == "C") {
            cell.averageValue.text = String(format: "%.4f", jsonData[0]["rates"][indexPath.row]["bid"].floatValue)
        } else {
            cell.averageValue.text = String(format: "%.4f", jsonData[0]["rates"][indexPath.row]["mid"].floatValue)
        }
        return cell
    }
    
    func getData(type: String) {
        let task = URLSession.shared.dataTask(with: URL(string: "http://api.nbp.pl/api/exchangerates/tables/\(type)/")!) { data, response, error in
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

