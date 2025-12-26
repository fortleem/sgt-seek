use async_graphql::{SimpleObject, Json};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[derive(SimpleObject, Serialize, Deserialize, Clone)]
pub struct TradeRequest {
    pub id: String,
    pub product_category: String,
    pub specifications: Json<serde_json::Value>,
    pub quantity: Option<String>,
    pub unit: String,
    pub status: String,

    // Blueprint: auditable timestamp
    #[graphql(name = "createdAt")]
    pub created_at: DateTime<Utc>,
}

#[derive(SimpleObject, Serialize, Deserialize, Clone)]
pub struct CommissionLock {
    pub id: String,
    pub transaction_id: String,
    pub commission_type: String,
    pub amount: String,
    pub currency: String,
    pub settlement_path: String,
    pub lock_status: String,

    #[graphql(name = "createdAt")]
    pub created_at: DateTime<Utc>,
}

#[derive(SimpleObject, Serialize, Deserialize, Clone)]
pub struct AIInferenceRecord {
    pub id: String,
    pub model_name: String,
    pub input_features: Json<serde_json::Value>,
    pub output_result: Json<serde_json::Value>,

    #[graphql(name = "createdAt")]
    pub created_at: DateTime<Utc>,
}
