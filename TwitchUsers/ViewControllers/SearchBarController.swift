//
//  SearchBarController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit


protocol SearchBarControllerDelegate: AnyObject {
    
    func didFoundUser(searchBarController: SearchBarController, user: UserInfo)
    func didntFoundUser(searchBarController: SearchBarController, error: String)
}


class SearchBarController: UISearchBar, UISearchBarDelegate, URLSessionDelegate, URLSessionDataDelegate{
    
    weak var barDelegate: SearchBarControllerDelegate?
    
    let fileManager = FileManager.default
    let encoder = JSONEncoder.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.barStyle = .blackTranslucent
        self.keyboardAppearance = .dark
        self.showsCancelButton = true
        self.showsScopeBar = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: SearchBar delegate conforming:
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let windowOnScreenController = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers[0] as? SearchViewController else { return }
        DispatchQueue.main.async {
            windowOnScreenController.activityIndicator.startAnimating()
        }
        let twitchSearcher = TwitchUserSearcher()
        let name = searchBar.text?.lowercased()

        twitchSearcher.searchForUser(with: name ?? "", delegate: self)
        searchBar.resignFirstResponder()
    }
    
    //MARK: URLSession delegate conforming:
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let HTTPResponce = response as? HTTPURLResponse
        let statusCode = HTTPResponce?.statusCode
        
        if statusCode != 200{
            self.barDelegate?.didntFoundUser(searchBarController: self, error: "Error searching user: received \(statusCode ?? 0) status code")
            completionHandler(.cancel)
        }else{
            completionHandler(.allow)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        let jsonData = data
        let currentDate = Date()
        
        var jsonDictionary = [String: AnyObject]()
        do{
            jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [String: AnyObject]
            
            guard let id = jsonDictionary["_id"] as? Int else { return }
            guard let name = jsonDictionary["name"] as? String else { return }
            guard let type = jsonDictionary["type"] as? String else { return }
            guard let logo = jsonDictionary["logo"] as? String else { return }
            guard let logoURL = URL(string: logo) else { return }
            var bio: String?
            if let userBio = jsonDictionary["bio"] as? String{
                bio = userBio
            }
            
            let imageData = try Data(contentsOf: logoURL)
            let avatar = UIImage(data: imageData)
            
            let user = UserInfo(id: id, name: name, type: type, avatar: avatar ?? nil, searchingDate: currentDate, bio: bio)
            
            //            encodeToJSONData(user: user)
            
            self.barDelegate?.didFoundUser(searchBarController: self, user: user)
            
        }catch{ }
    }
    
    private func encodeToJSONData(user: UserInfo){
        do{
            let json = try encoder.encode(user)
            if let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
                var path = url.path
                path.append("/lastUserData.json")
                print(path)
                fileManager.createFile(atPath: path, contents: json, attributes: nil)
            }
        }catch{
            print("Oops ... unable to create file")
        }
    }
    
}
