# Fine-tuning with HuggingFace+DeepSpeed
## Setup
```bash
pip install -r requirements.txt
```
**On Mahti:**
```bash
pip3 install torch torchvision torchaudio
pip3 install deepspeed
```
**On Lumi:**
```bash
pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/rocm5.6
pip3 install deepspeed
```

Works fine on Mahti, but reports error on Lumi if DeepSpeed is enabled.