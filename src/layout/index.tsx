// import {createNativeStackNavigator} from '@react-navigation/native-stack';
import { createStackNavigator, CardStyleInterpolators } from '@react-navigation/stack';
import Home from '../pages/home';
import RunDog from '../pages/rundog';
import HeartLottie from '../pages/heartLottie';
import CatKist from '../pages/catKist';
import FlyingBird from '../pages/flyingBird';
import Unicorn from '../pages/unicorn';
import Dance from '../pages/dance';
import Bear from '../pages/bear';
import px2dp from '../utils'
const Stack = createStackNavigator();
const GESTURE_DISTANCE = px2dp(600); // 多远距离就可以向右滑走

const GESTURE_OPTION:any = {
  headerShown: false,
  gestureEnabled: true, // 从左向右滑可以关闭页面
  gestureResponseDistance: GESTURE_DISTANCE,
  gestureDirection: 'horizontal',
  // gestureDirection: 'horizontal',
  // android一定要设置，才能从右到左打开新页，并且支持滑动关闭
  cardStyleInterpolator: CardStyleInterpolators.forHorizontalIOS,

};
export default () => {
  return (
    <>
      <Stack.Navigator
        initialRouteName="Home"
      >
        <Stack.Screen
          name="Home"
          component={Home}
          options={GESTURE_OPTION}
        />
        <Stack.Screen
          name="RunDog"
          component={RunDog}
          options={GESTURE_OPTION}
        />
        <Stack.Screen
          name="HeartLottie"
          component={HeartLottie}
          options={GESTURE_OPTION}
        />
        <Stack.Screen
          name="Unicorn"
          component={Unicorn}
          options={GESTURE_OPTION}
        />
        <Stack.Screen
          name="FlyingBird"
          component={FlyingBird}
          options={GESTURE_OPTION}
        />
        <Stack.Screen
          name="CatKist"
          component={CatKist}
          options={GESTURE_OPTION}
        />
        <Stack.Screen
          name="Dance"
          component={Dance}
          options={GESTURE_OPTION}
        />
        <Stack.Screen
          name="Bear"
          component={Bear}
          options={GESTURE_OPTION}
        />
      </Stack.Navigator>
    </>
  )
}