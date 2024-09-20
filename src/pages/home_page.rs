use dioxus::prelude::*;
use crate::data::practice_loader::load_practices;
use crate::components::module_grid::ModuleGrid;
use crate::components::top_nav::TopNav;


pub fn HomePage() -> Element {
    let practices = use_signal(load_practices);

    rsx! {
        div { class: "container",
            TopNav {}

            ModuleGrid {
                practices: practices(),
            }
        }
    }
}