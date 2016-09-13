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
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
}
