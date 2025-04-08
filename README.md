


# Rethinking Multilingual Continual Pretraining

This repository contains data cleaning, training, and evaluation scripts used in the paper:

**Rethinking Multilingual Continual Pretraining: Data Mixing for Adapting LLMs Across Languages and Resources**  
*Zihao Li, Shaoxiong Ji, Hengyu Luo, Jörg Tiedemann*

> **Abstract**: Large Language Models (LLMs) exhibit significant disparities in performance across languages, primarily benefiting high-resource languages while marginalizing underrepresented ones. Continual Pretraining (CPT) has emerged as a promising approach to address this imbalance, although the relative effectiveness of monolingual, bilingual, and code-augmented data strategies remains unclear. This study systematically evaluates 36 CPT configurations involving three multilingual base models, across 30+ languages categorized as altruistic, selfish, and stagnant, spanning various resource levels. Our findings reveal three major insights: (1) Bilingual CPT improves multilingual classification but often causes language mixing issues during generation. (2) Including programming code data during CPT consistently enhances multilingual classification accuracy, particularly benefiting low-resource languages, but introduces a trade-off by slightly degrading generation quality. (3) Contrary to prior work, we observe substantial deviations from language classifications according to their impact on cross-lingual transfer: Languages classified as altruistic often negatively affect related languages, selfish languages show conditional and configuration-dependent behavior, and stagnant languages demonstrate surprising adaptability under certain CPT conditions. These nuanced interactions emphasize the complexity of multilingual representation learning, underscoring the importance of systematic studies on generalizable language classification to inform future multilingual CPT strategies.

---

## 🔧 Repository Structure

```
mixing-ablation/
├── train_config/  
├── evaluation/
│   ├── SIB-200/                  
│   └── FLORES-200/                    
├── bilingual_instances_detect/  
├── .gitignore
└── README.md
```

---

## 🚀 Continual Pretraining Configurations

Models are named using the format:  
`Model-Data[+Code]-LangCat`, where:

- `Model`: L3 (Llama-3.1-8B), L2 (Llama-2-7B), V7 (Viking-7B)  
- `Data`: Mono (monolingual), Bi (bilingual)  
- `+Code`: (optional) indicates inclusion of code data  
- `LangCat`: Alt (altruistic), Sel (selfish), Stag (stagnant)

Example:
```
L3-Bi+Code-Stag → Llama-3.1-8B continually pretrained on bilingual+code data for stagnant languages
```

---

## 📊 Evaluation

We evaluate on:

- **SIB-200**: Topic classification benchmark 
- **FLORES-200**: Machine translation benchmark

All evaluations use 3-shot prompting.

---

## 🧠 Models

We release all **36 CPT models** on [🤗Hugging Face](https://huggingface.co/collections/Zihao-Li/multilingual-continual-pretraining-67ea87fbc68ccdaa83fdc01c).

---

## 📁 Datasets

- Monolingual: Subset of `[MADLAD-400]`
- Bilingual: Subset of `[Lego-MT&NLLB]`
- Code: Subset of `[The Stack]`

We release the filtered dataset links on [🤗Hugging Face](https://huggingface.co/collections/Zihao-Li/multilingual-continual-pretraining-67ea87fbc68ccdaa83fdc01c).

---

## ⚙️ Training Setup

- Framework: [LLaMA-Factory](https://github.com/hiyouga/LLaMA-Factory)
- Optimizer: DeepSpeed ZeRO-3  
- Hardware: 4 × AMD MI250X GPUs per node  
- Hyperparams:
  - Learning rate: `4e-5`
  - Scheduler: `cosine`
  - Batch size: `8 per device`
  - Accumulation: `2 steps`
  - Epochs: `2`

---


## 📝 Citation

```bibtex
@article{MixCPT,
    title={Rethinking Multilingual Continual Pretraining: Data Mixing for Adapting LLMs Across Languages and Resources}, 
    author={Zihao Li and Shaoxiong Ji and Hengyu Luo and Jörg Tiedemann},
    year={2025},
    journal={arXiv preprint 2504.04152},
    url={https://arxiv.org/abs/2504.04152}, 
}
```

---

## 📬 Contact

For questions or collaborations, please contact:
- zihao.li@helsinki.fi
