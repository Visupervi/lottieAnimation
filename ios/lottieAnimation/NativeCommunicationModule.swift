import Foundation
import React

@objc(NativeCommunicationModule)
class NativeCommunicationModule: NSObject {
    
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
    func getIntegrationInfo(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        let info: [String: Any] = [
            "platform": "iOS",
            "reactNativeVersion": "0.80+",
            "integrationMethod": "RCTReactNativeFactory + EventEmitter",
            "timestamp": Date().timeIntervalSince1970
        ]
        resolve(info)
    }
    
    // MARK: - 集成 Event Emitter 的方法
    
    // JS 发送消息到 Native
    @objc
    func sendToNative(_ message: String) {
        DispatchQueue.main.async {
            print("📱 收到 RN 消息: \(message)")
            
            // 通知原生系统
            NotificationCenter.default.post(
                name: Notification.Name("ReactNativeMessage"),
                object: nil,
                userInfo: ["message": message]
            )
            
            // 通过 Event Emitter 发送回复
            EventEmitterModule.shared.sendMessage("已收到消息: \(message)")
            
            // 根据消息内容发送不同的事件
            self.handleJSMessage(message)
        }
    }
    
    // Native 主动发送事件到 JS
    @objc
    func triggerCustomEvent(_ eventType: String, data: [String: Any]?) {
        EventEmitterModule.shared.sendCustomEvent(eventType, data: data)
    }
    
    // 更新数据并通知 JS
    @objc
    func updateAndNotify(_ data: [String: Any]) {
        // 通知 JS 数据已更新
        EventEmitterModule.shared.sendDataUpdate(data)
    }
    
    // 发送状态变化
    @objc
    func notifyStatusChange(_ status: String, info: [String: Any]?) {
        EventEmitterModule.shared.sendStatusChange(status, extraInfo: info)
    }
    
    // 检查 Event Emitter 状态
    @objc
    func getEmitterStatus(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        let status: [String: Any] = [
            "isBeingObserved": EventEmitterModule.shared.isBeingObserved,
            "supportedEvents": EventEmitterModule.shared.supportedEvents(),
            "timestamp": Date().timeIntervalSince1970
        ]
        resolve(status)
    }
    
    // 简单的同步方法示例
    @objc
    func getDeviceInfoSync() -> [String: Any] {
        return [
            "platform": "iOS",
            "systemVersion": UIDevice.current.systemVersion,
            "model": UIDevice.current.model,
            "timestamp": Date().timeIntervalSince1970
        ]
    }
    
    // MARK: - 私有方法
    
    // 处理 JS 消息
    private func handleJSMessage(_ message: String) {
        switch message {
        case _ where message.contains("getInfo"):
            sendAppInfo()
            
        case _ where message.contains("reload"):
          sendAppInfo()
//          let info: [String: Any] = [
//              "isBeingObserved": EventEmitterModule.shared.isBeingObserved,
//              "supportedEvents": EventEmitterModule.shared.supportedEvents(),
//              "timestamp": Date().timeIntervalSince1970
//          ]
//          notifyStatusChange("reloading", info: [String : Any]?)
            
        case _ where message.contains("error"):
            sendError("JS_ERROR", "JS 报告错误: \(message)")
            
        default:
            // 发送确认事件
            EventEmitterModule.shared.sendCustomEvent("messageProcessed", data: [
                "originalMessage": message,
                "processedAt": Date().timeIntervalSince1970
            ])
        }
    }
    
    private func sendAppInfo() {
        let appInfo: [String: Any] = [
            "appName": Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Unknown",
            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0",
            "build": Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1",
            "deviceModel": UIDevice.current.model,
            "systemVersion": UIDevice.current.systemVersion
        ]
        
        EventEmitterModule.shared.sendDataUpdate(appInfo)
    }
    
    private func sendError(_ code: String, _ message: String) {
        EventEmitterModule.shared.sendError(code, errorMessage: message)
    }
}
