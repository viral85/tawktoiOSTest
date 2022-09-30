//
//  GithubUsersListVC.swift
//  tawkiOSTest
//
//  Created by Apple on 21/09/22.
//

import UIKit
import Reachability

class GithubUsersListVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!

    // MARK: - Class Variable
    let githubUsersViewModel = GithubUsersListVM()
    
    fileprivate var isAPICalled : Bool = Bool()
    
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Hide No Data Found Label
        self.lblNoData.isHidden = true
        
        /// REGISTER TABLEVIEW CELL
        self.tblView.register(UINib(nibName: AppStrings.normalCell, bundle: nil), forCellReuseIdentifier: AppStrings.normalCell)
        self.tblView.register(UINib(nibName: AppStrings.notesCell, bundle: nil), forCellReuseIdentifier: AppStrings.notesCell)
        self.tblView.register(UINib(nibName: AppStrings.invertCell, bundle: nil), forCellReuseIdentifier: AppStrings.invertCell)

        /// CALL CUSTOM METHOD
        setupView()
        
        // Notification For Reload Data
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .reloadUserList, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableReloadData()
    }
    
    // MARK: - Custom Method
    private func setupView(){
        
        self.title = "Github" /// Navigation title
        
        self.githubUsersViewModel.fetchData { value in
            self.internetRechability()
        }
        
        self.setupViewModelObserver()
        
        UIApplication.setTopMostViewController()
                
        viewSearch.layer.cornerRadius = viewSearch.frame.size.height / 2
    }
    
    /// Check Internet Rechability
    private func internetRechability(){
        reachability.whenReachable = { reachability in
            // CALL USER LIST API
            if self.githubUsersViewModel.arrUsers.count == 0{
                self.githubUsersViewModel.CallGithubUserListAPI()
            }
        }
        reachability.whenUnreachable = { _ in
            self.showAlert(strMessage: AppStrings.noInternetConnection)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func reloadData(){
        self.githubUsersViewModel.fetchData { value in }
    }
    
    func tableReloadData(){
        UIView.transition(with: tblView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.tblView.reloadData()}, completion: nil)
    }
}

//--------------------------------------------------------------------------------------
// MARK: - UITableViewDataSource & UITableViewDelegate Methods
//--------------------------------------------------------------------------------------
extension GithubUsersListVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.githubUsersViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userDetails = self.githubUsersViewModel.cellForItemAt(At: indexPath)
        
        if indexPath.row % 4 == 0 && indexPath.row != 0{
            let cell = self.tblView.dequeueReusableCell(withIdentifier: AppStrings.invertCell) as? InvertedCell
            cell?.configureData(userData: userDetails)
            return cell ?? InvertedCell()
        }
        
        if userDetails.notes?.count ?? 0 > 0{
            let cell = self.tblView.dequeueReusableCell(withIdentifier: AppStrings.notesCell) as? UserNotesCell
            cell?.configureData(userData: userDetails)
            return cell ?? UserNotesCell()
        }
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: AppStrings.normalCell) as? UserNormalCell
        cell?.configureData(userData: userDetails)
        return cell ?? UserNormalCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetails = self.githubUsersViewModel.cellForItemAt(At: indexPath)
        var model = UserDetailsModel()
        model.login = userDetails.login
        model.avatarURL = userDetails.avatarURL
        model.notes = userDetails.notes
        model.name = userDetails.login
        model.id = userDetails.id
        model.followers = userDetails.followers
        model.following = userDetails.following
        self.navigateTo(self.instantiateGithubUserDetailsController(userData: model, userName: userDetails.login ?? ""))
    }
}

//--------------------------------------------------------------------------------------
// MARK: - UIScrollViewDelegate Methods
//--------------------------------------------------------------------------------------
extension GithubUsersListVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if githubUsersViewModel.arrTemp.count > 0{return}
        
        let currentOffset : CGFloat = scrollView.contentOffset.y
        let maximumOffset : CGFloat = scrollView.contentSize.height - scrollView.frame.size.height + 20
        
        if maximumOffset - currentOffset <= 1 {
            if self.isAPICalled {
                self.isAPICalled = false
                self.githubUsersViewModel.user_id = self.githubUsersViewModel.arrUsers[self.githubUsersViewModel.arrUsers.count - 1].id ?? 0
                self.githubUsersViewModel.CallGithubUserListAPI()
            }
        }
    }
}

//----------------------------------------------------------------------------
// MARK: - UITextFieldDelegate
//----------------------------------------------------------------------------
extension GithubUsersListVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count > 0{
            githubUsersViewModel.arrTemp = githubUsersViewModel.arrUsers.filter{  ($0.login == updatedText || ((($0.login ?? "").contains(updatedText))) || $0.notes == updatedText || ((($0.notes ?? "").contains(updatedText)))) }
            self.tblView.isHidden = !(githubUsersViewModel.arrTemp.count > 0)
        }else{
            self.tblView.isHidden = false
            githubUsersViewModel.arrTemp.removeAll()
        }
        self.tableReloadData()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.githubUsersViewModel.arrTemp.removeAll()
        self.tblView.isHidden = false
        self.tableReloadData()
        return true
    }
    
}


//----------------------------------------------------------------------------
// MARK: - SetupViewModel Observer
//----------------------------------------------------------------------------
extension GithubUsersListVC {
    /**
     Setup all view model observer and handel data and erros.
     */
    private func setupViewModelObserver() {
        // Success list observer
        
        self.githubUsersViewModel.result.bind { [weak self] (result) in
            switch result {
            case .success(_):
                self?.isAPICalled = true
                self?.setListData()
                self?.lblNoData.isHidden = !(self?.githubUsersViewModel.arrUsers.count == 0)
            case .failure(_):
                self!.isAPICalled = false
                self?.tableReloadData()
                self?.lblNoData.isHidden = !(self?.githubUsersViewModel.arrUsers.count == 0)
            }
        }
    }
    
    /// Set list data and reload tables.
    private func setListData() {
        self.tableReloadData()
    }
}
