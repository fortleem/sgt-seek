mod server;
mod governor_client;

#[tokio::main]
async fn main() {
    server::run_server().await;
}
