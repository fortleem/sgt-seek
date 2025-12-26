import { useGetDashboardDataQuery } from "../graphql-types";
export function useShipments() {
  const { data, loading, error } = useGetDashboardDataQuery();
  return {
    shipments: data?.tradeRequests ?? [],
    commissionLocks: data?.commissionLocks ?? [],
    loading,
    error,
  };
}
