import {Dimensions, Platform, PixelRatio} from 'react-native';
const windowWidth: number = Dimensions.get('window').width;

export  default function px2dp(size:number) {
  if (PixelRatio.get() >= 3 && Platform.OS === 'ios' && size === 1) {
    return size;
  }
  return parseInt((windowWidth / 750 * size * 100).toString(), 10) / 100;
}