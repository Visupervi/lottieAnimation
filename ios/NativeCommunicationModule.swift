import Foundation
import React

@objc(NativeCommunicationModule)
class NativeCommunicationModule: NSObject {
    
    // 使用计算属性获取 EventEmitterModule 实例
//    private var eventEmitter: EventEmitterModule? {
//        // 延迟获取，确保模块已初始化
//        return EventEmitterModule.shared
//    }
    
    // 必须实现的方法 - 导出模块名称
    @objc static func moduleName() -> String {
        return "NativeCommunicationModule"
    }
    
    // 可选：指定在主线程执行
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    // 导出常量到 JavaScript
    @objc func constantsToExport() -> [String: Any]! {
        return [
            "moduleVersion": "1.0.0",
            "platform": "iOS"
        ]
    }
    
    // MARK: - Promise 方式
    @objc
    func getIntegrationInfo(_ message:String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
          let info: [String: Any] = [
              "platform": "iOS",
              "reactNativeVersion": "0.80+",
              "integrationMethod": "RCTReactNativeFactory + EventEmitter",
              "timestamp": Date().timeIntervalSince1970
          ]
        print("📱 收到 RN 消息: \(message)")
          resolve(info)
      }
    
    // MARK: - 集成 Event Emitter 的方法
    
    // JS 发送消息到 Native
    @objc(sendToNative:)
    func sendToNative(_ message: String) {
        print("📱 收到 RN 消息: \(message)")
        sendMessageViaBridge(message)
//      if let bridge = RCTBridge.current(),
//         let eventEmitter = bridge.module(for: EventEmitterModule.self) as? EventEmitterModule {
//        print("bridge is not nil")
//          eventEmitter.sendMessageToRN("已收到: \(message)")
//      }
//      else {
//        print("bridge is nil")
//      }
//      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//                  appDelegate.sendMessageToRN("NativeCommunicationModule 回复: \(message)")
//              }
        
      
//        DispatchQueue.main.async {
//            print("📱 收到 RN 消息: \(message)")
            
            // 通知原生系统
//            NotificationCenter.default.post(
//                name: Notification.Name("ReactNativeMessage"),
//                object: nil,
//                userInfo: ["message": message]
//            )
            
            // 延迟发送回复，确保 EventEmitter 已初始化
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//                self?.eventEmitter?.sendMessage("已收到消息: \(message)")
//            }
            
            // 根据消息内容发送不同的事件
//            self.handleJSMessage(message)
        }
  private func sendMessageViaBridge(_ message: String) {
      guard let bridge = RCTBridge.current() else {
          print("❌ 无法获取 bridge")
          return
      }
      
      DispatchQueue.main.async {
          if let eventEmitter = bridge.module(for: EventEmitterModule.self) as? EventEmitterModule {
              eventEmitter.sendMessageToRN(message)
          } else {
              print("❌ 无法获取 EventEmitterModule 实例")
          }
      }
  }
    }
    
    // Native 主动发送事件到 JS
//    @objc
//    func triggerCustomEvent(_ eventType: String, data: [String: Any]?) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            self?.eventEmitter?.sendCustomEvent(eventType, data: data)
//        }
//    }
    
    // 更新数据并通知 JS
//    @objc
//    func updateAndNotify(_ data: [String: Any]) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            self?.eventEmitter?.sendDataUpdate(data)
//        }
//    }
    
    // 发送状态变化
//    @objc
//    func notifyStatusChange(_ status: String, info: [String: Any]?) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            self?.eventEmitter?.sendStatusChange(status, extraInfo: info)
//        }
//    }
    
    // 检查 Event Emitter 状态
//    @objc
//    func getEmitterStatus(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
//        let status: [String: Any] = [
//            "isBeingObserved": eventEmitter?.isBeingObserved ?? false,
//            "supportedEvents": eventEmitter?.supportedEvents() ?? [],
//            "timestamp": Date().timeIntervalSince1970
//        ]
//        resolve(status)
//    }
    
    // 简单的同步方法示例
//    @objc
//    func getDeviceInfoSync() -> [String: Any] {
//        return [
//            "platform": "iOS",
//            "systemVersion": UIDevice.current.systemVersion,
//            "model": UIDevice.current.model,
//            "timestamp": Date().timeIntervalSince1970
//        ]
//    }
    
    // MARK: - 私有方法
    
    // 处理 JS 消息
//    private func handleJSMessage(_ message: String) {
//        switch message {
//        case _ where message.contains("getInfo"):
//            sendAppInfo()
//            
//        case _ where message.contains("reload"):
//            sendAppInfo()
//            
//        case _ where message.contains("error"):
//            sendError("JS_ERROR", "JS 报告错误: \(message)")
//            
//        default:
//            // 延迟发送确认事件
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//                self?.eventEmitter?.sendCustomEvent("messageProcessed", data: [
//                    "originalMessage": message,
//                    "processedAt": Date().timeIntervalSince1970
//                ])
//            }
//        }
//    }
    
//    private func sendAppInfo() {
//        let appInfo: [String: Any] = [
//            "appName": Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Unknown",
//            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0",
//            "build": Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1",
//            "deviceModel": UIDevice.current.model,
//            "systemVersion": UIDevice.current.systemVersion
//        ]
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            self?.eventEmitter?.sendDataUpdate(appInfo)
//        }
//    }
//    
//    private func sendError(_ code: String, _ message: String) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            self?.eventEmitter?.sendError(code, errorMessage: message)
//        }
//    }
//}
