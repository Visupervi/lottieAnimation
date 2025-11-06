import Foundation
import React

// EventEmitterModule.swift
@objc(EventEmitterModule)
class EventEmitterModule: RCTEventEmitter {
    
    private var hasListeners = false
    
    override func supportedEvents() -> [String]! {
        return ["onNativeMessage"]
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return false
    }
    
    override func startObserving() {
        hasListeners = true
    }
    
    override func stopObserving() {
        hasListeners = false
    }
    
    // 提供给其他模块调用的方法
    @objc func sendMessageToRN(_ message: String) {
        guard hasListeners else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.sendEvent(withName: "onNativeMessage", body: [
                "message": message,
                "timestamp": Date().timeIntervalSince1970
            ])
        }
    }
}
