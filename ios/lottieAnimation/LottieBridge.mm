//
//  LottieBridge.mm
//  lottieAnimation
//
//  Created by Visupervi on 2025/11/5.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
@interface RCT_EXTERN_MODULE(NativeCommunicationModule, NSObject) //RCT_EXTERN_MODULE将模块导出到Reac-Native
RCT_EXTERN_METHOD(getIntegrationInfo)  //RCT_EXTERN_METHOD将方法导出到ReacNative
RCT_EXTERN_METHOD(sendToNative)  //RCT_EXTERN_METHOD将方法导出到ReacNative
RCT_EXTERN_METHOD(getEmitterStatus)  //RCT_EXTERN_METHOD将方法导出到ReacNative
RCT_EXTERN_METHOD(getDeviceInfoSync)  //RCT_EXTERN_METHOD将方法导出到ReacNative
RCT_EXTERN_METHOD(sendAppInfo)  //RCT_EXTERN_METHOD将方法导出到ReacNative
RCT_EXTERN_METHOD(sendError)  //RCT_EXTERN_METHOD将方法导出到ReacNative
@end
//@interface RCT_EXTERN_MODULE(EventEmitterModule, NSObject) //RCT_EXTERN_MODULE将模块导出到Reac-Native
//RCT_EXTERN_METHOD(sendMessage)  //RCT_EXTERN_METHOD将方法导出到ReacNative
//RCT_EXTERN_METHOD(sendDataUpdate)  //RCT_EXTERN_METHOD将方法导出到ReacNative
//RCT_EXTERN_METHOD(sendStatusChange)  //RCT_EXTERN_METHOD将方法导出到ReacNative
//RCT_EXTERN_METHOD(sendCustomEvent)  //RCT_EXTERN_METHOD将方法导出到ReacNative
//RCT_EXTERN_METHOD(sendBatchEvents)  //RCT_EXTERN_METHOD将方法导出到ReacNative
//@end
