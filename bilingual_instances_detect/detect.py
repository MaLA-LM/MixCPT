import json
import os
import fasttext

# from huggingface_hub import hf_hub_download
import argparse
import logging
from nltk.tokenize import sent_tokenize
import nltk
import multiprocessing

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)

custom_nltk_data_path = "/scratch/project_462000506/cache/nltk_data"
nltk.data.path.append(custom_nltk_data_path)


def load_model(model_path):
    logging.info("Loading the model...")
    # model_path = hf_hub_download(repo_id="cis-lmu/glotlid", filename="model.bin")
    return fasttext.load_model(model_path)


def split_sentences(text):
    return sent_tokenize(text)


def is_single_language(sentences, model):
    detected_langs = [model.predict(sentence)[0][0] for sentence in sentences]
    return len(set(detected_langs)) == 1


def process_file(file_path, language, model_path, output_folder):
    logging.info(f"Start processing file {file_path} for language {language}")
    model = load_model(model_path)
    with open(file_path, "r", encoding="utf-8") as file:
        lines = file.readlines()

    output_data = []
    for line in lines:
        data = json.loads(line)
        sentences = split_sentences(data["text"])
        if is_single_language(sentences, model):
            output_data.append({"text": data["text"]})

    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    output_file = os.path.join(
        output_folder,
        f"{os.path.basename(file_path).replace('.jsonl', '')}_cleaned.json",
    )
    with open(output_file, "w", encoding="utf-8") as outfile:
        json.dump(output_data, outfile, ensure_ascii=False, indent=2)
    logging.info(f"Data for language {language} written to {output_file}.")


def main(base_dir, languages, model_path):
    # model = load_model(model_path)
    pool = multiprocessing.Pool(processes=8)

    for lang in languages:
        directory = os.path.join(base_dir, lang)
        output_folder = os.path.join(directory, "../cleaned")
        files = [
            os.path.join(directory, f)
            for f in os.listdir(directory)
            if f.endswith(".jsonl")
        ]
        files = sorted(files)
        tasks = [(file, lang, model_path, output_folder) for file in files]
        pool.starmap(process_file, tasks)

    pool.close()
    pool.join()
    logging.info("Completed processing for all languages")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Clean and filter multilingual data points from datasets."
    )
    parser.add_argument(
        "--base_dir",
        type=str,
        required=True,
        help="Base directory containing language folders.",
    )
    parser.add_argument(
        "--model_path",
        type=str,
        required=True,
        help="GlotLID model path.",
    )
    parser.add_argument(
        "--languages", nargs="+", required=True, help="List of languages to process."
    )

    args = parser.parse_args()
    main(args.base_dir, args.languages, args.model_path)
