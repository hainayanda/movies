//
//  String+Extensions.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

extension String {
    var withTMDBImagePath: String {
        if self.contains("https://image.tmdb.org/t/p/original") {
            return self
        }
        return "https://image.tmdb.org/t/p/original\(self)"
    }
}
