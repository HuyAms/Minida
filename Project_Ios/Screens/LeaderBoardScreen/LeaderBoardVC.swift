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
    
    var presenter: LeaderBoardPresenterProtocol?
    var topUsers = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LeaderBoardPresenter(view: self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
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
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
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
