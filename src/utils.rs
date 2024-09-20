pub fn get_time_unit_short_code(unit: &str) -> &str {
    match unit.to_lowercase().as_str() {
        "seconds" | "second" => "s",
        "minutes" | "minute" => "min",
        "hours" | "hour" => "h",
        "days" | "day" => "d",
        "weeks" | "week" => "wk",
        "months" | "month" => "mo",
        "years" | "year" => "yr",
        _ => "",
    }
}

pub fn capitalize_first_letter(s: &str) -> String {
    let mut c = s.chars();
    match c.next() {
        None => String::new(),
        Some(f) => f.to_uppercase().collect::<String>() + c.as_str(),
    }
}

pub fn generate_clock_svg(minutes: u32) -> String {
    let total_hours = minutes as f64 / 60.0;
    let hours = total_hours.floor();
    let remaining_minutes = (total_hours.fract() * 60.0).round() as u32;

    // Calculate hour hand position
    let hour_angle = (hours % 12.0 + remaining_minutes as f64 / 60.0) / 12.0 * 360.0;
    let hour_radians = hour_angle.to_radians();
    let hour_x = 12.0 + 5.0 * hour_radians.sin();
    let hour_y = 12.0 - 5.0 * hour_radians.cos();

    // Calculate minute hand position
    let minute_angle = remaining_minutes as f64 / 60.0 * 360.0;
    let minute_radians = minute_angle.to_radians();
    let minute_x = 12.0 + 7.0 * minute_radians.sin();
    let minute_y = 12.0 - 7.0 * minute_radians.cos();

    format!(
        r#"<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-clock">
            <circle cx="12" cy="12" r="10"/>
            <polyline points="12 12 {:.2} {:.2}"/> <!-- Hour hand -->
            <polyline points="12 12 {:.2} {:.2}"/> <!-- Minute hand -->
        </svg>"#,
        hour_x, hour_y, minute_x, minute_y
    )
}
