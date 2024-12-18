import os
import json
import pandas as pd
from google_sheet import write2sheet

main_directory = "/scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Belebele/Results_3shots"
result_df = pd.DataFrame(columns=["Language"])

for model_name in os.listdir(main_directory):
    model_path = os.path.join(main_directory, model_name)
    if os.path.isdir(model_path):
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
                                                    ]["acc,none"]

                                                    if (
                                                        lang
                                                        not in result_df[
                                                            "Language"
                                                        ].values
                                                    ):
                                                        result_df = pd.concat(
                                                            [
                                                                result_df,
                                                                pd.DataFrame(
                                                                    {"Language": [lang]}
                                                                ),
                                                            ],
                                                            ignore_index=True,
                                                        )

                                                    # column_name = f"{model_name}_{checkpoint_folder}"
                                                    result_df.loc[
                                                        result_df["Language"] == lang,
                                                        model_name,
                                                    ] = round(acc_none, 4)

result_df = result_df.fillna("")

write2sheet("Belebele-3shots", result_df)
