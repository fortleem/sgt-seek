'use client';
import React, { useEffect, useState } from 'react';

export default function Analytics() {
  const [stats, setStats] = useState({ total_deployed: 0, interest: 0, at_risk: 0 });

  useEffect(() => {
    // Simulated aggregation from Settlement Ledger & Trade Service
    setStats({
      total_deployed: 12450000.00,
      interest: 186750.00,
      at_risk: 450000.00
    });
  }, []);

  return (
    <div className="p-10 bg-slate-50 min-h-screen font-sans text-slate-900">
      <h1 className="text-4xl font-black mb-2 uppercase tracking-tighter italic">Portfolio Analytics</h1>
      <p className="text-slate-500 mb-10">Consolidated Financial Exposure & Revenue Projection</p>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
        <div className="bg-white p-8 rounded-2xl border shadow-sm">
          <p className="text-xs font-bold text-slate-400 uppercase mb-1">Total Capital Deployed</p>
          <p className="text-3xl font-mono font-bold text-slate-900">$ {stats.total_deployed.toLocaleString()}</p>
        </div>
        <div className="bg-white p-8 rounded-2xl border shadow-sm border-green-200">
          <p className="text-xs font-bold text-green-600 uppercase mb-1">Total Interest Accrued</p>
          <p className="text-3xl font-mono font-bold text-green-700">$ {stats.interest.toLocaleString()}</p>
        </div>
        <div className="bg-white p-8 rounded-2xl border shadow-sm border-red-200">
          <p className="text-xs font-bold text-red-600 uppercase mb-1">Capital At Risk (AI Flagged)</p>
          <p className="text-3xl font-mono font-bold text-red-700">$ {stats.at_risk.toLocaleString()}</p>
        </div>
      </div>

      <div className="bg-slate-900 text-white p-10 rounded-3xl shadow-2xl overflow-hidden relative">
        <div className="relative z-10">
            <h2 className="text-2xl font-bold mb-4">Risk Distribution by Region</h2>
            <div className="flex gap-2">
                <div className="h-4 w-1/2 bg-green-500 rounded-full" title="EMEA"></div>
                <div className="h-4 w-1/4 bg-yellow-500 rounded-full" title="APAC"></div>
                <div className="h-4 w-1/4 bg-red-500 rounded-full" title="AMER"></div>
            </div>
            <div className="flex justify-between mt-4 text-xs font-bold text-slate-400">
                <span>EMEA (50%)</span>
                <span>APAC (25%)</span>
                <span>AMER (25%)</span>
            </div>
        </div>
        <div className="absolute -right-20 -bottom-20 w-64 h-64 bg-blue-600 rounded-full opacity-20 blur-3xl"></div>
      </div>
      
      <a href="/" className="inline-block mt-10 text-slate-500 font-bold hover:text-slate-900">← Back to Trade Portal</a>
    </div>
  );
}
