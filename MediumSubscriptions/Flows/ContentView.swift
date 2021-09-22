//
//  ContentView.swift
//  MediumSubscriptions
//
//  Created by Apps4World on 6/2/21.
//

import SwiftUI
import PurchaseKit

/// Main view for this demo app
struct ContentView: View {
    
    @State private var showSubscriptionFlow: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        Button(action: {
            showSubscriptionFlow = true
        }) {
            Text("Show iAP Flow")
        }
        /// Present the subscription flow
        .sheet(isPresented: $showSubscriptionFlow, content: {
            SubscriptionFlow
        })
        /// Verify the subscription receipt when the view is presented
        .onAppear(perform: {
            PKManager.shared.productIdentifiers.forEach { productId in
                PKManager.verifySubscription(identifier: productId) { (_, status, _) in
                    if status == .success {
                        /// If the subscription is still active (status == .success), unlock any content, remove ads or do anything you have to do
                    }
                }
            }
        })
    }
    
    /// Prepare the PurchaseKit UI flow
    private var SubscriptionFlow: some View {
        PKDarkThemeView(title: "PRO Version",
                        subtitle: "Unlock new features",
                        features: ["Remove Ads", "Unlock more levels", "Get regular updates"],
                        productIds: ["six.months.productId", "yearly.productId", "monthly.productId"],
                        completion: { error, status, _ in
                            /// Handle the error and status for each in-app purchase based on the productIdentifier
                            if status == .success || status == .restored {
                                /// If the purchase was successful or restored, unlock any content, remove ads or do anything you have to do
                            }
                            guard let errorMessage = error else { return }
                            print(errorMessage)
                        })
    }
}

// MARK: - Preview UI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
