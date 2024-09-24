// data/practice_loader.rs

use crate::models::practice::{Duration, Assets, Colors, Practice, PracticeStructure, RoundConfig, Visual};

#[cfg(target_arch = "wasm32")]
use manganis::*;
#[cfg(target_arch = "wasm32")]
use std::str::FromStr;

#[cfg(not(target_arch = "wasm32"))]
use std::fs;
#[cfg(not(target_arch = "wasm32"))]
use std::path::Path;

fn create_error_practice(description: String) -> Practice {
    Practice {
        id: "error".to_string(),
        name: "Error".to_string(),
        description,
        author: "System".to_string(),
        visual: Visual {
            background_image: "".to_string(),
            icon: "error.svg".to_string(),
            colors: Colors {
                background_color: "#FF0000".to_string(),
                primary_color: "#FF4444".to_string(),
                secondary_color: "#FF8888".to_string(),
                tertiary_color: "#FFAAAA".to_string(),
                accent_color: "#FF0000".to_string(),
                text_primary: "#FFFFFF".to_string(),
                text_secondary: "#FFDDDD".to_string(),
                shadow_color: "rgba(255, 0, 0, 0.2)".to_string(),
            },
        },
        version: "0.0.0".to_string(),
        category: "error".to_string(),
        tags: vec![],
        origin: "error".to_string(),
        difficulty: "error".to_string(),
        duration: Duration {
            average: 0,
            unit: "seconds".to_string(),
        },
        practice_structure: PracticeStructure {
            rounds: RoundConfig {
                default: 0,
                range: vec![0, 0],
                label: "".to_string(),
            },
            sequences: vec![],
        },
        ui_elements: vec![],
        user_inputs: vec![],
        safety_notes: vec![],
        implementation_notes: vec![],
        benefits: vec![],
        contraindications: vec![],
        assets: Assets {
            images: vec![],
            sounds: vec![],
            videos: vec![],
        },
        customization_options: vec![],
        data_tracking: vec![],
        references: vec![],
    }
}
#[cfg(target_arch = "wasm32")]
pub fn load_practices() -> Vec<Practice> {
    // Define your list of practice filenames.
    let practice_filenames = [
        ("whm_basic.yaml", include_str!("../.././practices/whm_basic.yaml")),
        ("surya_namaskar_basic.yaml", include_str!("../.././practices/surya_namaskar_basic.yaml")),
    ];

    let mut practices = Vec::new();

    for (filename, practice_content) in &practice_filenames {
        match serde_yaml::from_str::<Practice>(practice_content) {
            Ok(practice) => practices.push(practice),
            Err(e) => {
                let error_practice = create_error_practice(format!(
                    "Failed to parse YAML for {}: {}. Content: {}",
                    filename, e, practice_content
                ));
                practices.push(error_practice);
            }
        }
    }

    if practices.is_empty() {
        practices.push(create_error_practice("No practices found".to_string()));
    }

    practices
}


#[cfg(not(target_arch = "wasm32"))]
pub fn load_practices() -> Vec<Practice> {
    let practices_dir = Path::new("practices");
    let mut practices = Vec::new();

    if practices_dir.is_dir() {
        if let Ok(entries) = fs::read_dir(practices_dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.extension().and_then(|s| s.to_str()) == Some("yaml") {
                    if let Ok(contents) = fs::read_to_string(&path) {
                        match serde_yaml::from_str(&contents) {
                            Ok(practice) => practices.push(practice),
                            Err(e) => eprintln!("Error parsing practice file {:?}: {}", path, e),
                        }
                    }
                }
            }
        }
    }

    if practices.is_empty() {
        practices.push(create_error_practice("No practices found".to_string()));
    }

    practices
}

pub fn get_practice_by_id(id: &str) -> Option<Practice> {
    load_practices().into_iter().find(|p| p.id == id)
}