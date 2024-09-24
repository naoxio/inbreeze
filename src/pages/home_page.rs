// src/pages/home_page.rs
use dioxus::prelude::*;
use crate::routes::Route;
use crate::components::bottom_nav::BottomNav;
use crate::components::module_selector::ModuleSelector;
use crate::models::practice::ModuleContext;

#[cfg(target_arch = "wasm32")]
use manganis::*;

#[cfg(target_arch = "wasm32")]
const LOGO: ImageAsset = manganis::mg!(image("./assets/logo.svg").preload());

#[cfg(not(target_arch = "wasm32"))]
const LOGO: &str = "assets/logo.svg";

#[component]
pub fn HomePage() -> Element {
    let module_context = use_context::<Signal<ModuleContext>>();

    rsx! {
        style { {include_str!("../../assets/styles/home.css")} }
        div { 
            class: "container",
            ModuleSelector {}
            div { 
                class: "content",
                img { class: "logo", src: "{LOGO}", alt: "Inner Breeze Logo" }
                h1 { class: "title", "Inner Breeze" }
                Link {
                    class: "btn btn-large",
                    to: Route::PracticePage { id: module_context.read().current_module.clone() },
                    "Start"
                }
            }
            BottomNav { active_route: Route::HomePage {} }
        }
    }
}