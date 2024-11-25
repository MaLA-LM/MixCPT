import os
import json
import pandas as pd
from google_sheet import write2sheet

main_directory = "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Sib-200/Results"
result_df = pd.DataFrame(columns=["Language"])

# 遍历每个模型文件夹
for model_name in os.listdir(main_directory):
    model_path = os.path.join(main_directory, model_name)
    
    if os.path.isdir(model_path):  # 确保是一个文件夹
        # 遍历模型文件夹内的子文件夹
        for sub_folder in os.listdir(model_path):
            sub_folder_path = os.path.join(model_path, sub_folder)
            
            if os.path.isdir(sub_folder_path):  # 确保是一个文件夹
                for file_name in os.listdir(sub_folder_path):
                    if file_name.endswith('.jsonl'):  # 只处理JSONL文件
                        language = file_name.split('.')[0]
                        file_path = os.path.join(sub_folder_path, file_name)
                        
                        # 读取JSONL文件并计算准确率
                        with open(file_path, 'r', encoding='utf-8') as file:
                            predictions = [json.loads(line) for line in file]
                        
                        total = len(predictions)
                        correct = sum(1 for pred in predictions if pred["predicted_category"] == pred["correct_category"])
                        accuracy = correct / total if total > 0 else 0
                        
                        # 将结果添加到DataFrame中
                        if language not in result_df["Language"].values:
                            result_df = pd.concat([result_df, pd.DataFrame({"Language": [language]})], ignore_index=True)
                        
                        result_df.loc[result_df["Language"] == language, model_name] = round(accuracy, 4)

# 显示最终结果
# print(result_df)

result_df = result_df.fillna("")
write2sheet("SIB-200", result_df)

# 如果需要保存到文件
# result_df.to_csv("Sib-200-results.csv", index=False)
