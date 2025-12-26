export default function CommissionCard({ commissionType, amount, lockStatus }: any) {
  return (
    <div className="bg-slate-900 p-6 rounded-2xl text-white border border-slate-800">
      <p className="text-[10px] text-slate-500 font-mono mb-1 uppercase tracking-tighter">{lockStatus}</p>
      <h4 className="font-bold text-slate-200">{commissionType}</h4>
      <p className="text-xl font-mono text-emerald-400 mt-2">${parseFloat(amount).toLocaleString()}</p>
    </div>
  );
}
