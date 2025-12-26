// SGT Audit Service
// Blueprint Section 8: Legal & Compliance

use sqlx::postgres::PgPoolOptions;
use std::env;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let database_url = env::var("DATABASE_URL")
        .unwrap_or_else(|_| "postgresql://sgt_admin:sgt_password@localhost:5432/sgt_root".to_string());

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await?;

    println!("SGT Audit Service connected to PostgreSQL.");
    println!("Waiting for Kafka events on topic 'trades'...");

    // Future: rdkafka consumer loop to write into system_audit_logs
    Ok(())
}
