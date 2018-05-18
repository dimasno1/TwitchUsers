//
//  SessionDataHandler.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/18/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

protocol VideoDataHandlerDelegate: AnyObject{
    
    func didReceivedVideosMeta(videoDataHandler: VideoDataHandler, meta: Any)
    func didntReceivedVideosMeta(videoDataHandler: VideoDataHandler, error: String)
}

class VideoDataHandler: NSObject, URLSessionDataDelegate {
    
    weak var delegate: VideoDataHandlerDelegate?
    
    //MARK: URLSession delegate conforming:
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let HTTPResponce = response as? HTTPURLResponse
        let statusCode = HTTPResponce?.statusCode
        
        if statusCode != 200{
            self.delegate?.didntReceivedVideosMeta(videoDataHandler: self, error: "Error searching user: received \(statusCode ?? 0) status code")
            completionHandler(.cancel)
        }else{
            completionHandler(.allow)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(data)
        
        let jsonData = data
        var jsonDictionary = [String: AnyObject]()
        do{
            jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [String: AnyObject]
            print(jsonDictionary)
            
        }catch{
            
        }
    }
}
