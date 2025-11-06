import UIKit
import React

class ViewController: UIViewController {
    
    private let moduleName = "lottieAnimation"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 不再在这里初始化，让 RN Manager 按需初始化
    }
    
    deinit {
        // 只在视图控制器销毁时进行轻量级清理
        ReactNativeViewManager.shared.cleanup()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "React Native 集成示例"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 20, y: 80, width: view.bounds.width - 40, height: 40)
        view.addSubview(titleLabel)
        
        // 打开完整 RN 页面按钮
        let openFullScreenButton = UIButton(type: .system)
        openFullScreenButton.setTitle("打开完整 RN 页面", for: .normal)
        openFullScreenButton.backgroundColor = .systemGreen
        openFullScreenButton.setTitleColor(.white, for: .normal)
        openFullScreenButton.layer.cornerRadius = 8
        openFullScreenButton.frame = CGRect(x: (view.bounds.width - 200) / 2, y: 140, width: 200, height: 44)
        openFullScreenButton.addTarget(self, action: #selector(openFullReactNativeScreen), for: .touchUpInside)
        view.addSubview(openFullScreenButton)
//        
//        // 轻量级清理按钮
//        let cleanupButton = UIButton(type: .system)
//        cleanupButton.setTitle("清理 RN 视图", for: .normal)
//        cleanupButton.backgroundColor = .systemOrange
//        cleanupButton.setTitleColor(.white, for: .normal)
//        cleanupButton.layer.cornerRadius = 8
//        cleanupButton.frame = CGRect(x: (view.bounds.width - 200) / 2, y: 200, width: 200, height: 44)
//        cleanupButton.addTarget(self, action: #selector(cleanupReactNative), for: .touchUpInside)
//        view.addSubview(cleanupButton)
//        
//        // 完整清理按钮（谨慎使用）
//        let fullCleanupButton = UIButton(type: .system)
//        fullCleanupButton.setTitle("完整清理 RN", for: .normal)
//        fullCleanupButton.backgroundColor = .systemRed
//        fullCleanupButton.setTitleColor(.white, for: .normal)
//        fullCleanupButton.layer.cornerRadius = 8
//        fullCleanupButton.frame = CGRect(x: (view.bounds.width - 200) / 2, y: 260, width: 200, height: 44)
//        fullCleanupButton.addTarget(self, action: #selector(fullCleanupReactNative), for: .touchUpInside)
//        view.addSubview(fullCleanupButton)
        
        // 状态标签
        let statusLabel = UILabel()
        statusLabel.text = "React Native 0.80+ 集成"
        statusLabel.textAlignment = .center
        statusLabel.textColor = .systemGray
        statusLabel.frame = CGRect(x: 20, y: 320, width: view.bounds.width - 40, height: 30)
        view.addSubview(statusLabel)
    }
    
    @objc private func openFullReactNativeScreen() {
        // RN Manager 会按需初始化，不需要手动检查
        let rnViewController = UIViewController()
        rnViewController.view.backgroundColor = .systemBackground
        rnViewController.title = "React Native 页面"
        
        let initialProperties: [String: Any] = [
            "integrationType": "fullscreen",
            "platform": "iOS",
            "timestamp": Date().timeIntervalSince1970
        ]
        
        ReactNativeViewManager.shared.startReactNativeInViewController(
            moduleName: moduleName,
            viewController: rnViewController,
            initialProperties: initialProperties
        )
        
        rnViewController.modalPresentationStyle = .fullScreen
        present(rnViewController, animated: true)
    }
    
    @objc private func cleanupReactNative() {
        // 轻量级清理（推荐）
        ReactNativeViewManager.shared.cleanup()
        showAlert("清理完成", "RN 视图已清理，Factory 保持可用")
    }
    
    @objc private func fullCleanupReactNative() {
        // 完整清理（谨慎使用）
        let alert = UIAlertController(
            title: "确认完整清理",
            message: "这将释放所有 RN 资源，下次打开需要重新初始化。确定要继续吗？",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确定", style: .destructive) { _ in
            ReactNativeViewManager.shared.invalidateReactNative()
            self.showAlert("完整清理完成", "所有 RN 资源已释放")
        })
        
        present(alert, animated: true)
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
