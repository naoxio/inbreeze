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
            background_color: "#FF0000".to_string(),
            icon: "error.svg".to_string(),
            colors: Colors {
                primary: "#FF4444".to_string(),        // Lighter red
                secondary: "#FF8888".to_string(),      // Even lighter red
                text: "#FFFFFF".to_string(),           // White text
                title: "#FFDDDD".to_string(),          // Very light red for titles
                button: "#CC0000".to_string(),         // Darker red for buttons
                button_hover: "#AA0000".to_string(),   // Even darker red for button hover
                button_disabled: "#FFAAAA".to_string(), // Light red for disabled buttons
                button_text: "#FFFFFF".to_string(),    // White text for buttons
                button_disabled_text: "#FF0000".to_string(), // Red text for disabled buttons
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


pub fn load_practices() -> Vec<Practice> {
    #[cfg(target_arch = "wasm32")]
    {
        let practice_content = include_str!("../.././practices/whm_basic.yaml");

        match serde_yaml::from_str::<Practice>(practice_content) {
            Ok(practice) => vec![practice],
            Err(e) => {
                let error_practice = create_error_practice(format!("Failed to parse YAML: {}. Content: {}", e, practice_content));
                vec![error_practice]
            }
        }
    }

    #[cfg(not(target_arch = "wasm32"))]
    {
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
}

pub fn get_practice_by_id(id: &str) -> Option<Practice> {
    load_practices().into_iter().find(|p| p.id == id)
}