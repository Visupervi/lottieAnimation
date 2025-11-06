//
//  ReactViewController.swift
//  lottieAnimation
//
//  Created by Visupervi on 2025/11/4.
//

import UIKit
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider

class ReactView: UIView {
  var reactNativeFactory: RCTReactNativeFactory?
  var reactNativeFactoryDelegate: RCTReactNativeFactoryDelegate?

//  override func viewDidLoad() {
//    super.viewDidLoad()
//    reactNativeFactoryDelegate = ReactNativeDelegate()
//    reactNativeFactoryDelegate!.dependencyProvider = RCTAppDependencyProvider()
//    reactNativeFactory = RCTReactNativeFactory(delegate: reactNativeFactoryDelegate!)
//    view = reactNativeFactory!.rootViewFactory.view(withModuleName: "lottieAnimation")
//
//  }
  
//  func initReactView() ->UIView{
//    reactNativeFactoryDelegate = ReactNativeDelegate()
//    reactNativeFactoryDelegate!.dependencyProvider = RCTAppDependencyProvider()
//    reactNativeFactory = RCTReactNativeFactory(delegate: reactNativeFactoryDelegate!)
//    let view = reactNativeFactory!.rootViewFactory.view(withModuleName: "lottieAnimation")
//    return view
//  }
//  
//  var body: UIView{
//    let subView = initReactView()
//    self.addSubview(subView)
//    return self
//  }
  override init(frame: CGRect) {
          super.init(frame: frame)
          setupView()
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
          setupView()
      }
      
      private func setupView() {
//          self.backgroundColor = .systemBlue
//          self.layer.cornerRadius = 8
//          ReactNativeModuleRegistry.registerAllModules()
          reactNativeFactoryDelegate = ReactNativeDelegate()
          reactNativeFactoryDelegate!.dependencyProvider = RCTAppDependencyProvider()
          reactNativeFactory = RCTReactNativeFactory(delegate: reactNativeFactoryDelegate!)
          reactNativeFactory!.rootViewFactory.view(withModuleName: "lottieAnimation")
      }
  
  
}

class ReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
    override func sourceURL(for bridge: RCTBridge) -> URL? {
      self.bundleURL()
    }

    override func bundleURL() -> URL? {
      #if DEBUG
      RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
      #else
      Bundle.main.url(forResource: "main", withExtension: "jsbundle")
      #endif
    }

}
