//
//  Created by Apps4World on 8/17/20.
//  Copyright © 2020 Apps4World. All rights reserved.
//

import SwiftUI
import PurchaseKit

struct PKLightThemeView: View {
    
    var title: String
    var subtitle: String
    var features: [String]
    var productIds: [String]
    @State var completion: PKCompletionBlock?
    @State private var selectedProductIndex: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Privacy Policy, Terms & Conditions URLs
    // NOTE: You must provide these 2 URLs
    private let privacyPolicyURL: URL = URL(string: "https://google.com/")!
    private let termsAndConditionsURL: URL = URL(string: "https://google.com/")!
    
    /// If you don't have the URLs mentioned above, you can hide the buttons by setting this to `true`
    private let hidePrivacyPolicyTermsButtons: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        VStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    HeaderSectionView
                    
                    VStack {
                        FeaturesListView
                        ProductsListView
                    }.padding(.top, 20).padding(.bottom, 20)
                    
                    RestorePurchases
                    PrivacyPolicyTermsSection
                    DisclaimerTextView
                }
                
                CloseButtonView
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    /// Header view
    private var HeaderSectionView: some View {
        VStack {
            /// Image for the header
            Image("light-header").resizable().aspectRatio(contentMode: .fill).frame(width: UIScreen.main.bounds.width, height: 200).clipped()
            /// Title & Subtitle
            HStack {
                VStack(alignment: .leading) {
                    Text(title).font(.largeTitle).bold()
                    Text(subtitle).font(.headline)
                }
                Spacer()
            }.padding(.leading, 20).padding(.trailing, 20)
            Divider().padding(.top, 20)
        }
    }
    
    /// Features scroll list view
    private var FeaturesListView: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<features.count) { index in
                        HStack {
                            Image(systemName: "checkmark.seal").resizable().frame(width: 20, height: 20)
                            Text(self.features[index]).font(.system(size: 18))
                        }
                    }.padding(.leading, 20).padding(.trailing, 20)
                }
            }
            Divider().padding(.top, 20).padding(.bottom, 20)
        }
    }
    
    /// List of products
    private var ProductsListView: some View {
        VStack(spacing: 10) {
            ForEach(0..<self.productIds.count) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 15).foregroundColor(self.selectedProductIndex == index ? Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)).opacity(0.5) : .clear).frame(height: 55)
                    HStack {
                        Image(systemName: self.selectedProductIndex == index ? "largecircle.fill.circle" :  "circle").resizable().frame(width: 25, height: 25).padding(.leading, 20)
                        Text(PKManager.formattedProductTitle(identifier: self.productIds[index]))
                        Spacer()
                    }
                }.onTapGesture {
                    self.selectedProductIndex = index
                }
            }
            Button(action: {
                PKManager.purchaseProduct(identifier: self.productIds[self.selectedProductIndex], completion: self.completion)
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 28.5).foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))).frame(height: 57)
                    VStack {
                        Text("Continue").foregroundColor(.white).bold()
                        if !PKManager.introductoryPrice(identifier: self.productIds[self.selectedProductIndex]).isEmpty {
                            Text(PKManager.introductoryPrice(identifier: self.productIds[self.selectedProductIndex]))
                                .font(.system(size: 13)).fontWeight(.light).foregroundColor(.white)
                        }
                    }
                }
            }).padding(.top, 40)
        }.padding(.leading, 20).padding(.trailing, 20)
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
}
