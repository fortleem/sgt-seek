// SGT Settlement & Ledger Logic
// Blueprint Section 8.1: Double-Entry Bookkeeping Simulation

pub struct Transaction {
    pub trade_id: String,
    pub amount: f64,
    pub tx_type: String,
}

impl Transaction {
    pub fn calculate_interest(principal: f64, rate: f64, days: i32) -> f64 {
        // Simple Interest: (P * R * T) / 365
        (principal * rate * (days as f64)) / 365.0
    }

    pub async fn record_disbursement(&self) {
        println!("Recording Disbursement of {} for Trade {}", self.amount, self.trade_id);
        // Future: SQL INSERT INTO settlement_ledger
    }
}
