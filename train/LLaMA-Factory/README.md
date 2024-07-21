# Fine-tuning with LLaMA-Factory
## Setup
```bash
git clone --depth 1 https://github.com/hiyouga/LLaMA-Factory.git
cd LLaMA-Factory
pip install -e ".[metrics]"
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

Works fine on both.