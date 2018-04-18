//
//  MenuVC.swift
//  Project_Ios
//
//  Created by iosadmin on 15.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import SideMenu

protocol MenuVCDelegate: class {
    
    func menu(_ menu: MenuVC, didSelectItemAt index: Int)
    func menuDidCancel(_ menu: MenuVC)
}

class MenuVC: UITableViewController {
    
    weak var delegate: MenuVCDelegate?
    var selectedItem = 0
   
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        delegate?.menuDidCancel(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let indexPath = IndexPath(row: selectedItem, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//MARK: Menu protocol
extension MenuVC: Menu {
    
    var menuItems: [UIView] {
        return [tableView.tableHeaderView!] + tableView.visibleCells
    }
}

extension MenuVC {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath == tableView.indexPathForSelectedRow ? nil : indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.menu(self, didSelectItemAt: indexPath.row)
    }
}

