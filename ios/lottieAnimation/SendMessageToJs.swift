import Foundation
import React

@objc(SendMessageToJs)
class SendMessageToJs: NSObject {

    // 通过 bridge 获取 EventEmitterModule 实例
    private var eventEmitter: EventEmitterModule? {
        return bridge?.module(for: EventEmitterModule.self) as? EventEmitterModule
    }

    @objc var bridge: RCTBridge?

    // MARK: - 模块配置
    @objc static func moduleName() -> String {
        return "SendMessageToJs"
    }

    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }

    // MARK: - 消息发送方法

    /// 发送普通消息到 RN
    @objc func sendMessage(_ message: String) {
        eventEmitter?.safeSendEvent(withName: "onNativeMessage", body: [
            "message": message,
            "timestamp": Date().timeIntervalSince1970,
            "type": "message"
        ])
    }

    /// 发送数据更新消息
    @objc func sendDataUpdate(_ data: [String: Any]) {
        eventEmitter?.safeSendEvent(withName: "onDataUpdate", body: [
            "data": data,
            "timestamp": Date().timeIntervalSince1970,
            "type": "dataUpdate"
        ])
    }

    /// 发送状态变化消息
    @objc func sendStatusChange(_ status: String, extraInfo: [String: Any]? = nil) {
        var body: [String: Any] = [
            "status": status,
            "timestamp": Date().timeIntervalSince1970,
            "type": "statusChange"
        ]

        if let extraInfo = extraInfo {
            body.merge(extraInfo) { (current, _) in current }
        }

        eventEmitter?.safeSendEvent(withName: "onStatusChange", body: body)
    }

    /// 发送自定义事件
    @objc func sendCustomEvent(_ eventType: String, data: [String: Any]? = nil) {
        var body: [String: Any] = [
            "eventType": eventType,
            "timestamp": Date().timeIntervalSince1970,
            "type": "custom"
        ]

        if let data = data {
            body["data"] = data
        }

        eventEmitter?.safeSendEvent(withName: "onCustomEvent", body: body)
    }

    /// 发送错误消息
    @objc func sendError(_ errorCode: String, errorMessage: String, details: [String: Any]? = nil) {
        var body: [String: Any] = [
            "errorCode": errorCode,
            "errorMessage": errorMessage,
            "timestamp": Date().timeIntervalSince1970,
            "type": "error"
        ]

        if let details = details {
            body["details"] = details
        }

        eventEmitter?.safeSendEvent(withName: "onError", body: body)
    }

    /// 通用消息发送方法
    @objc func sendEvent(_ eventName: String, body: [String: Any]?) {
        var eventBody = body ?? [:]
        eventBody["timestamp"] = Date().timeIntervalSince1970
        eventBody["type"] = "generic"

        eventEmitter?.safeSendEvent(withName: eventName, body: eventBody)
    }

    // MARK: - 便捷方法

    /// 发送成功消息
    @objc func sendSuccess(_ message: String) {
        sendMessage("[SUCCESS] \(message)")
    }

    /// 发送警告消息
    @objc func sendWarning(_ message: String) {
        sendMessage("[WARNING] \(message)")
    }

    /// 发送信息消息
    @objc func sendInfo(_ message: String) {
        sendMessage("[INFO] \(message)")
    }
}