use async_graphql::*;

#[derive(SimpleObject)]
pub struct User {
    id: ID,
}

pub struct UserResolver;

#[Object]
impl UserResolver {
    async fn get_id(&self, ctx: &Context<'_>, id: ID) -> User {
        User { id }
    }
}
