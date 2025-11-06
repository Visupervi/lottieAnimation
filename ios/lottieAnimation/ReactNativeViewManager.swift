import UIKit
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider

@objc(ReactNativeViewManager)
class ReactNativeViewManager: NSObject {
    
    static let shared = ReactNativeViewManager()
    
    private var reactNativeDelegate: CustomReactNativeDelegate?
    private var reactNativeFactory: RCTReactNativeFactory?
    private weak var hostViewController: UIViewController?
    private var isInitialized: Bool = false
    
    // 用于跟踪当前活动的 RN 视图
    private var currentReactNativeView: RCTRootView?
    private weak var currentBridge: RCTBridge?
    
    private struct Constants {
        static let closeButtonSize: CGSize = CGSize(width: 60, height: 30)
        static let closeButtonTitle: String = "关闭 RN"
        static let animationDuration: TimeInterval = 0.3
    }
    
    // MARK: - 初始化
    @objc
    func initializeReactNative() {
        guard !isInitialized else {
            print("✅ ReactNativeFactory 已经初始化")
            return
        }
        
        let delegate = CustomReactNativeDelegate()
        let factory = RCTReactNativeFactory(delegate: delegate)
        delegate.dependencyProvider = RCTAppDependencyProvider()
        
        reactNativeDelegate = delegate
        reactNativeFactory = factory
        isInitialized = true
        
        print("✅ ReactNativeFactory 初始化完成")
    }
    
