use dioxus::prelude::*;
use crate::routes::Route;
use crate::components::icon::Icon;
use crate::components::bottom_nav::BottomNav;

#[cfg(target_arch = "wasm32")]
use manganis::*;

#[cfg(target_arch = "wasm32")]
const LOGO: ImageAsset = manganis::mg!(image("./assets/logo.png").preload());

#[cfg(not(target_arch = "wasm32"))]
const LOGO: &str = "assets/logo.png";

#[component]
pub fn HomePage() -> Element {
    rsx! {
        div { class: "container",
            div { class: "content",
                img { class: "logo", src: "{LOGO}", alt: "InBreeze Logo" }
                h1 { class: "title", "Inner Breeze" }
                button { class: "btn", "Start" }
            }
            BottomNav { active_route: Route::HomePage {} }
        }
    }
}