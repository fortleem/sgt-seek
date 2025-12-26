// SGT Governor gRPC Server
// Blueprint Section 13: Continuous Enforcement

use tonic::{transport::Server, Request, Response, Status};
pub mod governance {
    tonic::include_proto!("governance");
}

use governance::governor_server::{Governor, GovernorServer};
use governance::{PolicyRequest, PolicyResponse};

#[derive(Default)]
pub struct MyGovernor {}

#[tonic::async_trait]
impl Governor for MyGovernor {
    async fn check_policy(
        &self,
        request: Request<PolicyRequest>,
    ) -> Result<Response<PolicyResponse>, Status> {
        let req = request.into_inner();
        println!("Governor evaluating request from: {}", req.service_name);

        // Logic to call engine::evaluate_policy would go here
        let reply = PolicyResponse {
            allowed: true, // Defaulting to true for bootstrap
            reason: "Policy check bypassed for MVP".into(),
        };

        Ok(Response::new(reply))
    }
}

pub async fn start_server() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::1]:50051".parse()?;
    let governor = MyGovernor::default();

    println!("Governor gRPC Server listening on {}", addr);

    Server::builder()
        .add_service(GovernorServer::new(governor))
        .serve(addr)
        .await?;

    Ok(())
}
