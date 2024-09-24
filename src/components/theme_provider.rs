// src/components/theme_provider.rs
use dioxus::prelude::*;
use crate::theme::{set_theme, get_theme_css};
use crate::models::practice::ModuleContext;

#[component]
pub fn ThemeProvider(children: Element) -> Element {
    let module_context = use_context::<Signal<ModuleContext>>();
    
    use_effect(move || {
        set_theme(&module_context.read().current_module);
    });

    let theme_css = use_memo(move || get_theme_css());

    rsx! {
        style { "{theme_css}" }
        div {
            {children}
        }
    }
}