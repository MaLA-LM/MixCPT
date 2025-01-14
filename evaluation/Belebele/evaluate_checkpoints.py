import os
import json
import pandas as pd
from google_sheet import write2sheet

# Main directory containing the results
main_directory = "/scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Belebele/Results_3shots"

# List of models to process
models_to_process = [
    "Llama-3.1-8B-Bilingual-Selfish",
    "Llama-3.1-8B-Bilingual-Code-Selfish",
    "Llama-3.1-8B-Monolingual-Selfish",
    "Llama-3.1-8B-Monolingual-Code-Selfish",
    "Llama-3.1-8B-Bilingual-Altruistic",
    "Llama-3.1-8B-Bilingual-Code-Altruistic",
    "Llama-3.1-8B-Monolingual-Altruistic",
    "Llama-3.1-8B-Monolingual-Code-Altruistic",
    "Llama-3.1-8B-Bilingual-Stagnant",
    "Llama-3.1-8B-Bilingual-Code-Stagnant",
    "Llama-3.1-8B-Monolingual-Stagnant",
    "Llama-3.1-8B-Monolingual-Code-Stagnant",
]

# Iterate through each model and process its checkpoints
for model_name in models_to_process:
    model_path = os.path.join(main_directory, model_name)
    result_df = pd.DataFrame()

    if os.path.isdir(model_path):
        checkpoint_data = {}
        for checkpoint_folder in os.listdir(model_path):
            checkpoint_path = os.path.join(model_path, checkpoint_folder)
            if os.path.isdir(checkpoint_path):
                for lang_folder in os.listdir(checkpoint_path):
                    lang_path = os.path.join(checkpoint_path, lang_folder)
                    if os.path.isdir(lang_path):
                        for sub_dir in os.listdir(lang_path):
                            sub_dir_path = os.path.join(lang_path, sub_dir)
                            if os.path.isdir(sub_dir_path):
                                for file_name in os.listdir(sub_dir_path):
                                    if file_name.endswith(".json"):
                                        json_file_path = os.path.join(
                                            sub_dir_path, file_name
                                        )

                                        with open(
                                            json_file_path, "r", encoding="utf-8"
                                        ) as f:
                                            data = json.load(f)

                                        if "results" in data and isinstance(
                                            data["results"], dict
                                        ):
                                            languages_in_json = list(
                                                data["results"].keys()
                                            )
                                            if languages_in_json:
                                                json_lang = languages_in_json[0]
                                                lang = json_lang[9:]
                                                if (
                                                    "acc,none"
                                                    in data["results"][json_lang]
                                                ):
                                                    acc_none = data["results"][
                                                        json_lang
                                                    ]['acc,none']
                                                    if lang not in checkpoint_data:
                                                        checkpoint_data[lang] = {}
                                                    checkpoint_data[lang][checkpoint_folder] = round(acc_none, 4)

        # Convert to DataFrame
        result_df = pd.DataFrame.from_dict(checkpoint_data, orient='index')
        result_df.reset_index(inplace=True)
        result_df.rename(columns={'index': 'Language'}, inplace=True)

    # Clean the DataFrame to ensure JSON compliance
    result_df = result_df.replace([float('inf'), float('-inf'), None], pd.NA).fillna('').astype(str)

    # Write each model's data to a separate sheet in the Google Sheet
    write2sheet(f"Belebele-3shots-{model_name}", result_df)