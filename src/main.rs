use std::net::SocketAddr;

use axum::{routing::get, Router, Server};
use lambda_web::LambdaError;

#[tokio::main]
async fn main() -> Result<(), LambdaError> {
    let app = Router::new().route("/", get(|| async { "Hello, world!" }));

    if lambda_web::is_running_on_lambda() {
        lambda_web::run_hyper_on_lambda(app).await?;
    } else {
        let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
        println!("listening on {}", addr);
        Server::bind(&addr).serve(app.into_make_service()).await?;
    }

    Ok(())
}
