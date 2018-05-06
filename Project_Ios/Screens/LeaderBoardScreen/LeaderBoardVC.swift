//
//  LeaderBoardVC.swift
//  Project_Ios
//
//  Created by iosdev on 28.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

protocol LeaderBoardVCProtocol: class {
    
    func showLoading()
    
    func hideLoading()
    
    func showTopUserView()
    
    func hideTopUserView()
    
    func showBadgeView()
    
    func hideBadgeView()
    
    func onGetLeaderBoardUsersSuccess(users: [User])
    
    func onShowError(error: AppError)
    
}

class LeaderBoardVC: UIViewController, LeaderBoardVCProtocol {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var topUsersView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var presenter: LeaderBoardPresenterProtocol?
    var topUsers = [User]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = UIColor.appLightColor
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter = LeaderBoardPresenter(view: self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getLeaderBoardUsers()
    }

    @IBAction func segmentDidChange(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            showTopUserView()
            hideBadgeView()
            presenter?.getLeaderBoardUsers()
        case 1:
            showBadgeView()
            hideTopUserView()
        default:
            break
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
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
    
    func showTopUserView() {
        topUsersView.isHidden = false
    }
    
    func hideTopUserView() {
        topUsersView.isHidden = true
    }
    
    func showBadgeView() {
        badgeView.isHidden = false
    }
    
    func hideBadgeView() {
        badgeView.isHidden = true
    }
    
    func onGetLeaderBoardUsersSuccess(users: [User]) {
        topUsers = users
        tableView.reloadData()
    }
    
    func onShowError(error: AppError) {
        showError(message: error.description)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.getLeaderBoardUsers()
    }
    
    func setupUI() {
        titleLbl.text = "Leaderboard".localized
        segmentControl.setTitle("Top 10".localized, forSegmentAt: 0)
        segmentControl.setTitle("Badge".localized, forSegmentAt: 1)
    }
}

extension LeaderBoardVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppTableCell.leaderBoardCell.identifier) as? LeaderBoardCell else {
            return UITableViewCell()
        }
        let index = indexPath.row + 1
        let user = topUsers[indexPath.row]
        cell.config(index: index, user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = topUsers[indexPath.row]
        guard let profileVC = storyboard?.instantiateViewController(withIdentifier: AppStoryBoard.profileVC.identifier) as? ProfileVC else {return}
        profileVC.profileLoadState = .userProfile
        profileVC.userId = user._id
        present(profileVC, animated: true, completion: nil)
    }
}
