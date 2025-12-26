'use client';
import { useQuery, gql } from '@apollo/client';
const HEALTH = gql`query Health { health }`;
export default function HealthPage() {
  const { data, loading, error } = useQuery(HEALTH);
  return (
    <div className="p-10 font-mono">
      <h1 className="text-xl font-bold mb-4 uppercase">System Diagnostic</h1>
      <div className="p-4 bg-white border rounded shadow-sm">
        {loading && <p>Probing Port 8080...</p>}
        {data && <p className="text-green-600 font-bold">● GOVERNOR API ONLINE: {data.health}</p>}
        {error && <p className="text-red-600">● GOVERNOR API OFFLINE: {error.message}</p>}
      </div>
    </div>
  );
}
