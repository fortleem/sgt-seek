use async_graphql::*;

#[derive(SimpleObject)]
pub struct Organization {
    id: ID,
}

pub struct OrganizationResolver;

#[Object]
impl OrganizationResolver {
    async fn get_id(&self, ctx: &Context<'_>, id: ID) -> Organization {
        Organization { id }
    }
}
