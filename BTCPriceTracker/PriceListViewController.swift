//
//  PriceListViewController.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import UIKit

class PriceListViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var priceLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
  }
    
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }

}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension PriceListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()

    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    self.navigationController?.pushViewController(detailViewController, animated: true)

  }
  
  
}
