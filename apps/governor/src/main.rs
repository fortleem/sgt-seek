mod engine;
mod grpc_server;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("SGT Governor Service Initializing...");
    grpc_server::start_server().await?;
    Ok(())
}
