//
//  UserDetailsVC.swift
//  tawkiOSTest
//
//  Created by Apple on 23/09/22.
//

import UIKit
import Reachability

class UserDetailsVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var imgUserProfile: CustomImageLoader!
    
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    
    
    @IBOutlet weak var stackViewUserIntro: UIStackView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserCompany: UILabel!
    @IBOutlet weak var lblUserBlog: UILabel!

    @IBOutlet weak var txtViewObj: UITextView!
    
    @IBOutlet weak var btnSave: UIButton!

    
    // MARK: - Class Variable
    var userDetailsViewModel = UserDetailsVM()
    var strUserName = ""
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// CALL CUSTOM METHOD
        setupView()

        /// CALL USER DETAILS API
        userDetailsViewModel.username = strUserName
        userDetailsViewModel.CallGithubUserDetailsAPI()
        
        /// CONFIGURE DATE
        setListData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userDetailsViewModel.updateCoreData()
    }
    
    // MARK: - Custom Method
    private func setupView(){
        
        self.title = strUserName.uppercased()  /// Navigation title
        
//        setBackButton()  /// Set custom Back button
        
        self.setupViewModelObserver()
        
        stackViewUserIntro.layer.borderWidth = 1
        stackViewUserIntro.layer.borderColor = UIColor.gray.cgColor
        stackViewUserIntro.layer.cornerRadius = 3
        
        txtViewObj.layer.borderWidth = 1
        txtViewObj.layer.borderColor = UIColor.gray.cgColor
        txtViewObj.layer.cornerRadius = 3
        
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.size.height / 2
        
        btnSave.layer.cornerRadius = btnSave.frame.size.height / 2
        
        /// SET DATA LOCALLY
        txtViewObj.text = self.userDetailsViewModel.userDetailsData?.notes
        
        internetRechability()
    }
    
    /// Check Internet Rechability
    private func internetRechability(){
        reachability.whenReachable = { reachability in
            // CALL USER LIST API
            if self.userDetailsViewModel.userDetailsData?.createdAt?.count ?? 0 == 0{
                self.userDetailsViewModel.CallGithubUserDetailsAPI()
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
    
    // MARK: - Button Actions
    @IBAction func btnSaveClicked(_ sender: Any) {
        self.view.endEditing(true)
        if txtViewObj.text.trimmingCharacters(in: .whitespaces).count == 0{
            showAlert(strMessage: AppStrings.enterNote)
            return
        }
        self.userDetailsViewModel.userDetailsData?.notes = txtViewObj.text ?? ""
        self.userDetailsViewModel.updateCoreData()
        NotificationCenter.default.post(name: .reloadUserList, object: nil)
        showAlert(strMessage: "Note Saved")
    }
}

//----------------------------------------------------------------------------
// MARK: - SetupViewModel Observer
//----------------------------------------------------------------------------
extension UserDetailsVC {
    /**
     Setup all view model observer and handel data and erros.
     */
    private func setupViewModelObserver() {

        self.userDetailsViewModel.result.bind { [weak self] (result) in
            switch result {
            case .success(_):
                self?.setListData()
            case .failure(_):
                print("")
            }
        }
    }

    /// Set list data and reload tables.
    private func setListData() {
        
        if let url = URL(string: self.userDetailsViewModel.userDetailsData?.avatarURL ?? ""){
            imgUserProfile.completion = {
            }
            imgUserProfile.loadImageWithUrl(url)
        }
        
        self.lblFollowers.text = "Followers: \(self.userDetailsViewModel.userDetailsData?.followers ?? 0)"
        self.lblFollowing.text = "Following: \(self.userDetailsViewModel.userDetailsData?.following ?? 0)"
        
        self.lblUserName.text = "Name: \(self.userDetailsViewModel.userDetailsData?.name ?? "")"
        self.lblUserCompany.text = "Company: \(self.userDetailsViewModel.userDetailsData?.company ?? "")"
        self.lblUserBlog.text = "Blog: \(self.userDetailsViewModel.userDetailsData?.blog ?? "")"
        
        self.lblUserName.setMargins()
        self.lblUserCompany.setMargins()
        self.lblUserBlog.setMargins()
    }
}


