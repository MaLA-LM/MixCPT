# from huggingface_hub import hf_hub_download

# model_path = hf_hub_download(repo_id="cis-lmu/glotlid", filename="model.bin")
# print("model path:", model_path)

# import fasttext
# from pyfranc import franc

# model_path = '/scratch/project_462000506/cache/huggingface/hub/models--cis-lmu--glotlid/snapshots/083bc2c08b05dd302e5069eb89c956d4734cf3a3/model.bin'
# model = fasttext.load_model(model_path)
# test_case = '你好'


# print(model.predict(test_case)[0][0].replace('__label__', ''))

# print(franc.lang_detect(test_case)[0][0])


import nltk
import os

# 设置新的下载路径
new_path = '/scratch/project_462000506/cache/nltk_data'
if not os.path.exists(new_path):
    os.makedirs(new_path)

nltk.data.path.append(new_path)

# 下载数据到新路径
nltk.download('punkt', download_dir=new_path)

# 确认数据下载路径
print(nltk.data.find('tokenizers/punkt'))
