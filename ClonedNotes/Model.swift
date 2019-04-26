//
//  Model.swift
//  ClonedNotes
//
//  Created by Michele Galvagno on 26/04/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import Foundation

struct Directory: Codable {
    var name: String
    var folders: [Folder]
}

struct Folder: Codable {
    var name: String
    var notes: [Note]
    var itemsCount: Int
}

struct Note: Codable {
    var title: String
    var text: String
}
