// src/components/module_selector.rs
use dioxus::prelude::*;
use crate::data::practice_loader::{load_practices, get_practice_by_id};
use crate::theme::set_theme;
use crate::i18n::translate;

#[component]
pub fn ModuleSelector(on_module_change: EventHandler<String>) -> Element {
    let mut current_module = use_signal(|| "whm_basic".to_string());
    let mut show_selector = use_signal(|| false);
    let practices = use_memo(load_practices);

    let toggle_selector = move |_| {
        show_selector.set(!show_selector());
    };

    let mut select_module = move |module: String| {
        current_module.set(module.clone());
        set_theme(&module);
        show_selector.set(false);
        on_module_change.call(module);
    };

    rsx! {
        div { 
            class: "module-selector",
            button {
                class: "module-selector-toggle",
                onclick: toggle_selector,
                {translate(&get_practice_by_id(&current_module()).map(|p| p.name.clone()).unwrap_or_else(|| current_module()))}
            }
            if show_selector() {
                div { 
                    class: "module-options",
                    {practices.iter().map(|practice| {
                        let practice_id = practice.id.clone();
                        rsx! {
                            button {
                                key: "{practice.id}",
                                onclick: move |_| select_module(practice_id.clone()),
                                "{translate(&practice.name)}"
                            }
                        }
                    })}
                }
            }
        }
    }
}