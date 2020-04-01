//
//  ApiTarget.swift
//  ColorMVVM
//
//  Created by Seokho on 2020/03/31.
//

import Foundation

enum ApiType {
    case colors
}

enum ApiURL {
    
    private static var base: URL {
        URL(string: "https://raw.githubusercontent.com/wlsdms0122/RxMVVM/develop")!
    }
    
   static func url(_ type: ApiType) -> URL {
        var path: String
        switch type {
        case .colors:
           path = "API/colors.json"
        }
    
        return ApiURL.base.appendingPathComponent(path)
    }
}
