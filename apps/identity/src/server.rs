use axum::{
    routing::post,
    Router,
};
use async_graphql::{Schema, EmptyMutation, EmptySubscription, Object};
use async_graphql_axum::{GraphQLRequest, GraphQLResponse};
use tokio::net::TcpListener;

struct QueryRoot;

#[Object]
impl QueryRoot {
    async fn hello(&self) -> &str {
        "Identity GraphQL OK"
    }
}

pub async fn run_server() {
    let schema = Schema::build(QueryRoot, EmptyMutation, EmptySubscription).finish();

    async fn graphql_handler(
        schema: axum::extract::Extension<Schema<QueryRoot, EmptyMutation, EmptySubscription>>,
        req: GraphQLRequest,
    ) -> GraphQLResponse {
        schema.execute(req.into_inner()).await.into()
    }

    let app = Router::new()
        .route("/graphql", post(graphql_handler))
        .layer(axum::extract::Extension(schema));

    let listener = TcpListener::bind("127.0.0.1:4001").await.unwrap();
    println!("Identity service listening on 127.0.0.1:4001");

    axum::serve(listener, app).await.unwrap();
}
