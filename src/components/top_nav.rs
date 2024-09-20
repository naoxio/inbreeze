// src/components/top_nav.rs

use dioxus::prelude::*;
use crate::routes::Route;
use crate::components::icon::Icon;

#[cfg(target_arch = "wasm32")]
use manganis::*;

#[cfg(target_arch = "wasm32")]
const LOGO: ImageAsset = manganis::mg!(image("./assets/logo.png").preload());

#[cfg(not(target_arch = "wasm32"))]
const LOGO: &str = "assets/logo.png";

#[component]
pub fn TopNav() -> Element {
    let mut theme = use_signal(|| "light");
    let mut language = use_signal(|| "en");

    rsx! {
        nav { class: "top-nav",
            Link { class: "nav-left",
                img { class: "nav-logo", src: "{LOGO}", alt: "InBreeze Logo" }
                span { class: "nav-app-name", "InBreeze" },
                to: Route::HomePage {}
            }
            div { class: "nav-right",
                button {
                    class: "nav-icon theme-toggle",
                    onclick: move |_| {
                        theme.set(if theme() == "light" { "dark" } else { "light" });
                    },
                    Icon {
                        name: if theme() == "light" { "moon".to_string() } else { "sun".to_string() },
                        alt: Some(if theme() == "light" { "Dark mode".to_string() } else { "Light mode".to_string() }),
                        class: Some("nav-icon-img".to_string())
                    }
                }
                button {
                    class: "nav-icon language-toggle",
                    onclick: move |_| {
                        language.set(if language() == "en" { "es" } else { "en" });
                    },
                    Icon {
                        name: "language".to_string(),
                        alt: Some("Toggle language".to_string()),
                        class: Some("nav-icon-img".to_string())
                    }
                }
                Link {
                    to: Route::StatsPage {},
                    class: "nav-icon",
                    Icon {
                        name: "stats".to_string(),
                        alt: Some("Statistics".to_string()),
                        class: Some("nav-icon-img".to_string())
                    }
                }
                Link {
                    to: Route::SettingsPage {},
                    class: "nav-icon",
                    Icon {
                        name: "settings".to_string(),
                        alt: Some("Settings".to_string()),
                        class: Some("nav-icon-img".to_string())
                    }
                }
            }
        }
    }
}