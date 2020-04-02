//
//  Color.swift
//  ColorMVVM
//
//  Created by Seokho on 2020/03/31.
//

import UIKit

enum ColorLists {
    static var background: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    static var label: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    
    static var gray5: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray5
        } else {
            return UIColor(displayP3Red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0)
        }
    }
}
