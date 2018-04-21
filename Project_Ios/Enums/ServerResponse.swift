//
//  ServerResponse.swift
//  Project_Ios
//
//  Created by iosdev on 11.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import Foundation

enum ServerResponse<T> {
    case success(T)
    case error(error: AppError)
}


