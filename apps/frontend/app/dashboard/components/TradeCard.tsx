"use client";
import { useMutation, gql } from "@apollo/client";

const ADVANCE_TRADE = gql`
  mutation AdvanceTrade($id: String!, $nextStep: String!) {
    advanceTradeState(id: $id, nextStep: $nextStep) {
      id
      status
    }
  }
`;

export default function TradeCard({ id, productCategory, amount, status }: any) {
  const [advanceTrade, { loading }] = useMutation(ADVANCE_TRADE, {
    refetchQueries: ["GetDashboardData"],
  });

  const handleAdvance = async () => {
    try {
      await advanceTrade({
        variables: { id, nextStep: "COMPLETED" },
        optimisticResponse: {
          advanceTradeState: { id, status: "COMPLETED", __typename: "TradeRequest" }
        }
      });
    } catch {
      alert("Protocol update failed");
    }
  };

  return (
    <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 transition-all hover:shadow-md">
      <div className="flex justify-between mb-4">
        <span className="px-3 py-1 bg-slate-100 text-slate-600 rounded-full text-[10px] font-bold font-mono uppercase">{id}</span>
        <span className={`text-xs font-bold ${status === 'COMPLETED' ? 'text-emerald-500' : 'text-blue-600'}`}>
          {status}
        </span>
      </div>
      <h3 className="text-xl font-bold text-slate-800">{productCategory}</h3>
      <div className="text-2xl font-mono mt-2 mb-6">${parseFloat(amount).toLocaleString()}</div>
      {status !== 'COMPLETED' && (
        <button onClick={handleAdvance} disabled={loading} className="w-full py-3 bg-slate-900 text-white rounded-xl text-xs font-bold hover:bg-black disabled:opacity-50 uppercase tracking-widest">
          {loading ? "COMMITTING..." : "Advance Protocol →"}
        </button>
      )}
    </div>
  );
}
