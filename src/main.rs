#![allow(non_snake_case)]

use dioxus_logger::tracing::{info, Level};
use dioxus::prelude::*;

mod app;
mod data;
mod routes;
mod components;
mod i18n;
mod utils;
mod pages;
mod models;

fn main() {
    dioxus_logger::init(Level::INFO).expect("failed to init logger");
    info!("starting app");
    launch(app::App);
}
