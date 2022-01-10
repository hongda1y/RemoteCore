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
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                self.pushFetchItemVC()
                break
            default:
                break
            }
        }
    }
    
    
    func pushFetchItemVC(){
        let vc = ListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
