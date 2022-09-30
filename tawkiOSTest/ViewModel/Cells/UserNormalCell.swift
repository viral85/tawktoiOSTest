//
//  UserNormalCell.swift
//  tawkiOSTest
//
//  Created by Apple on 22/09/22.
//

import UIKit

class UserNormalCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewImgProfile: UIView!
    @IBOutlet weak var imgProfile: CustomImageLoader!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.borderWidth = 1
        viewMain.layer.borderColor = UIColor.gray.cgColor
        viewMain.layer.cornerRadius = 5
        
        viewImgProfile.layer.cornerRadius = viewImgProfile.frame.size.height/2
        viewImgProfile.layer.borderWidth = 1
        viewImgProfile.layer.borderColor = UIColor.gray.cgColor
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
    }
    
    /// SETUP CELL DATA
    func configureData(userData: GithubUserModel?){
        self.lblUserName.text = userData?.login
        self.lblDetails.text = userData?.type
        if let url = URL(string: userData?.avatarURL ?? ""){
            DispatchQueue.main.async {
                self.imgProfile.completion = {}
                self.imgProfile.loadImageWithUrl(url)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
