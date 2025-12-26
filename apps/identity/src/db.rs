use sqlx::sqlite::SqlitePool;

pub async fn connect_db() -> SqlitePool {
    let database_url = "sqlite://identity.db";
    SqlitePool::connect(database_url).await.unwrap()
}
