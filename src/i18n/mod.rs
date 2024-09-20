use once_cell::sync::Lazy;
use std::sync::Mutex;

mod translation_manager;
use translation_manager::TranslationManager;

static TRANSLATION_MANAGER: Lazy<Mutex<TranslationManager>> = Lazy::new(|| {
    Mutex::new(TranslationManager::new("en").expect("Failed to initialize translations"))
});

pub fn translate(key: &str) -> String {
    TRANSLATION_MANAGER.lock().unwrap().translate(key)
}

pub fn set_language(language: &str) -> Result<(), Box<dyn std::error::Error>> {
    let mut manager = TRANSLATION_MANAGER.lock().unwrap();
    *manager = TranslationManager::new(language)?;
    Ok(())
}

pub fn get_current_language() -> String {
    TRANSLATION_MANAGER.lock().unwrap().get_language().to_string()
}
