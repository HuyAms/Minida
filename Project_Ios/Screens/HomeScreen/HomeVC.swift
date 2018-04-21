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
    
    func onShowFilteredItems(homeItems: [ItemHome])
    
    func onShowFilteringNoResult()

}

class HomeVC: UIViewController, HomeVCProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notFoundLbl: UILabel!
    
    let kCloseCellHeight: CGFloat = 145
    let kOpenCellHeight: CGFloat = 390
    var cellHeights: [CGFloat] = []
    var items = [ItemHome]()
    
    var filteredItems = [ItemHome]()
    var searchActive : Bool = false
    
    var presenter: HomePresenterProtocol?
    
    var chosenCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        presenter = HomePresenter(view: self)

        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let category = chosenCategory {
            switch category {
            case .all:
                presenter?.performGetAvailableItems()
            default:
                presenter?.performgGetItemsByCategory(category: category)
            }
        } else {
            print("GET all")
            presenter?.performGetAvailableItems()
        }
    }
    
    private func setupSearchBar() {
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.textColor = UIColor.white
    }
    
    private func setupTable(kRowsCount: Int) {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func goToCategoryScreen() {
        guard let categoryVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.categoryVC.identifier) as? CategoryVC else {return}
        present(categoryVC, animated: true, completion: nil)
        categoryVC.delegate = self
    }
    
    //MARK: Actions
    @IBAction func categoryBtnWasPressed(_ sender: Any) {
        goToCategoryScreen()
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: Protocols
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
    
    func onShowError(error: AppError) {
        showError(message: error.description)
    }
    
    func onGetAvailableItemsSuccess(homeItems: [ItemHome]) {
        if homeItems.count > 0 {
            tableView.isHidden = false
            setupTable(kRowsCount: homeItems.count)
            items = homeItems
            notFoundLbl.isHidden = true
            tableView.reloadData()
        } else {
            tableView.isHidden = true
            notFoundLbl.isHidden = false
        }
      
    }
    
    func onShowFilteredItems(homeItems: [ItemHome]) {
        tableView.isHidden = false
        notFoundLbl.isHidden = true
        setupTable(kRowsCount: homeItems.count)
        filteredItems = homeItems
        tableView.reloadData()
    }
    
    func onShowFilteringNoResult() {
        tableView.isHidden = true
        notFoundLbl.isHidden = false
    }
    
}

// MARK: - TableView
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredItems.count
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppTableCell.foldingCell.identifier, for: indexPath) as? HomeItemCell else {
            return UITableViewCell()
        }
        
        let homeItem: ItemHome
        
        if isFiltering() {
            homeItem = filteredItems[indexPath.row]
        } else {
            homeItem = items[indexPath.row]
        }
        
        cell.config(itemHome: homeItem)
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  cellHeights[indexPath.row]
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

extension HomeVC: UISearchBarDelegate {
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        return searchActive && !searchBarIsEmpty()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.filterContentForSearchText(searchText, items: items)

    }
}

extension HomeVC: CategoryDelegate {
    func setCategory(category: Category) {
        chosenCategory = category
    }
}
