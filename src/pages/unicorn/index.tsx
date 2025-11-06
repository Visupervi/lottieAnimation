import { View, Text, SafeAreaView, Button, StyleSheet } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import {} from 'react-native';
import LottieView from 'lottie-react-native';
import { useNavigation } from '@react-navigation/native';

export default () => {
  const navigation: any = useNavigation();
  return (
    <SafeAreaProvider>
      <LottieView
        source={require('../../animationConfig/Unicorn.json')}
        style={{ width: '100%', height: '95%' }}
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
          onPress={() => navigation.navigate('Dance')}
        />
      </View>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  btnWrapper: {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'center',
  },
});