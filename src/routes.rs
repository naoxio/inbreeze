use dioxus::prelude::*;

use crate::pages::{home_page::HomePage, settings_page::SettingsPage, stats_page::StatsPage, practice_page::PracticePage};

#[derive(Clone, Routable, Debug, PartialEq)]
pub enum Route {
    #[route("/")]
    HomePage {},
    #[route("/settings")]
    SettingsPage {},
    #[route("/stats")]
    StatsPage {},
    #[route("/practice/:id")]
    PracticePage { id: String },
}