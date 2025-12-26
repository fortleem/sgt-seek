import { gql } from '@apollo/client';
import * as Apollo from '@apollo/client';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
const defaultOptions = {} as const;
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
};

export type CommissionLock = {
  __typename?: 'CommissionLock';
  amount: Scalars['String']['output'];
  commissionType: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  lockStatus: Scalars['String']['output'];
};

export type MutationRoot = {
  __typename?: 'MutationRoot';
  advanceTradeState: TradeRequest;
};


export type MutationRootAdvanceTradeStateArgs = {
  id: Scalars['String']['input'];
  nextStep: Scalars['String']['input'];
};

export type QueryRoot = {
  __typename?: 'QueryRoot';
  commissionLocks: Array<CommissionLock>;
  tradeRequests: Array<TradeRequest>;
};

export type TradeRequest = {
  __typename?: 'TradeRequest';
  amount: Scalars['String']['output'];
  createdAt: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  negotiationStep: Scalars['Int']['output'];
  productCategory: Scalars['String']['output'];
  status: Scalars['String']['output'];
};

export type GetDashboardDataQueryVariables = Exact<{ [key: string]: never; }>;


export type GetDashboardDataQuery = { __typename?: 'QueryRoot', tradeRequests: Array<{ __typename?: 'TradeRequest', id: string, productCategory: string, amount: string, status: string, negotiationStep: number, createdAt: string }>, commissionLocks: Array<{ __typename?: 'CommissionLock', id: string, commissionType: string, amount: string, lockStatus: string }> };


export const GetDashboardDataDocument = gql`
    query GetDashboardData {
  tradeRequests {
    id
    productCategory
    amount
    status
    negotiationStep
    createdAt
  }
  commissionLocks {
    id
    commissionType
    amount
    lockStatus
  }
}
    `;

/**
 * __useGetDashboardDataQuery__
 *
 * To run a query within a React component, call `useGetDashboardDataQuery` and pass it any options that fit your needs.
 * When your component renders, `useGetDashboardDataQuery` returns an object from Apollo Client that contains loading, error, and data properties
 * you can use to render your UI.
 *
 * @param baseOptions options that will be passed into the query, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options;
 *
 * @example
 * const { data, loading, error } = useGetDashboardDataQuery({
 *   variables: {
 *   },
 * });
 */
export function useGetDashboardDataQuery(baseOptions?: Apollo.QueryHookOptions<GetDashboardDataQuery, GetDashboardDataQueryVariables>) {
        const options = {...defaultOptions, ...baseOptions}
        return Apollo.useQuery<GetDashboardDataQuery, GetDashboardDataQueryVariables>(GetDashboardDataDocument, options);
      }
export function useGetDashboardDataLazyQuery(baseOptions?: Apollo.LazyQueryHookOptions<GetDashboardDataQuery, GetDashboardDataQueryVariables>) {
          const options = {...defaultOptions, ...baseOptions}
          return Apollo.useLazyQuery<GetDashboardDataQuery, GetDashboardDataQueryVariables>(GetDashboardDataDocument, options);
        }
// @ts-ignore
export function useGetDashboardDataSuspenseQuery(baseOptions?: Apollo.SuspenseQueryHookOptions<GetDashboardDataQuery, GetDashboardDataQueryVariables>): Apollo.UseSuspenseQueryResult<GetDashboardDataQuery, GetDashboardDataQueryVariables>;
export function useGetDashboardDataSuspenseQuery(baseOptions?: Apollo.SkipToken | Apollo.SuspenseQueryHookOptions<GetDashboardDataQuery, GetDashboardDataQueryVariables>): Apollo.UseSuspenseQueryResult<GetDashboardDataQuery | undefined, GetDashboardDataQueryVariables>;
export function useGetDashboardDataSuspenseQuery(baseOptions?: Apollo.SkipToken | Apollo.SuspenseQueryHookOptions<GetDashboardDataQuery, GetDashboardDataQueryVariables>) {
          const options = baseOptions === Apollo.skipToken ? baseOptions : {...defaultOptions, ...baseOptions}
          return Apollo.useSuspenseQuery<GetDashboardDataQuery, GetDashboardDataQueryVariables>(GetDashboardDataDocument, options);
        }
export type GetDashboardDataQueryHookResult = ReturnType<typeof useGetDashboardDataQuery>;
export type GetDashboardDataLazyQueryHookResult = ReturnType<typeof useGetDashboardDataLazyQuery>;
export type GetDashboardDataSuspenseQueryHookResult = ReturnType<typeof useGetDashboardDataSuspenseQuery>;
export type GetDashboardDataQueryResult = Apollo.QueryResult<GetDashboardDataQuery, GetDashboardDataQueryVariables>;