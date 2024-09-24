use dioxus::prelude::*;
#[cfg(target_arch = "wasm32")]
use manganis::*;


const ICON_NAMES: &[&str] = &[
    "yoga", "meditation", "breathing", "clock", "exercise", "moon",
    "sun", "language", "stats", "settings", "trekking", "default",
    "stop", "skip_next", "skip_prev", "play", "pause", "logo"
];

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
        rsx! {
            div {
                class: "{class}",
                dangerous_inner_html: "{icon_src}",
            }
        }
    }

    #[cfg(not(target_arch = "wasm32"))]
    {
        rsx! {
            img {
                class: "{class}",
                src: "{icon_src}",
                alt: "{alt_text}",
            }
        }
    }
}

macro_rules! generate_icon_match {
    ($icon_name:expr, $($name:expr),+) => {
        match $icon_name {
            $(
                $name => include_str!(concat!(env!("CARGO_MANIFEST_DIR"), "/assets/icons/", $name, ".svg")),
            )+
            _ => include_str!(concat!(env!("CARGO_MANIFEST_DIR"), "/assets/icons/default.svg")),
        }
    };
}

fn get_icon_src(icon: &str) -> String {
    let icon_name = icon.to_lowercase().replace('-', "_");
    
    #[cfg(target_arch = "wasm32")]
    {
        generate_icon_match!(icon_name.as_str(), "yoga", "meditation", "breathing", "clock", "exercise", "moon",
            "sun", "language", "stats", "settings", "trekking", "default",
            "stop", "skip_next", "skip_prev", "play", "pause", "logo").to_string()
    }

    #[cfg(not(target_arch = "wasm32"))]
    {
        if ICON_NAMES.contains(&icon_name.as_str()) {
            format!("assets/icons/{}.svg", icon_name)
        } else {
            "assets/icons/default.svg".to_string()
        }
    }
}

fn get_all_icon_names() -> Vec<String> {
    ICON_NAMES.iter().map(|&s| s.to_string()).collect()
}