use dioxus::prelude::*;

#[component]
pub fn BreathingCircle(
    circle_expanded: Signal<bool>,
    countdown: Signal<i32>,
    breath_count: Signal<i32>,
) -> Element {
    rsx! {
        div {
            class: "breath-circle-container",
            div {
                class: "breath-circle outer",
            }
            div {
                class: "breath-circle inner",
                class: if circle_expanded() { "expanded" } else { "collapsed" },
            }
            div {
                class: "breath-count",
                {if countdown() > 0 {
                    countdown().to_string()
                } else {
                    breath_count().to_string()
                }}
            }
        }
    }
}