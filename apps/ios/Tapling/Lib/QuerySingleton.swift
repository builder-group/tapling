//
//  QuerySingleton.swift
//  Tapling
//
//  Created by Benno on 03.12.25.
//

import SwiftData
import SwiftUI

/// Property wrapper for querying singleton SwiftData models.
/// Automatically unwraps the first result from a query or falls back to the default instance.
///
/// Usage:
/// ```swift
/// @QuerySingleton private var settings: KeyboardSettings
/// ```
@propertyWrapper
struct QuerySingleton<Model: SingletonModel>: DynamicProperty {
    @Query private var queried: [Model]
    
    var wrappedValue: Model {
        queried.first ?? Model.default
    }
    
    init() {
        _queried = Query()
    }
}

