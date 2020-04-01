//
//  JSON.swift
//  ColorMVVM
//
//  Created by Seokho on 2020/03/31.
//

import Foundation

class DecodeOptional {
    static func decode<T: Codable>(_ data: Data, type: T.Type) -> T? {
        do {
            let value = try JSONDecoder().decode(type, from: data)
            return value
        } catch {
            return nil
        }
    }
}
