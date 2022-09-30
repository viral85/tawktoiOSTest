//
//  Extension+UIViewController.swift
//  tawkiOSTest
//
//  Created by Apple on 28/09/22.
//

import Foundation
import UIKit
import MaterialComponents.MaterialActivityIndicator
import CoreData

// MARK: - UIViewController Extension
extension UIViewController{
    
    //Main Stroyboard
    var Main : UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    //Navigation shortcut
    func navigateTo(_ viewController : UIViewController, _ animation : Bool = true) {
        navigationController?.pushViewController(viewController, animated: animation)
    }
    
    func instantiateGithubUsersListController() -> GithubUsersListVC {
        let aVC = Main.instantiateViewController(withClass: GithubUsersListVC.self)!
        return aVC
    }
    
    func instantiateGithubUserDetailsController(userData: UserDetailsModel ,userName:String) -> UserDetailsVC {
        let aVC = Main.instantiateViewController(withClass: UserDetailsVC.self)!
        aVC.strUserName = userName
        aVC.userDetailsViewModel.userDetailsData = userData
        return aVC
    }
    
    
    //Show/Hide Progress HUD
    func ShowHUD() {
        let actInd = MDCActivityIndicator(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        actInd.tag = 999
        actInd.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        actInd.indicatorMode = .indeterminate
        if let Window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            Window.addSubview(actInd)
            Window.bringSubviewToFront(actInd)
        }
        actInd.radius = 20
        actInd.strokeWidth = 4
        actInd.center = self.view.center
        actInd.cycleColors = [UIColor.black]
        actInd.startAnimating()
    }
    
    func HideHUD() {
        DispatchQueue.main.async {
            if let Window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                for actView in Window.subviews where actView.tag == 999 {
                    if let actInd = actView as? MDCActivityIndicator {
                        actInd.stopAnimating()
                        actInd.removeFromSuperview()
                    }
                }
            }
        }
    }
    
//    //Set Back Button
//    func setBackButton(){
//        navigationItem.hidesBackButton = true
//        var image = UIImage(named: "ic_back_arrow")
//        image = image?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(back(sender:)))
//    }
//    
//    //Set Back Button Action
//    @objc func back(sender: UIBarButtonItem) {
//        self.navigationController?.popViewController(animated:true)
//    }
    
    
    //Show Alert
    func showAlert(strMessage: String){
        let alert = UIAlertController(title: UIApplication.shared.displayName, message: strMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        topViewController.present(alert, animated: true)
    }
}
