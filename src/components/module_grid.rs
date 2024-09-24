use dioxus::prelude::*;
use crate::routes::Route;
use crate::models::practice::Practice;
use crate::i18n::translate;
use crate::components::icon::Icon;
use crate::utils::{get_time_unit_short_code, capitalize_first_letter, generate_clock_svg};

#[component]
pub fn ModuleGrid(practices: Vec<Practice>) -> Element {
    rsx! {
        style { {include_str!("../../assets/styles/module_grid.css")} }

        p { class: "hidden", "The length is: {practices.len()}" }

        div { class: "module-grid",
            for practice in practices.iter() {
                Link {
                    to: Route::PracticePage { id: practice.id.clone() },
                    div {
                        class: "module",
                        key: "{practice.id}",
                        style: "background-color: {practice.visual.colors.background_color};",
                        div { class: "module-content",
                            h2 { class: "practice-name", "{translate(&practice.name)}" }
                            p { class: "practice-description", 
                                "{translate(&practice.description)}"
                            }
                            div { class: "quick-facts",
                                // Category Icon
                                div { 
                                    class: "fact",
                                    Icon { name: practice.category.clone() }
                                    span { "{capitalize_first_letter(&practice.category)}" }
                                }
                                // Duration Icon and Text
                                div { 
                                    class: "fact",
                                    div {
                                        class: "icon",
                                        dangerous_inner_html: "{generate_clock_svg(practice.duration.average)}",
                                    }
                                    span { "{practice.duration.average} {get_time_unit_short_code(&translate(&practice.duration.unit))}"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}