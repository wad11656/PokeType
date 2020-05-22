//
//  Movetype.swift
//  App Project 3
//
//  Created by Wade on 9/30/18.
//  Copyright © 2018 Wade Murdock. All rights reserved.
//

import UIKit

class Results: Codable {
    let results: [Movetype]
    
    init(results: [Movetype]) {
        self.results = results
    }
}

class Movetype: Codable {
    let name: String
    let url: String
    
    init(name: String, url: String) {
    self.name = name
    self.url = url
    }
}
