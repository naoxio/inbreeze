use dioxus::prelude::*;
use crate::models::practice::Colors;


#[component]
pub fn BreathingCircle(
    colors: Colors,
    circle_expanded: Signal<bool>,
    countdown: Signal<i32>,
    breath_count: Signal<i32>,
) -> Element {
    rsx! {
        div { 
            class: "breath-circle-container",
            div { 
                class: "breath-circle outer",
                style: "background-color: {colors.primary}",
            }
            div {
                class: "breath-circle inner",
                class: if circle_expanded() { "expanded" } else { "collapsed" },
                style: "background-color: {colors.secondary}",
            }
            div {
                class: "breath-count",
                style: "color: {colors.button_disabled_text}",
                {if countdown() > 0 {
                    countdown().to_string()
                } else {
                    breath_count().to_string()
                }}
            }
        }
    }
}

