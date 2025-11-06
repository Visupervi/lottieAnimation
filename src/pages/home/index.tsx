import { View, Text, Button, NativeModules, NativeEventEmitter } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import LottieView from 'lottie-react-native';
import { useNavigation } from '@react-navigation/native';
import { useEffect, useCallback, useState } from 'react';

console.log('NativeModule', NativeModules.NativeCommunicationModule);
// 定义消息类型
// interface AppMessage {
//   id: number;
//   text: string;
//   time: string;
// }

const { NativeCommunicationModule,EventEmitterModule } = NativeModules;
const {getIntegrationInfo, sendToNative} = NativeCommunicationModule;
const eventEmitter = new NativeEventEmitter(EventEmitterModule);
export default (props: any) => {
  const navigation = useNavigation()
  // eventEmitter.addListener()
  eventEmitter.addListener('onNativeMessage', data => {
    console.log('onNativeMessage', data);
  })
  let urlPath:string = "RunDog"
  const navigationHandle = useCallback(async () => {
    // navigation.navigate(urlPath);
    sendToNative("测试信息")
    // let res = await getIntegrationInfo("测试信息22222");
    // console.log('res',res);
  }, []);
  return (
    <SafeAreaProvider>
      <LottieView
        source={require('../../animationConfig/Orange skating.json')}
        style={{ width: '100%', height: '95%' }}
        autoPlay
        loop
      />
      <Button
        title="下一个"
        onPress={navigationHandle}
      />
    </SafeAreaProvider>
  );
}