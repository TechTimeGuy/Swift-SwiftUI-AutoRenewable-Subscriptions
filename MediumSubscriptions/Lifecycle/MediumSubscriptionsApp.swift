//
//  MediumSubscriptionsApp.swift
//  MediumSubscriptions
//
//  Created by Apps4World on 6/2/21.
//

import SwiftUI
import PurchaseKit

@main
struct MediumSubscriptionsApp: App {
    
    // MARK: - Main rendering function
    var body: some Scene {
        PKManager.configure(sharedSecret: "your-app-secret")
        PKManager.loadProducts(identifiers: ["monthly.productId", "six.months.productId", "yearly.productId"])
        return WindowGroup {
            ContentView()
        }
    }
}
