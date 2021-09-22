//
//  Created by Apps4World
//  Copyright © 2020 Apps4World. All rights reserved.
//

import SwiftUI
import PurchaseKit

struct PKDiamondView: View {
    
    var title: String
    var subtitle: String
    var features: [String]
    var sixMonthsProductId: String
    var oneYearProductId: String
    var threeMonthsProductId: String
    @State var completion: PKCompletionBlock?
    @State private var selectedProductId: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Privacy Policy, Terms & Conditions URLs
    // NOTE: You must provide these 2 URLs
    private let privacyPolicyURL: URL = URL(string: "https://google.com/")!
    private let termsAndConditionsURL: URL = URL(string: "https://google.com/")!
    
    /// If you don't have the URLs mentioned above, you can hide the buttons by setting this to `true`
    private let hidePrivacyPolicyTermsButtons: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                HeaderSectionView
                ProductsListView
                RestorePurchases
                PrivacyPolicyTermsSection
                DisclaimerTextView
            }.edgesIgnoringSafeArea(.bottom)
            
            CloseButtonView
        }
    }
    
    /// Header view
    private var HeaderSectionView: some View {
        VStack {
            /// Image for the header
            Image("diamond-header").resizable().aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 100).padding(.top, 50)
            /// Title & Subtitle
            VStack {
                Text(title).font(.largeTitle).bold().multilineTextAlignment(.center)
                Text(subtitle).font(.headline).fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
            }.padding(.leading, 20).padding(.trailing, 20).padding(.bottom, 20)
            /// List of features
            ForEach(0..<features.count) { index in
                HStack {
                    Image(systemName: "checkmark.circle").resizable()
                        .frame(width: 25, height: 25)
                    Text(self.features[index]).font(.system(size: 22))
                    Spacer()
                }
            }.padding(.leading, 30).padding(.trailing, 30)
        }
    }
    
    /// List of products (horizontal)
    private var ProductsListView: some View {
        VStack {
            VStack(spacing: 10) {
                Divider()
                Text("CHOOSE A PLAN").font(.system(size: 22)).bold()
                HStack(alignment: .bottom, spacing: 10) {
                    createProductButton(id: self.sixMonthsProductId)
                    createProductButton(id: self.oneYearProductId)
                    createProductButton(id: self.threeMonthsProductId)
                }
                (Text("Trial period: ") + Text(PKManager.introductoryPrice(identifier: self.selectedProductId).isEmpty ? "Not Available" : PKManager.introductoryPrice(identifier: self.selectedProductId)).bold()).padding(.top, 20)
                Button(action: {
                    PKManager.purchaseProduct(identifier: self.selectedProductId, completion: self.completion)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28.5)
                            .frame(height: 57).foregroundColor(self.selectedProductId.isEmpty ? . secondary : .orange)
                        VStack {
                            Text("Continue").font(.system(size: 21)).foregroundColor(.white).bold()
                        }
                    }
                }).padding(.top, 20).disabled(self.selectedProductId.isEmpty)
            }.padding(.leading, 20).padding(.trailing, 20)
            
        }.padding(.top, 20).padding(.bottom, 20)
    }
    
    /// Close button on the top header
    private var CloseButtonView: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    PKManager.dismissInAppPurchaseScreen()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable().accentColor(.black).frame(width: 32, height: 32)
                })
            }
            Spacer()
        }.padding(20).edgesIgnoringSafeArea(.top)
    }
    
    /// Restore purchases button
    private var RestorePurchases: some View {
        Button(action: {
            PKManager.restorePurchases { (error, status, id) in
                self.presentationMode.wrappedValue.dismiss()
                self.completion?((error, status, id))
            }
        }, label: {
            Text("Restore Purchases").foregroundColor(.black)
        })
    }
    
    /// Privacy Policy, Terms & Conditions section
    private var PrivacyPolicyTermsSection: some View {
        HStack(spacing: 20) {
            if hidePrivacyPolicyTermsButtons == false {
                Button(action: {
                    UIApplication.shared.open(privacyPolicyURL, options: [:], completionHandler: nil)
                }, label: {
                    Text("Privacy Policy")
                })
                Button(action: {
                    UIApplication.shared.open(termsAndConditionsURL, options: [:], completionHandler: nil)
                }, label: {
                    Text("Terms & Conditions")
                })
            }
        }.font(.system(size: 10)).foregroundColor(.gray).padding()
    }
    
    /// Disclaimer text view at the bottom
    private var DisclaimerTextView: some View {
        VStack {
            Text(PKManager.disclaimer).font(.system(size: 12))
                .multilineTextAlignment(.center)
                .padding(.leading, 30).padding(.trailing, 30)
            Spacer(minLength: 50)
        }
    }
    
    /// Build a product button with the product title, duration, price
    private func createProductButton(id: String) -> some View {
        Button(action: {
            self.selectedProductId = id
        }, label: {
            VStack {
                /// Show the best value text for 1 year product
                if id == self.oneYearProductId {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).foregroundColor(.orange).frame(height: 30)
                        Text("Best Value").foregroundColor(.white).layoutPriority(1).padding(10)
                    }
                }
                /// Show the product period, duration, price
                ZStack {
                    RoundedRectangle(cornerRadius: 20).frame(height: 130)
                        .foregroundColor(self.selectedProductId == id ? .white : .secondary).opacity(0.3)
                    if self.selectedProductId == id {
                        RoundedRectangle(cornerRadius: 20).stroke(Color.orange, lineWidth: 4).frame(height: 130)
                    }
                    VStack {
                        Text(PKManager.subscriptionPeriod(identifier: id).duration).font(.largeTitle).foregroundColor(.black).bold()
                        Text(PKManager.subscriptionPeriod(identifier: id).unit).font(.system(size: 20)).foregroundColor(.black).bold()
                        Text(PKManager.productPrice(identifier: id)).font(.system(size: 15)).foregroundColor(.black)
                    }.opacity(self.selectedProductId == id ? 1.0 : 0.3)
                }
            }
        })
    }
}

// MARK: - Preview UI
struct PKDiamondView_Previews: PreviewProvider {
    static var previews: some View {
        PKDiamondView(title: "Unlimited Access", subtitle: "Get access to all our features for as long as you need them. Save on 12 months plan.", features: ["Remove all ads", "Daily content"], sixMonthsProductId: "sixMonths", oneYearProductId: "oneYear", threeMonthsProductId: "threeMonths")
    }
}
