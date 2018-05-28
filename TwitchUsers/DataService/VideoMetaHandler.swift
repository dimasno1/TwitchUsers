//
//  SessionDataHandler.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/18/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

protocol VideoDataHandlerDelegate: AnyObject{
    
    func didReceivedVideosMeta(videoDataHandler: VideoMetaHandler, meta: Any)
    func didntReceivedVideosMeta(videoDataHandler: VideoMetaHandler, error: String)
}

class VideoMetaHandler: NSObject, URLSessionDataDelegate {
    
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
    }
}
