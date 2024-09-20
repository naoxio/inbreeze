use dioxus::prelude::*;
use crate::routes::Route;

#[component]
pub fn SettingsPage() -> Element {
    rsx! {
        h1 { "Settings" }
        Link { to: Route::HomePage {}, "Back to Home" }
    }
}
