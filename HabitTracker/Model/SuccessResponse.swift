//
//  SuccessResponse.swift
//  HabitTracker
//
//  Created by Shameem on 22/9/25.
//

import Foundation

struct SuccessResponse: Codable {
    let success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
    }
}

