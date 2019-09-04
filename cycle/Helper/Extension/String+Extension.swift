//
//  String+Extension.swift
//  cycle
//
//  Created by Azmi Muhammad on 28/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import Foundation

extension String {
    func removeEmailFormat() -> String {
        if !contains("@") { return "" }
        else {
            let separatedStrings = split(separator: "@")
            return String(separatedStrings[0])
        }
    }
}
