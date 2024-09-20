use dioxus::prelude::*;
#[cfg(target_arch = "wasm32")]
use manganis::*;

#[derive(Clone, Props, PartialEq)]
pub struct IconProps {
    name: String,
    #[props(default)]
    alt: Option<String>,
    #[props(default)]
    class: Option<String>,
}

impl Default for IconProps {
    fn default() -> Self {
        Self {
            name: "default".to_string(),
            alt: None,
            class: None,
        }
    }
}

#[component]
pub fn Icon(props: IconProps) -> Element {
    let icon_src = get_icon_src(&props.name);
    let alt_text = props.alt.unwrap_or_else(|| format!("{} icon", props.name));
    let class = props.class.unwrap_or_else(|| "icon".to_string());

    #[cfg(target_arch = "wasm32")]
    {
        // Render raw SVG content using `dangerous_inner_html`
        rsx! {
            div {
                class: "{class}",
                dangerous_inner_html: "{icon_src}",
            }
        }
    }

    #[cfg(not(target_arch = "wasm32"))]
    {
        // Render as an image for non-WASM targets
        rsx! {
            img {
                class: "{class}",
                src: "{icon_src}",
                alt: "{alt_text}",
            }
        }
    }
}

const ICON_NAMES: [&str; 17] = [
    "yoga", "meditation", "breathing", "clock", "exercise", "moon",
    "sun", "language", "stats", "settings", "trekking", "default",
    "stop", "skip-next", "skip-prev", "play", "pause"
];
#[cfg(target_arch = "wasm32")]
macro_rules! icon_paths {
    ($($name:ident),+) => {
        $(const $name: &str = include_str!(concat!(env!("CARGO_MANIFEST_DIR"), "/assets/icons/", stringify!($name), ".svg"));)+
    };
}


#[cfg(not(target_arch = "wasm32"))]
macro_rules! icon_paths {
    ($($name:ident),+) => {
        $(const $name: &str = concat!("assets/icons/", stringify!($name), ".svg");)+
    };
}

icon_paths!(yoga, meditation, breathing, clock, exercise, moon, sun, language, stats, settings, trekking, default_icon, stop, skip_next, skip_prev, play, pause);

fn get_icon_src(icon: &str) -> &'static str {
    match icon.to_lowercase().as_str() {
        "yoga" => yoga,
        "meditation" => meditation,
        "breathing" => breathing,
        "clock" => clock,
        "exercise" => exercise,
        "moon" => moon,
        "sun" => sun,
        "language" => language,
        "stats" => stats,
        "settings" => settings,
        "trekking" => trekking,
        "stop" => stop,
        "skip-next" => skip_next,
        "skip-prev" => skip_prev,
        "play" => play,
        "pause" => pause,
        _ => default_icon,
    }
}

fn get_all_icon_names() -> Vec<&'static str> {
    ICON_NAMES.to_vec()
}