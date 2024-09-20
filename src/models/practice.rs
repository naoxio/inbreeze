use serde::Deserialize;

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct Practice {
    pub id: String,
    pub name: String,
    pub description: String,
    pub author: String,
    pub version: String,
    pub category: String,
    pub tags: Vec<String>,
    pub origin: String,
    pub difficulty: String,
    pub duration: Duration,
    pub visual: Visual,
    pub practice_structure: PracticeStructure,
    pub ui_elements: Vec<UIElement>,
    pub user_inputs: Vec<UserInput>,
    pub safety_notes: Vec<String>,
    pub implementation_notes: Vec<String>,
    pub benefits: Vec<String>,
    pub contraindications: Vec<String>,
    pub assets: Assets,
    pub customization_options: Vec<CustomizationOption>,
    pub data_tracking: Vec<DataTracking>,
    pub references: Vec<Reference>,
}
impl Practice {
    pub fn current_sequence(&self, index: usize) -> Option<&Sequence> {
        self.practice_structure.sequences.get(index)
    }

    pub fn current_step(&self, sequence_index: usize, step_index: usize) -> Option<&Step> {
        self.current_sequence(sequence_index)
            .and_then(|seq| seq.steps.get(step_index))
    }

    pub fn total_rounds(&self) -> u32 {
        self.practice_structure.rounds.default
    }

    pub fn total_sequences(&self) -> usize {
        self.practice_structure.sequences.len()
    }
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct Duration {
    pub average: u32,
    pub unit: String,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct Visual {
    pub background_image: String,
    pub background_color: String,
    pub icon: String,
    pub colors: Colors,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct Colors {
    pub primary: String,
    pub secondary: String,
    pub text: String,
    pub title: String,
    pub button: String,
    pub button_hover: String,
    pub button_disabled: String,
    pub button_text: String,
    pub button_disabled_text: String,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct PracticeStructure {
    pub rounds: RoundConfig,
    pub sequences: Vec<Sequence>,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct RoundConfig {
    pub default: u32,
    pub range: Vec<u32>,
    pub label: String,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct Sequence {
    pub id: String,
    pub name: String,
    pub repeats: Option<RepeatConfig>,
    pub steps: Vec<Step>,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct RepeatConfig {
    pub default: u32,
    pub range: Vec<u32>,
    pub label: String,
}


#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct Step {
    pub id: String,
    pub name: String,
    pub instruction: String,
    pub duration: StepDuration,
    pub sounds: Option<Vec<String>>,
    pub track_data: Option<bool>,
}



#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct StepDuration {
    #[serde(rename = "type")]
    pub duration_type: String,
    pub value: Option<u32>,
    pub unit: Option<String>,
    pub options: Option<Vec<DurationOption>>,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct DurationOption {
    #[serde(rename = "type")]
    pub option_type: String,
    pub default: Option<u32>,
    pub range: Option<Vec<u32>>,
    pub unit: Option<String>,
    pub label: Option<String>,
    pub instruction: Option<String>,
    pub end_trigger: Option<String>,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct UIElement {
    pub id: String,
    #[serde(rename = "type")]
    pub element_type: String,
    pub description: String,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct UserInput {
    pub id: String,
    pub name: String,
    #[serde(rename = "type")]
    pub input_type: String,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct Assets {
    #[serde(default)]
    pub sounds: Vec<Asset>,
    #[serde(default)]
    pub videos: Vec<Asset>,
    #[serde(default)]
    pub images: Vec<Asset>,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct Asset {
    pub id: String,
    pub file: String,
}


#[derive(Debug, Deserialize, Clone, PartialEq)]
#[serde(untagged)]
pub enum CustomizationOptionValue {
    Numeric {
        range: Option<Vec<f32>>,
        default: f32,
        step: Option<f32>,
        unit: Option<String>,
    },
    Dropdown {
        options: Vec<String>,
        default: String,
    },
    Toggle {
        default: bool,
    },
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct CustomizationOption {
    pub id: Option<String>,
    pub name: String,
    pub description: String,
    #[serde(rename = "type")]
    pub option_type: String,
    #[serde(flatten)]
    pub value: CustomizationOptionValue,
}


#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct DataTracking {
    pub id: Option<String>,
    pub metric: Option<String>,
    pub name: Option<String>,
    pub description: String,
    pub unit: Option<String>,
}

#[derive(Debug, Deserialize, Clone, PartialEq)]
pub struct Reference {
    pub key: String,
    #[serde(rename = "type")]
    pub reference_type: String,
    pub title: Option<String>,
    pub author: Option<String>,
    pub authors: Option<Vec<String>>,
    pub year: Option<u32>,
    pub journal: Option<String>,
}