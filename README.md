# 🐦 Bird Recognition from Audio Signals

This project aims to recognize bird species based on their vocalizations by analyzing audio files using signal processing techniques in MATLAB.

## 📌 Overview

Bird calls often contain species-specific time and frequency characteristics. By studying these features, we can identify the bird species present in an audio sample. This project uses **spectrogram-based analysis and correlation** to distinguish and classify bird calls.

## 🗂️ Dataset

- **Reference Folder** (`Reference/`): Contains labeled `.wav` audio files of three known bird species.
- **Task Folder** (`Task/`): Contains unlabeled `.wav` audio files to be classified.

## 🎯 Objective

- Extract distinguishing spectral features from reference bird calls.
- Compare these features with task audio samples using **2D cross-correlation**.
- Identify and label the bird species in each task file based on the best match.
- Visualize spectrograms and display dominant frequency peaks for interpretability.

## ⚙️ Methodology

1. **Preprocessing**:
   - Normalize all audio signals.
   - Compute spectrograms (`256`-point FFT, `128` overlap) for each file.

2. **Feature Extraction**:
   - Use the magnitude of the spectrograms as feature representations.

3. **Similarity Matching**:
   - For each task file, compute the 2D cross-correlation with each reference spectrogram.
   - Identify the best match based on the maximum correlation value.

4. **Visualization**:
   - Plot spectrograms of task and matched reference audio.
   - Highlight dominant frequency peaks using `findpeaks()`.

## 📊 Example Output

- Correlation scores are printed for each task file.
- Spectrogram comparison is visualized with labeled plots.
- Frequency peaks are shown for deeper analysis.
- Final classification is printed:

## 💻 Tools Used

- **Language**: MATLAB
- **Libraries**: Signal Processing Toolbox
- **Techniques**: Spectrogram analysis, cross-correlation, frequency peak detection


