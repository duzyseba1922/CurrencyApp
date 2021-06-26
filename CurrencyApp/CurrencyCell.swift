import UIKit

class CurrencyCell: UITableViewCell {
    
    var date = UILabel()
    var currencyName = UILabel()
    var currencyCode = UILabel()
    var averageValue = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(date)
        contentView.addSubview(currencyName)
        contentView.addSubview(currencyCode)
        contentView.addSubview(averageValue)
        
        date.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            date.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            date.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        currencyName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            currencyName.leadingAnchor.constraint(equalTo: self.date.trailingAnchor, constant: 10),
            currencyName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            currencyName.widthAnchor.constraint(equalToConstant: self.frame.width/3)
        ])
        currencyCode.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyCode.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            currencyCode.trailingAnchor.constraint(equalTo: self.averageValue.leadingAnchor, constant: -10),
            currencyCode.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        averageValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            averageValue.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            averageValue.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            averageValue.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        print(contentView.frame.width)
        print(self.frame.width)
    }
}
