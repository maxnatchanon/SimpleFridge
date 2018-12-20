//
//  MainVC.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 17/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var fridgeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fridgeTableView.delegate = self
        fridgeTableView.dataSource = self
        fridgeTableView.rowHeight = 80
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
    }
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fridgeTableView.dequeueReusableCell(withIdentifier: "fridgeCell", for: indexPath) as! FridgeCell
        return cell
    }

}
