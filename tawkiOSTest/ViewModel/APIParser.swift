//
//  APIParser.swift
//  tawkiOSTest
//
//  Created by Apple on 22/09/22.
//

import Foundation
import UIKit

struct APIParser{
    
    private var results = [GithubUserModel]()
    
    enum Endpoint: String {
        case userlist = "users?since="
        case userDetails = "users/"
    }
    
    enum Method: String{
        case GET
        case POST
    }
    
    func request<T: Codable>(parameterValue:String, endPoint: Endpoint, method: Method, completion: @escaping ((Result<T, AppError>)) -> Void){
        
        topViewController.ShowHUD()
        
        let path = AppStrings.baseURLString + endPoint.rawValue + parameterValue
        
        guard let url = URL(string: path)
        else { completion(.failure(.network(type: .notFound))); return  }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        APICall(with: request, completion: completion)
    }
    
    func APICall<T: Codable>(with request:URLRequest, completion: @escaping ((Result<T, AppError>)) -> Void){
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            topViewController.HideHUD()
            
            if error != nil{
                completion(Result.failure(.network(type: .notFound)))
            }
            
            if let data = data {
               if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                    DispatchQueue.main.async {
                        //print("self.results : \(decodedResponse)")
                        completion(Result.success(decodedResponse))
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            completion(Result.failure(.network(type: .notFound)))
        }
        dataTask.resume()
    }
}

class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    /// Encodes given Encodable value into an array or dictionary
    func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()

    /// Decodes given Decodable type from given array or dictionary
    func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}

