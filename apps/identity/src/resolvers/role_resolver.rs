use async_graphql::*;

#[derive(SimpleObject)]
pub struct Role {
    id: ID,
}

pub struct RoleResolver;

#[Object]
impl RoleResolver {
    async fn get_id(&self, ctx: &Context<'_>, id: ID) -> Role {
        Role { id }
    }
}
