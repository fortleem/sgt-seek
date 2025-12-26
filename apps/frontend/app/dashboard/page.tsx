"use client";
import { useShipments } from "@/lib/shipments/useShipments";
import GovernorStatus from "@/components/status/GovernorStatus";
import TradeCard from "./components/TradeCard";
import CommissionCard from "./components/CommissionCard";

export default function DashboardPage() {
  const { shipments, commissionLocks, loading, error } = useShipments();

  return (
    <main className="min-h-screen bg-slate-50 p-8">
      <header className="flex justify-between items-center mb-12">
        <div><h1 className="text-4xl font-black text-slate-900">SGT SEEK</h1></div>
        <GovernorStatus />
      </header>
      {!loading && !error && (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <div className="lg:col-span-2 space-y-6">
            <h2 className="text-sm font-bold text-slate-400 uppercase tracking-widest">Active Trades</h2>
            {shipments.map((s: any) => <TradeCard key={s.id} {...s} />)}
          </div>
          <div className="space-y-6">
            <h2 className="text-sm font-bold text-slate-400 uppercase tracking-widest">Commission Vault</h2>
            {commissionLocks.map((c: any) => <CommissionCard key={c.id} {...c} />)}
          </div>
        </div>
      )}
    </main>
  );
}
