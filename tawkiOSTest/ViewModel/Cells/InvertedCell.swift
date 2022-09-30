//
//  InvertedCell.swift
//  tawkiOSTest
//
//  Created by Apple on 28/09/22.
//

import UIKit

class InvertedCell: UITableViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewImgProfile: UIView!
    @IBOutlet weak var imgProfile: CustomImageLoader!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var imgNotes: UIImageView!

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
        self.imgNotes.isHidden = !(userData?.notes?.count ?? 0 > 0)
        if let url = URL(string: userData?.avatarURL ?? ""){
            DispatchQueue.main.async {
                self.imgProfile.completion = {self.imgProfile.invertColor()}
                self.imgProfile.loadImageWithUrl(url)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
