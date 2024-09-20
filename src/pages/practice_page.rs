use dioxus::prelude::*;
use crate::data::practice_loader::get_practice_by_id;
use crate::routes::Route;
use crate::i18n::translate;
use std::time::Duration;
use crate::components::breathing_circle::BreathingCircle;
use crate::components::icon::Icon;

#[cfg(not(target_arch = "wasm32"))]
use tokio::time::sleep;

#[cfg(target_arch = "wasm32")]
use gloo_timers::future::TimeoutFuture;


#[component]
pub fn PracticePage(id: String) -> Element {
    let practice = use_signal(|| get_practice_by_id(&id));

    let sequences = use_memo(move || practice().unwrap().practice_structure.sequences.clone());
    
    let mut current_round = use_signal(|| 1);
    let mut current_sequence = use_signal(|| 0usize);
    let mut current_step = use_signal(|| 0usize);
    let breath_count = use_signal(|| 0);
    let retention_time = use_signal(|| 0);
    let timer_active = use_signal(|| false);
    
    let countdown = use_signal(|| 5);
    let circle_expanded = use_signal(|| false);
    let animation_duration = 4000; // 4 seconds for each expand/collapse cycle

    let current_step_data = use_memo(move || {
        sequences().get(current_sequence()).and_then(|seq| seq.steps.get(current_step()).cloned())
    });

    let mut handle_next = move || {
        let seq_vec = sequences();
        if let Some(seq) = seq_vec.get(current_sequence()) {
            if current_step() < seq.steps.len() - 1 {
                current_step.set(current_step() + 1);
            } else if current_sequence() < seq_vec.len() - 1 {
                current_sequence.set(current_sequence() + 1);
                current_step.set(0);
            } else if current_round() < practice().unwrap().practice_structure.rounds.default as i32 {
                current_round.set(current_round() + 1);
                current_sequence.set(0);
                current_step.set(0);
            }
        }
    };

    let on_next_click = move |_: Event<MouseData>| {
        handle_next();
    };
    
    let on_stop_click = move |_: Event<MouseData>| {
        let nav = navigator();
        nav.push(Route::HomePage {}); 
    };
    
    use_future(move || {
        to_owned![circle_expanded, breath_count, handle_next];
        async move {
            loop {
                circle_expanded.set(true);
                
                #[cfg(not(target_arch = "wasm32"))]
                tokio::time::sleep(Duration::from_millis(animation_duration)).await;
                
                #[cfg(target_arch = "wasm32")]
                gloo_timers::future::TimeoutFuture::new(animation_duration).await;

                circle_expanded.set(false);
                breath_count.set(breath_count() + 1);

                if breath_count() == 30 {
                    handle_next();
                    breath_count.set(0);
                }

                #[cfg(not(target_arch = "wasm32"))]
                tokio::time::sleep(Duration::from_millis(animation_duration)).await;
                
                #[cfg(target_arch = "wasm32")]
                gloo_timers::future::TimeoutFuture::new(animation_duration).await;
            }
        }
    });

    rsx! {
        div {
            class: "practice-page",
            {practice.with(|practice| {
                if let Some(practice) = practice {
                    let colors = &practice.visual.colors;
                    rsx! {
                        div { 
                            class: "practice-exercise",
                            style: "color: {colors.text}",
                            h2 { 
                                class: "title",
                                style: "color: {colors.title}",
                                {if countdown() > 0 {
                                    translate("practice.get_ready")
                                } else {
                                    format!("{}: {}", translate("practice.round"), current_round())
                                }}
                            }
                            
                            {practice.practice_structure.sequences.iter().any(|seq| seq.id == "breathing_cycle").then(|| rsx!(
                                BreathingCircle {
                                    colors: colors.clone(),
                                    circle_expanded: circle_expanded,
                                    countdown: countdown,
                                    breath_count: breath_count,
                                }
                            ))}
                            
                            div { class: "controls",
                                button { 
                                    class: "control-button", 
                                    onclick: on_stop_click,
                                    style: "background-color: {colors.button}; color: {colors.button_text}",
                                    Icon {
                                        name: "stop".to_string(),
                                        class: Some("nav-icon-img".to_string())
                                    }
                                }
                                button {
                                    class: "control-button",
                                    disabled: true,
                                    style: "background-color: {colors.button_disabled}; color: {colors.button_disabled_text}",
                                    Icon {
                                        name: "skip-prev".to_string(),
                                        class: Some("nav-icon-img".to_string())
                                    }
                                }
                                button { 
                                    class: "control-button", 
                                    onclick: |_| (),
                                    style: "background-color: {colors.button}; color: {colors.button_text}",
                                    Icon {
                                        name: "pause".to_string(),
                                        class: Some("nav-icon-img".to_string())
                                    }
                                }
                                button {
                                    class: "control-button",
                                    onclick: on_next_click,
                                    style: "background-color: {colors.button}; color: {colors.button_text}",
                                    Icon {
                                        name: "skip-next".to_string(),
                                        class: Some("nav-icon-img".to_string())
                                    }
                                }
                            }
                        }
                    }
                } else {
                    rsx! {
                        h1 { "{translate(\"error.practice_not_found\")}" }
                        p { "{translate(\"error.practice_not_found_description\")}" }
                    }
                }
            })}
        }
    }
}