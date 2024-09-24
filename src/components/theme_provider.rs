// src/components/theme_provider.rs
use dioxus::prelude::*;
use crate::theme::{set_theme, get_theme_css};

#[component]
pub fn ThemeProvider(children: Element) -> Element {
    use_effect(|| {
        set_theme("whm_basic");
    });

    let theme_css = get_theme_css();

    rsx! {
        style { "{theme_css}" }
        div {
            {children}
        }
    }
}
