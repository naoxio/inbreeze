use dioxus::prelude::*;
use crate::routes::Route;
use crate::components::icon::Icon;

#[component]
pub fn BottomNav(active_route: Route) -> Element {
    rsx! {
        nav { class: "bottom-nav",
            Link {
                to: Route::ProgressPage {},
                class: if matches!(active_route, Route::ProgressPage {}) { "nav-icon active" } else { "nav-icon" },
                Icon {
                    name: "progress".to_string(),
                    alt: Some("Progress".to_string()),
                    class: Some("nav-icon-img".to_string())
                }
                span { "Progress" }
            }
            Link {
                to: Route::HomePage {},
                class: if matches!(active_route, Route::HomePage {}) { "nav-icon active" } else { "nav-icon" },
                Icon {
                    name: "sun".to_string(),
                    alt: Some("Home".to_string()),
                    class: Some("nav-icon-img".to_string())
                }
                span { "Home" }
            }
            Link {
                to: Route::SettingsPage {},
                class: if matches!(active_route, Route::SettingsPage {}) { "nav-icon active" } else { "nav-icon" },
                Icon {
                    name: "settings".to_string(),
                    alt: Some("Settings".to_string()),
                    class: Some("nav-icon-img".to_string())
                }
                span { "Settings" }
            }
        }
    }
}