    // MARK: - 创建 React Native 视图
    @objc
    func createReactNativeView(moduleName: String,
                              initialProperties: [AnyHashable: Any]? = nil) -> UIView? {
        
        // 确保已经初始化
        if !isInitialized {
            initializeReactNative()
        }
        
        guard let factory = reactNativeFactory else {
            print("❌ ReactNativeFactory 创建失败")
            return nil
        }
        
        do {
            let rootView = factory.rootViewFactory.view(
                withModuleName: moduleName,
                initialProperties: initialProperties,
                launchOptions: nil
            )
            
            // 保存引用以便后续清理
            if let rootView = rootView as? RCTRootView {
                currentReactNativeView = rootView
                currentBridge = rootView.bridge
            }
            
            rootView.backgroundColor = .systemBackground
            return rootView
            
        } catch {
            print("❌ 创建 React Native 视图失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - 在 ViewController 中启动 RN
    @objc
    func startReactNativeInViewController(moduleName: String,
                                        viewController: UIViewController,
                                        initialProperties: [AnyHashable: Any]? = nil) {
        
        hostViewController = viewController
        
        guard let rnView = createReactNativeView(moduleName: moduleName,
                                               initialProperties: initialProperties) else {
            showErrorInViewController("无法创建 React Native 视图")
            return
        }
        
        setupReactNativeView(rnView, in: viewController)
    }
    
    private func setupReactNativeView(_ rnView: UIView, in viewController: UIViewController) {
        // 先移除可能存在的旧视图
        viewController.view.subviews.forEach { subview in
            if subview is RCTRootView || subview.accessibilityIdentifier == "ReactNativeView" {
                subview.removeFromSuperview()
            }
        }
        
        rnView.translatesAutoresizingMaskIntoConstraints = false
        rnView.accessibilityIdentifier = "ReactNativeView"
        viewController.view.addSubview(rnView)
        
        NSLayoutConstraint.activate([
            rnView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            rnView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            rnView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            rnView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        
        addCloseButton(to: viewController.view)
    }
    
    private func addCloseButton(to view: UIView) {
        // 先移除可能存在的旧关闭按钮
        view.subviews.forEach { subview in
            if let button = subview as? UIButton, button.accessibilityIdentifier == "RNCloseButton" {
                button.removeFromSuperview()
            }
        }
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle(Constants.closeButtonTitle, for: .normal)
        closeButton.backgroundColor = .systemRed.withAlphaComponent(0.8)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        closeButton.layer.cornerRadius = 6
        closeButton.layer.shadowOpacity = 0.3
        closeButton.layer.shadowRadius = 3
        closeButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        closeButton.accessibilityIdentifier = "RNCloseButton"
        
        closeButton.frame = CGRect(
            x: view.bounds.width - Constants.closeButtonSize.width - 20,
            y: 50,
            width: Constants.closeButtonSize.width,
            height: Constants.closeButtonSize.height
        )
        
        closeButton.addTarget(self, action: #selector(closeReactNative), for: .touchUpInside)
        view.addSubview(closeButton)
    }
    
    // MARK: - 关闭 RN 页面（不清理 Factory）
    @objc private func closeReactNative() {
        // 只清理当前视图，不清理 Factory
//        cleanupCurrentView()
        invalidateReactNative()
        // 关闭视图控制器
        hostViewController?.dismiss(animated: true) { [weak self] in
            self?.hostViewController = nil
        }
    }
    
    // MARK: - 内存管理方法
    private func cleanupCurrentView() {
        // 只清理当前视图相关的资源，不清理 Factory
        currentReactNativeView?.removeFromSuperview()
        currentReactNativeView = nil
        
        // 注意：这里不调用 bridge.invalidate()，因为 bridge 可能被多个视图共享
        // 只有在确定不再需要 RN 时才调用完整的清理
    }
    
    // 完整的清理方法（只在应用退出或确定不再需要 RN 时调用）
    @objc
    func invalidateReactNative() {
        print("🔄 执行完整的 React Native 清理...")
        
        // 清理当前视图
        cleanupCurrentView()
        
        // 清理 bridge（谨慎使用）
        currentBridge?.invalidate()
        currentBridge = nil
        
        // 清理 factory 和 delegate（这会使得下次需要重新初始化）
        reactNativeFactory = nil
        reactNativeDelegate = nil
        isInitialized = false
        
        print("✅ React Native 完整清理完成")
    }
    
    // 轻量级清理（推荐使用）
    @objc
    func cleanup() {
        print("🔄 执行轻量级清理...")
        cleanupCurrentView()
        hostViewController = nil
        print("✅ 轻量级清理完成")
    }
    
    private func showErrorInViewController(_ message: String) {
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        hostViewController?.present(alert, animated: true)
    }
    
    @objc
    func reload() {
        // 重新加载 RN 内容
        currentReactNativeView?.contentViewInvalidated()
        NotificationCenter.default.post(
            name: Notification.Name("ReloadReactNative"),
            object: nil
        )
    }
    
    @objc
    var isReactNativeInitialized: Bool {
        return isInitialized && reactNativeFactory != nil
    }
  
  @objc func sendEventToJS(eventName: String, data: [String: Any]) {
          DispatchQueue.main.async {
              EventEmitterModule.shared.sendEvent(withName: eventName, body: data)
          }
      }
      
      @objc func notifyReactNative(message: String) {
          EventEmitterModule.shared.sendMessage(message)
      }
      
      @objc func updateReactNative(data: [String: Any]) {
          EventEmitterModule.shared.sendDataUpdate(data)
      }
      
      @objc func notifyStatusChange(status: String) {
          EventEmitterModule.shared.sendStatusChange(status)
      }
      
      // 在 RN 页面显示时发送事件
      @objc func onReactNativeScreenAppear() {
          let screenInfo: [String: Any] = [
              "screen": "ReactNative",
              "appearTime": Date().timeIntervalSince1970,
              "managerStatus": "active"
          ]
          
          EventEmitterModule.shared.sendCustomEvent("screenAppear", data: screenInfo)
      }
      
      // 在 RN 页面消失时发送事件
      @objc func onReactNativeScreenDisappear() {
          EventEmitterModule.shared.sendStatusChange("background")
      }
      
      // 处理来自原生的消息并转发到 RN
      @objc func handleNativeNotification(_ notification: Notification) {
          guard let userInfo = notification.userInfo else { return }
          
          // 直接转换并发送
          var convertedDict: [String: Any] = [:]
          for (key, value) in userInfo {
              if let stringKey = key as? String {
                  convertedDict[stringKey] = value
              }
          }
          
          if !convertedDict.isEmpty {
              EventEmitterModule.shared.sendCustomEvent("nativeNotification", data: convertedDict)
          }
      }
}

class CustomReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
    override func sourceURL(for bridge: RCTBridge) -> URL? {
        return self.bundleURL()
    }

    override func bundleURL() -> URL? {
#if DEBUG
        return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
#else
        return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
#endif
    }
}
