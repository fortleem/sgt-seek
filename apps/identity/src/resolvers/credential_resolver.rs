use async_graphql::*;

#[derive(SimpleObject)]
pub struct Credential {
    id: ID,
}

pub struct CredentialResolver;

#[Object]
impl CredentialResolver {
    async fn get_id(&self, ctx: &Context<'_>, id: ID) -> Credential {
        Credential { id }
    }
}
