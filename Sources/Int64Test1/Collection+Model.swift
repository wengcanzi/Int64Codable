//
//  File.swift
//  
//
//  Created by canzi on 2021/8/9.
//

import Foundation

public extension Collection {
    func translateToModel<T: Decodable>() throws -> T {
        let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }
}
