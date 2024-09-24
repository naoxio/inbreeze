use dioxus::prelude::*;
use crate::routes::Route;
use crate::components::bottom_nav::BottomNav;

#[component]
pub fn SettingsPage() -> Element {
    rsx! {
        h1 { "Settings" }
        Link { to: Route::HomePage {}, "Back to Home" }
        BottomNav { active_route: Route::SettingsPage {} }
    }
}
