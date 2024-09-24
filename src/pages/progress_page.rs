use dioxus::prelude::*;
use crate::routes::Route;
use crate::components::icon::Icon;
use crate::components::bottom_nav::BottomNav;

#[component]
pub fn ProgressPage() -> Element {
    // This would typically come from your app's state or a database
    let progress_data = vec![
        ("Breathing Exercise", 75),
        ("Meditation", 50),
        ("Yoga", 30),
        ("Mindfulness", 60),
    ];

    rsx! {
        div { class: "container",
            div { class: "content",
                h1 { class: "title", "Your Progress" }
                div { class: "progress-list",
                    { progress_data.into_iter().map(|(name, percentage)| {
                        rsx! {
                            div { class: "progress-item",
                                span { class: "progress-name", "{name}" }
                                div { class: "progress-bar",
                                    div { 
                                        class: "progress-fill",
                                        style: "width: {percentage}%"
                                    }
                                }
                                span { class: "progress-percentage", "{percentage}%" }
                            }
                        }
                    })}
                }
            }
            BottomNav { active_route: Route::ProgressPage {} }
        }
    }
}