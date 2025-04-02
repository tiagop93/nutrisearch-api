//
//  JSONDecoder+Extensions.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import Foundation

extension JSONDecoder {
    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
