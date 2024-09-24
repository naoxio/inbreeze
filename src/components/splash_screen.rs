use dioxus::prelude::*;

#[cfg(target_arch = "wasm32")]
use manganis::*;
#[cfg(target_arch = "wasm32")]
use wasm_bindgen::prelude::*;
#[cfg(target_arch = "wasm32")]
use web_sys::window;

#[cfg(target_arch = "wasm32")]
const LOGO: ImageAsset = manganis::mg!(image("./assets/logo.png").preload());

#[cfg(not(target_arch = "wasm32"))]
const LOGO: &str = "assets/logo.png";

#[cfg(target_arch = "wasm32")]
fn set_timeout(callback: Box<dyn FnOnce()>, delay: i32) {
    let window = window().expect("no global `window` exists");
    let closure = Closure::once(callback);
    let _ = window.set_timeout_with_callback_and_timeout_and_arguments_0(
        closure.as_ref().unchecked_ref(),
        delay,
    );
    closure.forget();
}

#[cfg(not(target_arch = "wasm32"))]
async fn sleep(duration: std::time::Duration) {
    tokio::time::sleep(duration).await;
}

#[cfg(target_arch = "wasm32")]
async fn sleep(duration: std::time::Duration) {
    let (tx, rx) = futures_channel::oneshot::channel();
    set_timeout(Box::new(move || {
        let _ = tx.send(());
    }), duration.as_millis() as i32);
    let _ = rx.await;
}

#[component]
pub fn SplashScreen(on_complete: EventHandler<()>) -> Element {
    let fade_in = use_signal(|| false);
    let show_title = use_signal(|| false);
    let show_tagline = use_signal(|| false);

    use_future(move || {
        to_owned![fade_in, show_title, show_tagline, on_complete];
        async move {
            // Simulate resource loading
            sleep(std::time::Duration::from_millis(500)).await;

            // Fade in logo
            fade_in.set(true);
            sleep(std::time::Duration::from_secs(1)).await;

            // Show title and tagline
            show_title.set(true);
            show_tagline.set(true);

            // Wait before completing
            sleep(std::time::Duration::from_secs(3)).await;

            // Notify parent that animation is complete
            on_complete.call(());
        }
    });

    rsx! {
        style { {include_str!("../../assets/styles/splash.css")} }

        div {
            class: "splash-screen",
            onclick: move |_| on_complete.call(()),
            div {
                class: "splash-content",
                img {
                    class: format_args!("logo {}", if fade_in() { "fade-in" } else { "" }),
                    src: "{LOGO}",
                    alt: "InBreeze Logo",
                }
                h1 {
                    class: format_args!("title {}", if show_title() { "fade-in" } else { "" }),
                    "InBreeze"
                }
                p {
                    class: format_args!("tagline {}", if show_tagline() { "fade-in" } else { "" }),
                    "Inner Breeze for Inner Peace"
                }
            }
        }
    }
}