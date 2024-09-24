use dioxus::prelude::*;

use crate::pages::{home_page::HomePage, settings_page::SettingsPage, stats_page::StatsPage, practice_page::PracticePage, progress_page::ProgressPage};

#[derive(Clone, Routable, Debug, PartialEq)]
pub enum Route {
    #[route("/")]
    HomePage {},
    #[route("/settings")]
    SettingsPage {},
    #[route("/stats")]
    StatsPage {},
    #[route("/progress")]
    ProgressPage {},
    #[route("/practice/:id")]
    PracticePage { id: String },
}