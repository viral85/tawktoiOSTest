//
//  UserDetailsVM.swift
//  tawkiOSTest
//
//  Created by Apple on 23/09/22.
//

import Foundation
import CoreData
import UIKit

class UserDetailsVM {
    
    // MARK: - Class Variable
    private(set) var result = Bindable<Result<String?, AppError>>()

    var userDetailsData : UserDetailsModel?
    var username = ""
    
    // MARK: - Init
    init() {}
    
    // MARK: - Deinit
    deinit {
        debugPrint("deinit view model : \(self)")
    }
}

//--------------------------------------------------------------------------------------
// MARK: - API CALL Method
//--------------------------------------------------------------------------------------
extension UserDetailsVM {
    
    func userDetailsCall(completion: @escaping ((Result<githubUsersDetail, AppError>) -> Void)){
        APIParser().request(parameterValue: "\(username)", endPoint: .userDetails, method: .GET, completion: completion)
    }
    
    func CallGithubUserDetailsAPI(){
        
        userDetailsCall { result in
            switch result {
            case .success(let userListData):
                self.userDetailsData = userListData
                self.result.set(value: .success(nil))
            case .failure(let failure):
                self.result.set(value: .failure(.custom(errorDescription: failure.localizedDescription)))
            }
        }
    }
 
}


//--------------------------------------------------------------------------------------
// MARK: - Coredata Methods
//--------------------------------------------------------------------------------------
extension UserDetailsVM{
    
    /// UPDATE RECORD
    func updateCoreData(){
        
       /* let newUsers = NSManagedObject(entity: entity, insertInto: managedContext)
        let result =  DatabaseHandler().fetchDataFromID(idValue: userDetailsData?.id ?? 0)
        result.setValue(self.userDetailsData?.name, forKey: "name")
        result.setValue(self.userDetailsData?.followers, forKey: "followers")
        result.setValue(self.userDetailsData?.following, forKey: "following")
        result.setValue(self.userDetailsData?.company, forKey: "company")
        result.setValue(self.userDetailsData?.blog, forKey: "blog")
        result.setValue(self.userDetailsData?.notes, forKey: "notes")
        
        DatabaseHandler().save()*/
        
        
        let request = DatabaseHandler().request
        request.predicate = NSPredicate(format: "id = %d", userDetailsData?.id ?? 0)

        let managedContext = viewContext
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request) as? [NSManagedObject]
            if result?.count ?? 0 > 0{
                let resultData = result?[0]
                resultData?.setValue(self.userDetailsData?.name, forKey: "name")
                resultData?.setValue(self.userDetailsData?.followers, forKey: "followers")
                resultData?.setValue(self.userDetailsData?.following, forKey: "following")
                resultData?.setValue(self.userDetailsData?.company, forKey: "company")
                resultData?.setValue(self.userDetailsData?.blog, forKey: "blog")
                resultData?.setValue(self.userDetailsData?.notes, forKey: "notes")
                do {
                    try managedContext.save() }
                catch {
                    print(error.localizedDescription) }
            }
        } catch {
            print("Couldn't fetch data")
        }
        
    }
    
}
