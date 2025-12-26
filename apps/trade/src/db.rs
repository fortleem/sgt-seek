use sqlx::PgPool;
use uuid::Uuid;

pub async fn create_trade_request(
    pool: &PgPool,
    initiator_id: Uuid,
    commodity: &str,
    qty: f64
) -> Result<Uuid, sqlx::Error> {
    let row = sqlx::query!(
        "INSERT INTO trades (initiator_id, commodity_type, quantity, status) 
         VALUES (, , , 'OPEN') RETURNING id",
        initiator_id, commodity, qty
    )
    .fetch_one(pool)
    .await?;
    
    Ok(row.id)
}
