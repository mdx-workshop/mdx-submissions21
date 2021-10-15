---
title: 'CWS-PResUNet: Music Source Separation with Channel-wise Subband Phase-aware ResUNet'
tags:
  - music
  - separation
  - channel-wise subband
  - resunet
authors:
  - name: Haohe Liu # note this makes a footnote saying 'co-first author'
    orcid: 0000-0003-1036-7888
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
  - name: Qiuqiang Kong # note this makes a footnote saying 'co-first author'
    affiliation: 1
  - name: Jiafeng Liu
    affiliation: 1
affiliations:
 - name: Sound, Audio, and Music Intelligence (SAMI) Group, ByteDance
   index: 1
 - name: The Ohio State University
   index: 2
date: 10 Oct 2021
bibliography: paper.bib
# arxiv-doi: 10.21105/joss.01667
---

# Abstract

Music source separation (MSS) has shown tremendous success with deep learning models. Many MSS models perform separations on spectrogram by estimating bounded ratio masks and reusing the phase of mixture. If the model is convolutional neural network (CNN) based, weights are usually shared in each channel during convolution, regardless of the dissimilar patterns between frequency bands. In this study, we proposed a new model, channel-wise subband phase-aware ResUNet (CWS-PResUNet), which estimates unbound mask and phase variations in subbands for separations. CWS-PResUNet utilizes channel-wise subband (CWS) feature to limit unnecessary global weight sharing on spectrogram and reduce computational resource consumptions. The resource saved by CWS can in turn allow for a larger architecture. On MUSDB18HQ test set, a 276-layer CWS-PResUNet achieves state-of-the-art performance on *vocals* with a 8.92 SDR score. Based on CWS-PResUNet and Demucs, our system ranks 2nd on *vocals* score and 5th on average score in 2021 ISMIR Music Demixing Challenge limited training data track (leaderboard A).

# Methodology

![Overview of our system and a comparison between using magnitude and channel-wise subband spectrogram as the input feature.](graphs/main.png){ width=100% }

# Experiment Results

|    Models    | Vocals | Drums |  Bass | Other | Average |
|:------------:|:------:|:-----:|:-----:|:-----:|:-------:|
|      UMX     |  6.25  |  6.04 |  5.07 |  4.28 |  5.41   |
|     X-UMX    |  6.61  | 6.47  | 5.43  | 4.64  |  5.79   |
|    Demucs    |  6.89  | **6.57**  | **6.53**  | 5.14  |  6.28   |
| CWS-PResUNet |  **8.92**  | 6.38  | 5.93  | **5.84**  |  6.77   |
|    ByteMSS   |  8.92  | 6.57  | 6.53  | 5.84  |  **6.97**   |

# Discussions

# Reference