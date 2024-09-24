// src/pages/home_page.rs
use dioxus::prelude::*;
use crate::routes::Route;
use crate::components::bottom_nav::BottomNav;
use crate::components::module_selector::ModuleSelector;

#[cfg(target_arch = "wasm32")]
use manganis::*;
#[cfg(target_arch = "wasm32")]
const LOGO: ImageAsset = manganis::mg!(image("./assets/logo.png").preload());
#[cfg(not(target_arch = "wasm32"))]
const LOGO: &str = "assets/logo.png";

#[component]
pub fn HomePage() -> Element {
    let mut current_module = use_signal(|| "whm_basic".to_string());

    rsx! {
        div { class: "container",
            ModuleSelector {
                on_module_change: move |new_module: String| {
                    current_module.set(new_module);
                }
            }
            div { class: "content",
                img { class: "logo", src: "{LOGO}", alt: "InBreeze Logo" }
                h1 { class: "title", "Inner Breeze" }
                Link {
                    class: "btn",
                    to: Route::PracticePage { id: current_module() },
                    "Start"
                }
            }
            BottomNav { active_route: Route::HomePage {} }
        }
    }
}