import { NavigationContainer } from '@react-navigation/native';
import Layout from './src/layout'

export default (props:any) => {
  return(
    <>
      <NavigationContainer>
          <Layout></Layout>
      </NavigationContainer>
    </>
  )
}