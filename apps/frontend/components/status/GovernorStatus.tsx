"use client";
import React, { useEffect, useState } from 'react';

export default function GovernorStatus() {
  const [status, setStatus] = useState<'CONNECTING' | 'LIVE' | 'OFFLINE'>('CONNECTING');
  const [latency, setLatency] = useState<number | null>(null);

  const checkStatus = async () => {
    const start = performance.now();
    try {
      const res = await fetch('http://127.0.0.1:8080/graphql', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ query: '{ __typename }' }),
      });
      if (res.ok) {
        setLatency(Math.round(performance.now() - start));
        setStatus('LIVE');
      } else {
        setStatus('OFFLINE');
      }
    } catch (e) {
      setStatus('OFFLINE');
    }
  };

  useEffect(() => {
    checkStatus();
    const interval = setInterval(checkStatus, 5000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="flex items-center gap-3 px-4 py-2 bg-white border border-slate-200 rounded-full shadow-sm">
      <div className="relative flex h-3 w-3">
        {status === 'LIVE' && (
          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
        )}
        <span className={`relative inline-flex rounded-full h-3 w-3 ${
          status === 'LIVE' ? 'bg-green-500' : status === 'OFFLINE' ? 'bg-red-500' : 'bg-amber-500'
        }`}></span>
      </div>
      <span className="text-[10px] font-mono font-bold text-slate-700 uppercase">
        Gov: {status}
      </span>
      {latency && status === 'LIVE' && (
        <span className="text-[10px] text-slate-400 border-l pl-2">{latency}ms</span>
      )}
    </div>
  );
}
