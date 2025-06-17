//
//  SavedItem.swift
//  Lookaluxe
//
//  Created by Adishree Das on 6/8/25.
//

import Foundation
import SwiftData //uses swift data to save info about user's image and backend result

@Model // marks class as swiftdata model
final class SavedItem {
    @Attribute(.unique) var id: UUID //unique ID
    var imageData: Data? //optional raw image data
    var backendResult: String //result string from backend
    var timestamp: Date //exact date item was saved
    var name: String //name enterd by user
    
    //initializer used when new SavedItem is created
    init(imageData: Data?, backendResult: String, name: String = "Lookaluxe Item") {
        self.id = UUID()
        self.imageData = imageData
        self.backendResult = backendResult
        self.timestamp = Date()
        self.name = name
    }
} 
