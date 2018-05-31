//
//  TwitchAlertAction.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/31/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class TwitchAlertAction: NSCoder {
    
    var style: TwitchAlertStyle
    
    init(alertTitle: String?, style: TwitchAlertStyle, handler: (() -> Void)? ) {
        self.twitchAlertTitle = alertTitle
        self.handler = handler
        self.style = style
    }
    
    func executeHandler() {
        guard let handler: () -> Void = self.handler else { return }
        handler()
    }
    
    private (set) var handler: (() -> Void)?
    private (set) var twitchAlertTitle: String?
}

extension TwitchAlertAction {
    
    enum TwitchAlertStyle {
        
        case destructive
        case common
        
        func color() -> UIColor{
            switch self {
            case .destructive:
                return UIColor.red
            case .common:
                return UIColor.lightGray
            }
        }
    }
    
}

