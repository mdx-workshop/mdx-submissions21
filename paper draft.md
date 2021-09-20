---
title: 'Danna-Sep: the ultimate music source separation tool'
tags:
  - separation
  - music information retrieval
  - audio signal processing
  - artificial intelligence
  - u-net
  - lstm
  - end-to-end learning
authors:
  - name: Chin-Yun Yu
    affiliation: 1
affiliations:
 - name: Independent Researcher
   index: 1
date: 14 September 2021
bibliography: paper.bib
arxiv-doi: 10.21105/joss.01667
---

# Summary

We present and release a new tool for music source separation with pre-trained models called
Danna-Sep. Danna-Sep is designed for ease of use and separation performance with a compact command-line interface. Danna-Sep is based on PyTorch[@], and it incorporates:

- split music audio files into 4 stems (vocals, drums, bass, and other) as .wav files with a single command line using pre-trained
models. 
- train source separation models or fine-tune pre-trained ones with PyTorch on musdb18 dataset [@].

The performance of the pre-trained models surpassed published state-of-the-art and won the 4th place at Music Demixing Challenge 2021 [@] within the constraint of training solely on musdb18. Because the pre-trained models are stored as TorchScript, the required dependencies to operate the model is in minimum, which also make it possible to be ported on edge devices.

# Implementation details

The output of Danna-Sep is computed by blending three different models. The first one is X-UMX [@]. We trained it using the same loss function from the original paper, but modified the frequency domain loss to the following equation:

$$\mathcal{L}_{MSE}^J = \sum_{j=1}^J\sum_{t,f}|Y_j(t, f) - \hat{Y}_j(t, f)|^2$$

Also, we incorporated Multichannel Wiener Filtering (MWF)[@] into our training pipeline. The training was done by using the official X-UMX model as initial values and continue training with a batch size of 4 on a single RTX 3070.

The second one was originated from Demucs [@]. We chose the version with 48 hidden channel size as our starting point, then we replaced the decoder part of the network by four independent decoders, each of which corresponds to one source. These four decoders have the same architecture compared to the original decoder network while the hidden channel size was reduced to 24 so the total number of parameters is roughly the same. The training loss is a L1-norm between predicted waveform and source-target waveform, and it took about 10 days to train on a single RTX 3070 using mixed precision with a batch size of 16, 4 steps of gradient accumulation.

The third one is a U-Net with 6 layers for the decoder and the encoder. We use D3 Block [@] for each layer and add two layers of 2D local attention [@] at the bottleneck. The same loss fucntion we trained on X-UMX was used with MWF being disabled. Training time took approximately 9 days with a batch size of 16 on four Tesla V100.

Finally, we multiply each source from each model with different weights, and take summation amoung the models as our final values. The weights for each source and the size of the models are given in the following table.

|         | Drums | Bass | Other | Vocals | Size (Mb) |
|---------|:-----:|:----:|:-----:|:------:|:---------:|
| X-UMX   | 0.2   | 0.1  | 0     | 0.2    | 136
| U-Net   | 0.2   | 0.17 | 0.5   | 0.4    | 61
| Demucs  | 0.6   | 0.73 | 0.5   | 0.4    | 733

All models were trained on the training set of musdb18 using Adam [@].

# Separation performances

|         | Drums | Bass | Other | Vocals | Avg. |
|---------|:-----:|:----:|:-----:|:------:|:----:|
| U-Net (ours) | 6.09 | 5.25 | 4.52 | 7.08 | 5.74
| X-UMX | 6.47 | 5.43 | 4.64 | 6.61 | 5.79
| X-UMX (ours) | 6.26 | 5.73 | 4.56 | 7.04 | 5.90
| Demucs (48 channels) | - | - | - | - | 6.20
| Demucs (ours) | 6.63 | 6.9 | 4.39 | 6.97 | 6.22
| Demucs | 6.86 | 7.01 | 4.42 | 6.84 | 6.28
| Danna-Sep | 7.04 | 6.97 | 5.18 | 7.71 | 6.73

# Distribution

Danna-Sep is available as a standalone Python package, and also provided as a conda recipe and
self-contained Dockers which makes it usable as-is on various platforms.

# Future Work

# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"


# Acknowledgements

We acknowledge contributions from Brigitta Sipocz, Syrtis Major, and Semyeong
Oh, and support from Kathryn Johnston during the genesis of this project.

# References