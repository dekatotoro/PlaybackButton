//
//  String.swift
//  PlaybackButton
//
//  Created by Yuji Hato on 1/1/16.
//  Copyright © 2016 dekatotoro. All rights reserved.
//

import Foundation

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    func substring(from: Int) -> String {
        return self.substringFromIndex(self.startIndex.advancedBy(from))
    }
}