// app.rs
use dioxus::prelude::*;
use crate::routes::Route;
use crate::i18n::set_language;
use crate::components::splash_screen::SplashScreen;
use crate::components::theme_provider::ThemeProvider;
use crate::models::practice::ModuleContext;

pub fn change_language(new_language: &str) {
    if let Err(e) = set_language(new_language) {
        eprintln!("Failed to set language: {}", e);
    }
}

pub fn App() -> Element {
    let mut show_splash = use_signal(|| false);
    let module_context = use_signal(|| ModuleContext {
        current_module: "whm_basic".to_string(),
    });

    use_context_provider(|| module_context);

    rsx! {
        style { {include_str!("../assets/styles/main.css")} }
        style { {include_str!("../assets/styles/nav.css")} }
        style { {include_str!("../assets/styles/practice.css")} }
        style { {include_str!("../assets/styles/progress.css")} }
        style { {include_str!("../assets/styles/module_selector.css")} }
        
        ThemeProvider {
            if show_splash() {
                SplashScreen {
                    on_complete: move |_| show_splash.set(false)
                }
            } else {
                Router::<Route> {}
            }
        }
    }
}