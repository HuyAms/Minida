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
    
    func onGetAvailableItemsSuccess(homeItems: [Item])
    
    func onShowFilteredItems(homeItems: [Item])
    
    func onShowFilteringNoResult()
    
    func onBuyItemSuccess(order: Order)

}

class HomeVC: UIViewController, HomeVCProtocol {
 
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notFoundLbl: UILabel!
    @IBOutlet weak var chooseCategoryBtn: UIButton!
    
    
    let kCloseCellHeight: CGFloat = 145
    let kOpenCellHeight: CGFloat = 390
    var cellHeights: [CGFloat] = []
    var items = [Item]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = UIColor.appLightColor
        
        return refreshControl
    }()
    
    var filteredItems = [Item]()
    var searchActive : Bool = false
    
    var presenter: HomePresenterProtocol?
    
    var chosenCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(self.refreshControl)

        searchBar.delegate = self
        
        presenter = HomePresenter(view: self)

        setupSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems()
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
    
    private func goToReceiptScreen(order: Order) {
        guard let receiptVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.receiptVC.identifier) as? ReceiptVC else {return}
        receiptVC.order = order
        present(receiptVC, animated: true, completion: nil)
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
        if !refreshControl.isRefreshing {
            showLoadingIndicator()
        }
    }
    
    func hideLoading() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        } else {
            hideLoadingIndicator()
        }
    }
    
    func onShowError(error: AppError) {
        showError(message: error.description)
    }
    
    func onGetAvailableItemsSuccess(homeItems: [Item]) {
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
    
    func onShowFilteredItems(homeItems: [Item]) {
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
    
    func onBuyItemSuccess(order: Order) {
        goToReceiptScreen(order: order)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadItems()
    }
    
    func loadItems() {
        if let category = chosenCategory {
            switch category {
            case .all:
                presenter?.performGetAvailableItems()
                chooseCategoryBtn.setImage(UIImage.getAllIconWhite(), for: .normal)
            default:
                presenter?.performgGetItemsByCategory(category: category)
                switch category {
                case .accessories:
                    chooseCategoryBtn.setImage(UIImage.getAccessoriesIconWhite(), for: .normal)
                case .clothing:
                    chooseCategoryBtn.setImage(UIImage.getClothingIconWhite(), for: .normal)
                case .devices:
                    chooseCategoryBtn.setImage(UIImage.getDevicesIconWhite(), for: .normal)
                case .free:
                    chooseCategoryBtn.setImage(UIImage.getFreeIconWhite(), for: .normal)
                case .homewares:
                    chooseCategoryBtn.setImage(UIImage.getHomewaresIconWhite(), for: .normal)
                case .vehicles:
                    chooseCategoryBtn.setImage(UIImage.getVehiclesIconWhite(), for: .normal)
                case .others:
                    chooseCategoryBtn.setImage(UIImage.getOthersIconWhite(), for: .normal)
                default:
                    print("Error with getting the right category. You should not be here!")
                }
            }
        } else {
            print("GET all")
            presenter?.performGetAvailableItems()
            
        }
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
        
        let homeItem: Item
        
        if isFiltering() {
            homeItem = filteredItems[indexPath.row]
        } else {
            homeItem = items[indexPath.row]
        }
        let itemId = homeItem._id

        cell.config(itemHome: homeItem)
        
        cell.onBuyButtonTapped = { [weak self]() in
            print("buy button was tapped at \(indexPath.row)")
            
            let alertViewController = UIAlertController(title: "Buy", message: "Do you want to buy this item?", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self?.presenter?.performBuyItem(itemId: itemId)
            }
            let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertViewController.addAction(okAction)
            alertViewController.addAction(cancleAction)
            self?.present(alertViewController, animated: true)
            
        }
        
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
