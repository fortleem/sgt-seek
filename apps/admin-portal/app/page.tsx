'use client';
import React, { useEffect, useState } from 'react';

export default function Dashboard() {
  const [trades, setTrades] = useState([]);
  const [formData, setFormData] = useState({ commodity: '', quantity: 0, price: 0, description: '' });

  const fetchTrades = () => {
    fetch('/api/trades').then(res => res.json()).then(data => setTrades(data));
  };

  useEffect(() => { fetchTrades(); }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const res = await fetch('/api/trades/new', {
      method: 'POST',
      body: JSON.stringify(formData),
    });
    if (res.ok) {
      setFormData({ commodity: '', quantity: 0, price: 0, description: '' });
      fetchTrades();
    }
  };

  return (
    <div className="p-8 font-sans bg-slate-50 min-h-screen text-slate-900">
      <header className="mb-8 flex justify-between items-center">
        <div>
            <h1 className="text-3xl font-bold text-slate-900">SGT Global Trade Portal</h1>
            <p className="text-slate-500 text-lg">AI-Driven Trade Finance & Compliance</p>
        </div>
        <div className="flex gap-4">
            <div className="bg-blue-100 text-blue-700 px-4 py-2 rounded-lg text-sm font-bold">AI: DistilBERT Active</div>
            <div className="bg-green-100 text-green-700 px-4 py-2 rounded-lg text-sm font-bold uppercase">System: Online</div>
        </div>
      </header>

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
        {/* Trade Form */}
        <div className="lg:col-span-1 bg-white p-6 border rounded-xl shadow-md h-fit">
          <h2 className="text-xl font-bold mb-4 border-b pb-2">Initiate Trade</h2>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-xs font-bold text-slate-500 uppercase">Commodity</label>
              <input type="text" value={formData.commodity} onChange={e => setFormData({...formData, commodity: e.target.value})} className="w-full p-2 border rounded mt-1 bg-slate-50" placeholder="e.g. CRUDE_OIL" required />
            </div>
            <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block text-xs font-bold text-slate-500 uppercase">Qty</label>
                  <input type="number" value={formData.quantity} onChange={e => setFormData({...formData, quantity: parseFloat(e.target.value)})} className="w-full p-2 border rounded mt-1 bg-slate-50" required />
                </div>
                <div>
                  <label className="block text-xs font-bold text-slate-500 uppercase">Price</label>
                  <input type="number" value={formData.price} onChange={e => setFormData({...formData, price: parseFloat(e.target.value)})} className="w-full p-2 border rounded mt-1 bg-slate-50" required />
                </div>
            </div>
            <div>
              <label className="block text-xs font-bold text-slate-500 uppercase">Description (AI Target)</label>
              <textarea value={formData.description} onChange={e => setFormData({...formData, description: e.target.value})} className="w-full p-2 border rounded mt-1 bg-slate-50" rows={3} placeholder="Describe trade conditions..." />
            </div>
            <button type="submit" className="w-full bg-slate-900 text-white p-3 rounded-lg font-bold hover:bg-black transition-all shadow-lg">Submit for AI Review</button>
          </form>
        </div>

        {/* Trade List with Intelligence */}
        <div className="lg:col-span-3 bg-white border rounded-xl shadow-md overflow-hidden">
          <table className="w-full text-left border-collapse">
            <thead className="bg-slate-900 text-white">
              <tr>
                <th className="p-4 font-semibold text-sm uppercase">Trade ID</th>
                <th className="p-4 font-semibold text-sm uppercase">Commodity</th>
                <th className="p-4 font-semibold text-sm uppercase">Quantity</th>
                <th className="p-4 font-semibold text-sm uppercase">AI Recommendation</th>
                <th className="p-4 font-semibold text-sm uppercase">Status</th>
              </tr>
            </thead>
            <tbody>
              {trades.map((trade: any) => (
                <tr key={trade.id} className="border-b hover:bg-slate-50 transition-colors">
                  <td className="p-4 font-mono text-xs text-slate-500">#{trade.id.substring(0,8)}</td>
                  <td className="p-4 font-bold">{trade.commodity_type}</td>
                  <td className="p-4">{trade.quantity.toLocaleString()} MT</td>
                  <td className="p-4">
                    <span className={`px-3 py-1 rounded-full text-xs font-bold ${trade.quantity > 400000 ? 'bg-red-100 text-red-700' : 'bg-green-100 text-green-700'}`}>
                       {trade.quantity > 400000 ? '⚠ FLAG_FOR_AUDIT' : '✓ PROCEED'}
                    </span>
                  </td>
                  <td className="p-4">
                    <span className="px-2 py-1 bg-blue-100 text-blue-700 rounded text-xs font-black uppercase tracking-tighter">{trade.status}</span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
