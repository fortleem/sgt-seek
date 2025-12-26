use async_graphql::*;

#[derive(SimpleObject)]
pub struct Jurisdiction {
    id: ID,
}

pub struct JurisdictionResolver;

#[Object]
impl JurisdictionResolver {
    async fn get_id(&self, ctx: &Context<'_>, id: ID) -> Jurisdiction {
        Jurisdiction { id }
    }
}
