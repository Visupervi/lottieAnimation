//
//  LottieBridge.mm
//  lottieAnimation
//
//  Created by Visupervi on 2025/11/5.
//

#import "lottieAnimation-Bridging-Header.h"
// EventEmitterModule - 事件发射器
@interface RCT_EXTERN_MODULE(EventEmitterModule, RCTEventEmitter)

RCT_EXTERN_METHOD(sendMessage:(NSString *)message)
RCT_EXTERN_METHOD(sendDataUpdate:(NSDictionary *)data)
RCT_EXTERN_METHOD(sendStatusChange:(NSString *)status extraInfo:(NSDictionary *)extraInfo)
RCT_EXTERN_METHOD(sendCustomEvent:(NSString *)eventType data:(NSDictionary *)data)
RCT_EXTERN_METHOD(sendError:(NSString *)errorCode errorMessage:(NSString *)errorMessage details:(NSDictionary *)details)
RCT_EXTERN_METHOD(sendBatchEvents:(NSArray *)events)

// 同步属性访问
RCT_EXTERN__BLOCKING_SYNCHRONOUS_METHOD(isBeingObserved)

@end

// NativeCommunicationModule - 功能模块
@interface RCT_EXTERN_MODULE(NativeCommunicationModule, NSObject)

// Promise 方法
RCT_EXTERN_METHOD(getIntegrationInfo:(NSString *)message resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
//RCT_EXTERN_METHOD(getEmitterStatus:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)

// 普通方法
RCT_EXTERN_METHOD(sendToNative:(NSString *)message)
//RCT_EXTERN_METHOD(triggerCustomEvent:(NSString *)eventType data:(NSDictionary *)data)
//RCT_EXTERN_METHOD(updateAndNotify:(NSDictionary *)data)
//RCT_EXTERN_METHOD(notifyStatusChange:(NSString *)status info:(NSDictionary *)info)

// 同步方法
//RCT_EXTERN__BLOCKING_SYNCHRONOUS_METHOD(getDeviceInfoSync)

@end
