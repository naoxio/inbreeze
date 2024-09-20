use dioxus::prelude::*;
use crate::routes::Route;

#[component]
pub fn StatsPage() -> Element {
    rsx! {
        h1 { "Statistics" }
        Link { to: Route::HomePage {}, "Back to Home" }
    }
}
