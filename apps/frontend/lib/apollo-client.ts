import { ApolloClient, InMemoryCache, HttpLink } from '@apollo/client';

const client = new ApolloClient({
  link: new HttpLink({
    // Using 127.0.0.1 explicitly to avoid macOS localhost resolution issues
    uri: 'http://127.0.0.1:8080/graphql',
    fetchOptions: {
      mode: 'cors',
    },
  }),
  cache: new InMemoryCache(),
  defaultOptions: {
    watchQuery: { fetchPolicy: 'network-only' },
    query: { fetchPolicy: 'network-only' },
  },
});

export default client;
