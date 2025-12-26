use axum::{routing::get, Router};
use std::net::SocketAddr;

#[tokio::main]
async fn main() {
    // Dynamic Port Logic: Bind to 0 allows OS to pick any free port
    let addr = SocketAddr::from(([127, 0, 0, 1], 0));
    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();
    let actual_addr = listener.local_addr().unwrap();
    
    println!("\n🚀 SGT SERVICE ONLINE");
    println!("📍 ADDRESS: http://{}", actual_addr);
    println!("--------------------------------------");

    // Placeholder Router - Replace with your actual app logic
    let app = Router::new().route("/", get(|| async { "SGT Service Active" }));
    
    axum::serve(listener, app).await.unwrap();
}
