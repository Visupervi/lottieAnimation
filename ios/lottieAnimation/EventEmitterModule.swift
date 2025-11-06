//
//  EventEmitterModule.swift
//  lottieAnimation
//
//  Created by Visupervi on 2025/11/5.
//

import Foundation
import React

@objc(EventEmitterModule)
class EventEmitterModule: RCTEventEmitter {
    
    // 单例实例
    @objc static let shared = EventEmitterModule()
    
    // 支持的事件列表
    override func supportedEvents() -> [String]! {
        return [
            "onNativeMessage",      // 原生消息事件
            "onDataUpdate",         // 数据更新事件
            "onStatusChange",       // 状态变化事件
            "onCustomEvent",        // 自定义事件
            "onTimerTick",          // 定时器事件
            "onNavigation",         // 导航事件
            "onError"               // 错误事件
        ]
    }
    
    // 必须重写，指定在主线程执行
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    // 检查是否有监听器
    private var hasListeners = false
    
    override func startObserving() {
        hasListeners = true
        print("✅ JS 开始监听原生事件")
        
        // 可以在这里启动一些服务，比如定时器
        startEventServices()
    }
    
    override func stopObserving() {
        hasListeners = false
        print("🛑 JS 停止监听原生事件")
        
        // 停止相关服务
        stopEventServices()
    }
    
    // MARK: - 事件发送方法
    
    // 发送消息事件
    @objc func sendMessage(_ message: String) {
        sendEvent(withName: "onNativeMessage", body: [
            "message": message,
            "timestamp": Date().timeIntervalSince1970,
            "type": "message"
        ])
    }
    
    // 发送数据更新事件
    @objc func sendDataUpdate(_ data: [String: Any]) {
        sendEvent(withName: "onDataUpdate", body: [
            "data": data,
            "timestamp": Date().timeIntervalSince1970,
            "type": "dataUpdate"
        ])
    }
    
    // 发送状态变化事件
    @objc func sendStatusChange(_ status: String, extraInfo: [String: Any]? = nil) {
        var body: [String: Any] = [
            "status": status,
            "timestamp": Date().timeIntervalSince1970,
            "type": "statusChange"
        ]
        
        if let extraInfo = extraInfo {
            body.merge(extraInfo) { (current, _) in current }
        }
        
        sendEvent(withName: "onStatusChange", body: body)
    }
    
    // 发送自定义事件
    @objc func sendCustomEvent(_ eventType: String, data: [String: Any]? = nil) {
        var body: [String: Any] = [
            "eventType": eventType,
            "timestamp": Date().timeIntervalSince1970,
            "type": "custom"
        ]
        
        if let data = data {
            body["data"] = data
        }
        
        sendEvent(withName: "onCustomEvent", body: body)
    }
    
    // 发送错误事件
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
        
        sendEvent(withName: "onError", body: body)
    }
    
    // MARK: - 事件服务
    
    private var timer: Timer?
    
    private func startEventServices() {
        // 启动示例定时器
        startTimer()
    }
    
    private func stopEventServices() {
        stopTimer()
    }
    
    private func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.sendTimerTick()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func sendTimerTick() {
        sendEvent(withName: "onTimerTick", body: [
            "count": Int.random(in: 1...1000),
            "timestamp": Date().timeIntervalSince1970,
            "type": "timer"
        ])
    }
    
    // MARK: - 工具方法
    
    // 检查是否有活跃的监听器
    @objc var isBeingObserved: Bool {
        return hasListeners
    }
    
    // 批量发送事件
    @objc func sendBatchEvents(_ events: [[String: Any]]) {
        for event in events {
            if let eventName = event["name"] as? String,
               let eventData = event["data"] as? [String: Any] {
                sendEvent(withName: eventName, body: eventData)
            }
        }
    }
}
