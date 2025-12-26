use axum::{routing::get, Router};
use std::net::SocketAddr;

#[tokio::main]
async fn main() {
    let app = Router::new().route("/health", get(|| async { "SGT Telemetry OK" }));
    let addr = SocketAddr::from(([0, 0, 0, 0], 4317));
    println!("SGT Telemetry Service listening on OTLP port 4317");
    axum::serve(tokio::net::TcpListener::bind(addr).await.unwrap(), app).await.unwrap();
}
