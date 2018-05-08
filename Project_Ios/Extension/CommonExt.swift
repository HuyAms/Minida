//
//  CommonExt.swift
//  Project_Ios
//
//  Created by iosdev on 6.5.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(arguments: CVarArg) -> String {
        return String.localizedStringWithFormat(self.localized, arguments)
    }
}
