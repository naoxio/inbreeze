// src/pages/home_page.rs
use dioxus::prelude::*;
use crate::routes::Route;
use crate::components::bottom_nav::BottomNav;
use crate::components::module_selector::ModuleSelector;
use crate::models::practice::ModuleContext;
use crate::components::icon::Icon;

#[component]
pub fn HomePage() -> Element {
    let module_context = use_context::<Signal<ModuleContext>>();

    rsx! {
        style { {include_str!("../../assets/styles/home.css")} }
        div { 
            class: "container",
            div { 
                class: "content",
                Icon {
                    class: "logo".to_string(),
                    name: "logo".to_string(),

                }
                ModuleSelector {}

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