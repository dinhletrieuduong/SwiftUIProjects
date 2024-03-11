//
//  Utils.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 04/09/2023.
//

import Foundation

extension Decodable {
    static func decode(data: Data?, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        try decoder.decode(Self.self, from: data ?? Data())
    }
    
}

extension Data {
    func decodedObject<T: Decodable>(decoder: JSONDecoder = JSONDecoder()) throws -> T {
        try decoder.decode(T.self, from: self)
    }
}
// let car: Car = try? data.decodedObject()