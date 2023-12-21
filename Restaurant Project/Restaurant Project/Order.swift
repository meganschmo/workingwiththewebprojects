//
//  Order.swift
//  Restaurant Project
//
//  Created by Megan Schmoyer on 12/18/23.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
