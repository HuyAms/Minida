//
//  HomeVC.swift
//  Project_Ios
//
//  Created by Dat Truong on 18/04/2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit
import FoldingCell

protocol HomeVCProtocol: class {
    
    func showLoading()
    
    func hideLoading()
    
    func onShowError(error: AppError)
    
    func onGetAvailableItemsSuccess(homeItems: [ItemHome])

}

class HomeVC: UIViewController, HomeVCProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let kCloseCellHeight: CGFloat = 145
    let kOpenCellHeight: CGFloat = 390
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    var items = [ItemHome]()
    
    var presenter: HomePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        presenter = HomePresenter(view: self)
        presenter?.performGetAvailableItems()
        setup()
    }
    
    private func setup() {
        //Table view
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Searchbar
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.textColor = UIColor.white
    }
    
    //MARK: Protocols
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
    
    func onShowError(error: AppError) {
        print("this is an onShowError appError: \(error)")
    }
    
    func onGetAvailableItemsSuccess(homeItems: [ItemHome]) {
        items = homeItems
        tableView.reloadData()
    }
}

// MARK: - TableView
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as? HomeItemCell else {
            return UITableViewCell()
        }
        let homeItem = items[indexPath.row]
        cell.config(itemHome: homeItem)
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as HomeItemCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }

    }

}

