use crate::models::practice::Colors;
use crate::data::practice_loader::get_practice_by_id;
use once_cell::sync::Lazy;
use std::sync::Mutex;

#[derive(Clone, Debug)]
pub struct Theme {
    pub background_color: String,
    pub colors: Colors,
}

impl Default for Theme {
    fn default() -> Self {
        Theme {
            background_color: "#6BA7CC".to_string(),
            colors: Colors {
                primary: "#1E88E5".to_string(),
                secondary: "#64B5F6".to_string(),
                text: "#E3F2FD".to_string(),
                title: "#BBDEFB".to_string(),
                button: "#2196F3".to_string(),
                button_hover: "#1565C0".to_string(),
                button_disabled: "#90CAF9".to_string(),
                button_text: "#FFFFFF".to_string(),
                button_disabled_text: "#1A237E".to_string(),
            },
        }
    }
}

pub static CURRENT_THEME: Lazy<Mutex<Theme>> = Lazy::new(|| Mutex::new(Theme::default()));

pub fn set_theme(practice_id: &str) {
    let mut theme = CURRENT_THEME.lock().unwrap();
    if let Some(practice) = get_practice_by_id(practice_id) {
        *theme = Theme {
            background_color: practice.visual.background_color,
            colors: practice.visual.colors,
        };
    } else {
        // Set a default theme if practice is not found
        *theme = Theme::default();
    }
}

pub fn get_current_theme() -> Theme {
    CURRENT_THEME.lock().unwrap().clone()
}

// Function to get CSS string
pub fn get_theme_css() -> String {
    let theme = get_current_theme();
    format!(
        ":root {{
            --background-color: {};
            --primary-color: {};
            --secondary-color: {};
            --text-color: {};
            --title-color: {};
            --button-color: {};
            --button-hover-color: {};
            --button-disabled-color: {};
            --button-text-color: {};
            --button-disabled-text-color: {};
        }}",
        theme.background_color,
        theme.colors.primary,
        theme.colors.secondary,
        theme.colors.text,
        theme.colors.title,
        theme.colors.button,
        theme.colors.button_hover,
        theme.colors.button_disabled,
        theme.colors.button_text,
        theme.colors.button_disabled_text
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_set_theme() {
        // This test assumes that get_practice_by_id is mocked or a test practice is available
        set_theme("whm_basic");
        let theme = get_current_theme();
        assert_eq!(theme.background_color, "#6BA7CC");
    }

    #[test]
    fn test_default_theme() {
        let default_theme = Theme::default();
        assert_eq!(default_theme.background_color, "#6BA7CC");
        assert_eq!(default_theme.colors.primary, "#1E88E5");
    }
}