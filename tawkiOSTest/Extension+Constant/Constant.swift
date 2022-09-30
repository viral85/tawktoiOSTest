//
//  Constant.swift
//  tawkiOSTest
//
//  Created by Apple on 22/09/22.
//

import Foundation
import UIKit
import Reachability
import CoreData

// MARK: - Global String
enum AppStrings {
    
    static let baseURLString = UIApplication.shared.inferredEnvironment == .appStore ? "https://api.github.com/" : "https://api.github.com/"
    
    
    static let noInternetConnection = "No Internet Connection"
    static let normalCell = "UserNormalCell"
    static let notesCell = "UserNotesCell"
    static let invertCell = "InvertedCell"
    
    
    static let enterNote = "Please Enter Note"
    
}

// MARK: - Local Notification Names
extension Notification.Name {
    static let reloadUserList = Notification.Name("reloadUserList")
}


// MARK: - Global Variables

var topViewController = UIViewController()

let reachability = try! Reachability()

let viewContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
