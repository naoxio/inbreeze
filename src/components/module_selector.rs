// src/components/module_selector.rs
use dioxus::prelude::*;
use dioxus_logger::tracing::*;
use crate::data::practice_loader::{load_practices, get_practice_by_id};
use crate::theme::set_theme;
use crate::i18n::translate;
use crate::models::practice::ModuleContext;

#[component]
pub fn ModuleSelector() -> Element {
    let mut module_context = use_context::<Signal<ModuleContext>>();
    let mut show_selector = use_signal(|| false);
    let practices = use_memo(load_practices);

    info!("ModuleSelector initialized");
    debug!("Current module: {:?}", module_context.read().current_module);

    let toggle_selector = move |_| {
        show_selector.set(!show_selector());
        debug!("Selector toggled: {}", show_selector());
    };

    let current_module_name = use_memo(move || {
        let name = get_practice_by_id(&module_context.read().current_module)
            .map(|p| p.name.clone())
            .unwrap_or_else(|| module_context.read().current_module.clone());
        debug!("Current module name: {}", name);
        name
    });

    rsx! {
        div {
            class: "module-selector",
            button {
                class: "module-selector-toggle",
                onclick: toggle_selector,
                "{translate(&current_module_name())}"
            }
            if show_selector() {
                div {
                    class: "module-options",
                    { practices.iter().map(|practice| {
                        let practice_id = practice.id.clone();
                        rsx! {
                            button {
                                key: "{practice.id}",
                                onclick: move |_| {
                                    info!("Changing module to: {}", practice_id);
                                    module_context.write().current_module = practice_id.clone();
                                    set_theme(&practice_id);
                                    show_selector.set(false);
                                },
                                "{translate(&practice.name)}"
                            }
                        }
                    })}
                }
            }
        }
    }
}