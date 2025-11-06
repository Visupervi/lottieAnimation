import { View, Text, SafeAreaView, Button, StyleSheet } from 'react-native';
import {} from 'react-native';
import LottieView from 'lottie-react-native';
import {useNavigation} from '@react-navigation/native'
export default () => {
  const navigation:any = useNavigation();
  return (
    <>
      <SafeAreaView>
        <LottieView
          source={require("../../animationConfig/Run Dog Run.json")}
          style={{width: "100%", height: "95%"}}
          autoPlay
          loop
        />
        <View style={styles.btnWrapper}>
          <Button
            title="上一个"
            onPress={() => navigation.goBack()}
          />
          <Button
            title="下一个"
            onPress={() => navigation.navigate('HeartLottie')}
          />
        </View>
      </SafeAreaView>
    </>
  );
}

const styles = StyleSheet.create({
  btnWrapper: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "center",
  }
})