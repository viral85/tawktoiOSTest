//
//  GithubUsersListVM.swift
//  tawkiOSTest
//
//  Created by Apple on 21/09/22.
//

import Foundation
import AVKit
import CoreData

class GithubUsersListVM {
    
    // MARK: - Class Variable
    private(set) var result = Bindable<Result<String?, AppError>>()
    let database = DatabaseHandler()
    
    var arrUsers : [GithubUserModel] = []
    var arrTemp : [GithubUserModel] = []
    var user_id = 0
    
    // MARK: - Init
    init() {}
    
    // MARK: - Deinit
    deinit {
        debugPrint("deinit view model : \(self)")
    }
}
//--------------------------------------------------------------------------------------
// MARK: - TableView Methods
//--------------------------------------------------------------------------------------
extension GithubUsersListVM {
    
    func numberOfRows()-> Int {
        self.arrTemp.count > 0 ? self.arrTemp.count : self.arrUsers.count
    }
    
    func cellForItemAt(At indexpath : IndexPath) -> GithubUserModel{
        return self.arrTemp.count > 0 ? self.arrTemp[indexpath.row] : self.arrUsers[indexpath.row]
    }
}

//--------------------------------------------------------------------------------------
// MARK: - API CALL Method
//--------------------------------------------------------------------------------------
extension GithubUsersListVM {
    
    func decodeDataCall(dataObj: Data, completion: @escaping ((Result<githubUsers, AppError>) -> Void)){
        self.decode(data: dataObj, completion: completion)
    }
    
    func userListCall(completion: @escaping ((Result<githubUsers, AppError>) -> Void)){
        APIParser().request(parameterValue: "\(user_id)", endPoint: .userlist, method: .GET, completion: completion)
    }
    
    func CallGithubUserListAPI(){
        
        userListCall { result in
            switch result {
            case .success(let userListData):
                if self.arrUsers.count > 0{
                    userListData.forEach { data in
                        self.arrUsers.append(data)
                    }
                }else{
                    self.arrUsers = userListData
                }
                self.saveData(arrGitUsers: userListData)
                self.result.set(value: .success(nil))
            case .failure(let failure):
                self.result.set(value: .failure(.custom(errorDescription: failure.localizedDescription)))
            }
        }
    }
    
    private func decode<T: Decodable>(data: Data, completion: @escaping (Result<T, AppError>) -> Void) {
        do {
            let jsonDecoded = try JSONDecoder().decode(T.self, from: data)
            completion(.success(jsonDecoded))
        } catch (let error) {
            print(error)
            completion(.failure(.network(type: .parsing)))
        }
    }
}


//--------------------------------------------------------------------------------------
// MARK: - Coredata Methods (Save/Fetch)
//--------------------------------------------------------------------------------------
extension GithubUsersListVM {
    
    func saveData(arrGitUsers : [GithubUserModel]){
        let managedContext = viewContext
        let entity = NSEntityDescription.entity(forEntityName: "GithubUser", in: managedContext)!
        
        for index in 0..<arrGitUsers.count{
            let object = arrGitUsers[index]
            let newUsers = NSManagedObject(entity: entity, insertInto: managedContext)
            newUsers.setValue(object.login, forKey: "login")
            newUsers.setValue(object.id, forKey: "id")
            newUsers.setValue(object.avatarURL, forKey: "avatar_url")
            newUsers.setValue(object.nodeID, forKey: "node_id")
            newUsers.setValue(object.gravatarID, forKey: "gravatar_id")
            newUsers.setValue(object.url, forKey: "url")
            newUsers.setValue(object.htmlURL, forKey: "html_url")
            newUsers.setValue(object.followersURL, forKey: "followers_url")
            newUsers.setValue(object.followingURL, forKey: "following_url")
            newUsers.setValue(object.gistsURL, forKey: "gists_url")
            newUsers.setValue(object.starredURL, forKey: "starred_url")
            newUsers.setValue(object.subscriptionsURL, forKey: "subscriptions_url")
            newUsers.setValue(object.organizationsURL, forKey: "organizations_url")
            newUsers.setValue(object.reposURL, forKey: "repos_url")
            newUsers.setValue(object.eventsURL, forKey: "events_url")
            newUsers.setValue(object.receivedEventsURL, forKey: "received_events_url")
            newUsers.setValue(object.type, forKey: "type")
            newUsers.setValue(object.siteAdmin, forKey: "site_admin")
            newUsers.setValue("", forKey: "notes")
            do {
                try managedContext.save() }
            catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func fetchData(completion: (Bool) -> ()){
        
        self.arrUsers.removeAll()
        let result = DatabaseHandler().fetchData()
        var arrDic = [[String:Any]]()

        result.forEach { data in
            let site_admin = data.value(forKey: "site_admin") as? Int ?? 0
            let keys = Array(data.entity.attributesByName.keys)
            var dict = data.dictionaryWithValues(forKeys: keys)
            dict["site_admin"] = site_admin == 0 ? false : true
            arrDic.append(dict)
        }
            
        if result.count == arrDic.count{
            do{
                let data = try JSONSerialization.data(withJSONObject: arrDic as AnyObject, options: [])
                let userData = try! JSONDecoder().decode(githubUsers.self, from: data)
                self.arrUsers = userData
                completion(self.arrUsers.count > 0 ? true : false)
                self.result.set(value: .success(nil))
            }catch{
                completion(false)
            }
        }
    }
}



