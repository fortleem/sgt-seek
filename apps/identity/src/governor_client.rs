/// Governor client stub
/// Real enforcement will be wired in Phase 3

pub async fn check_policy(_action: &str, _subject: &str) -> bool {
    true
}
