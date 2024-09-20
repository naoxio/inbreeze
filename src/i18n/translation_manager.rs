use serde_yaml::Value;

#[cfg(target_arch = "wasm32")]
use manganis::*;

#[cfg(not(target_arch = "wasm32"))]
use std::fs;

pub struct TranslationManager {
    translations: Value,
    language: String,
}

impl TranslationManager {
    #[cfg(target_arch = "wasm32")]
    pub fn new(language: &str) -> Result<Self, Box<dyn std::error::Error>> {
        // Load common translations
        let content = match language {
            "en" => include_str!("../../locales/en.yaml"),
            "de" => include_str!("../../locales/de.yaml"),
            // Add more languages as needed
            _ => return Err("Unsupported language".into()),
        };
        let translations: Value = serde_yaml::from_str(content)?;

        Ok(Self {
            translations,
            language: language.to_string(),
        })
    }

    #[cfg(not(target_arch = "wasm32"))]
    pub fn new(language: &str) -> Result<Self, Box<dyn std::error::Error>> {
        // Load common translations
        let path = format!("locales/{}.yaml", language);
        let content = fs::read_to_string(&path)?;
        let translations: Value = serde_yaml::from_str(&content)?;

        Ok(Self {
            translations,
            language: language.to_string(),
        })
    }
    
    pub fn translate(&self, key: &str) -> String {
        let parts: Vec<&str> = key.split('.').collect();
        
        let mut current = &self.translations;
        for &key in &parts {
            if let Some(value) = current.get(key) {
                if let Some(s) = value.as_str() {
                    return s.to_string();
                }
                current = value;
            } else {
                return key.to_string();
            }
        }

        key.to_string()
    }

    pub fn get_language(&self) -> &str {
        &self.language
    }
}