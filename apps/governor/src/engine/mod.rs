// SGT Governor Policy Engine
// Blueprint Section 8: Risk & Compliance

use serde::{Deserialize, Serialize};
use std::fs;

#[derive(Debug, Serialize, Deserialize)]
pub struct Policy {
    pub name: String,
    pub jurisdiction: String,
    pub allowed_actions: Vec<String>,
}

pub fn evaluate_policy(policy_path: &str, action: &str) -> bool {
    println!("Evaluating policy at: {} for action: {}", policy_path, action);
    
    let content = fs::read_to_string(policy_path).expect("Unable to read policy file");
    let policy: Policy = serde_yaml::from_str(&content).expect("JSON/YAML parse error");

    policy.allowed_actions.contains(&action.to_string())
}
