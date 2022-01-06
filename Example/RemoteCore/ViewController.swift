//
//  ViewController.swift
//  RemoteCore
//
//  Created by dalygbs on 01/05/2022.
//  Copyright (c) 2022 dalygbs. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DemoClass().test()
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
