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
  - name: Kin-Wai Chuek
    affiliation: 2
affiliations:
 - name: Independent Researcher
   index: 1
 - name: Singapore University of Technology and Design
   index: 2
date: 14 September 2021
bibliography: paper.bib
---

# Abstract

Deep learning-based music source separation has gained a lot of interest in the last decades.
Most of the existing methods operate with either spectrograms or waveforms.
Spectrogram-based models learn suitable masks for separating magnitude spectrogram into different sources, and waveform-based models directly generate waveforms of individual sources.
The two types of models have complementary strengths; the former is superior given harmonic sources such as vocals, while the latter demonstrates better results for percussion and bass instruments.
In this work, we improved upon the state-of-the-art (SoTA) models and successfully combined the best of both worlds.
The backbones of the proposed framework, dubbed Danna-Sep^[<https://github.com/yoyololicon/danna-sep>], are two spectrogram-based models including a modified X-UMX and U-Net, and an enhanced Demucs as the waveform-based model.
Given an input of mixture, we linearly combined respective outputs from the three models to obtain the final result.
We showed in the experiments that, despite its simplicity, Danna-Sep surpassed the SoTA models by a large margin in terms of Source-to-Distortion Ratio. 

# Method

Danna-Sep is a combination of three different models: X-UMX, U-Net, and Demucs.
We describe the enhancements made for each model in the following subsections.

## X-UMX
X-UMX [@sawata20] improved upon UMX[@stoter19] by concatenating hidden layers of UMX to enable sharing information among all target instruments.
We trained the model using the same time-domain loss as the original X-UMX, but modified the frequency-domain loss for $j$-th source as follows:

$$\mathcal{L}_{MSE}^J = \sum_{j=1}^J\sum_{t,f}|Y_j(t, f) - \hat{Y}_j(t, f)|^2$$

where $Y(t, f)$ and $\hat{Y}(t, f)$ are ground-truth and estimated time-frequency representations, respectively. 
That is, instead of taking norm of the absolute value as in the original X-UMX, we calculated Euclidean norm in the complex domain.
Also, we incorporated Multichannel Wiener Filtering (MWF)[@antoine_liutkus_2019_3269749] into our training pipeline in order to train our model in an end-to-end fashion. We initialized our modified X-UMX with the official pre-trained X-UMX weights^[<https://zenodo.org/record/4740378/files/pretrained_xumx_musdb18HQ.pth>] and continued training for approximately 70 epochs with a batch size of four.

## U-Net
The encoder and decoder of our U-Net consist of six D3 Blocks [@Takahashi2021CVPR] and we added two layers of 2D local attention [@parmar2018image] layers at the bottleneck. We used the same loss function as X-UMX during training but with MWF being disabled. 
The approximated training time was nine days with a batch size of 16 on four Tesla V100 GPUs.
We also experimented with using biaxial biLSTM along the time and frequency axes as the bottleneck layers, but it took slightly longer to train yet offered a negligible improvement.

## Demucs
For Demucs [@defossez2019music], we built upon the variant with 48 hidden channels, and enhanced the model by replacing the decoder with four independent decoders responsible for four respective sources.
Each decoder has the same architecture as the original decoder, except for size of the hidden channel which was reduced to 24. 
This makes the total number of parameters comparable with the original Demucs.
The training loss aggregates the L1-norm between estimated and ground-truth waveforms of the four sources.
The model took approximately 10 days to train on a single RTX 3070 using mixed precision with a batch size of 16, and four steps of gradient accumulation.

## Danna-Sep
In order to obtain the final output of our framework, we calculated weighted average of individual outputs from the above-mentioned models.
Experiments were conducted to search for optimal weighting. The optimal weights for each source, types of input domain (T for waveforms, TF for frequency masking), and the sizes of the models are given in the following table.
|         | Drums | Bass | Other | Vocals | Input Domain | Size (Mb) | |---------|:-----:|:----:|:-----:|:------:|:------------:|:---------:| | X-UMX   | 0.2   | 0.1  | 0     | 0.2    | TF | 136
| U-Net   | 0.2   | 0.17 | 0.5   | 0.4    | TF | 61
| Demucs  | 0.6   | 0.73 | 0.5   | 0.4    | T | 733

All models were trained on the training set of musdb18-hq [@musdb18-hq] using an Adam optmizier[@kingma2014adam]. 

# Separation performances
We performed the benchmark using musdb18-hq [@musdb18] as the dataset for a fair comparison, and evaluated the models in terms of Signal-to-Distortion Ratio (SDR) [@vincent2006performance] derived from *museval* [@fabian_robert_stoter_2019_3376621].
One iteration of MWF was used for X-UMX and U-Net, and we didn't apply the shift trick [@defossez2019music] for our Demucs model.
The results of our models and their original counterparts are shown in the table below.

|         | Drums | Bass | Other | Vocals | Avg. |
|---------|:-----:|:----:|:-----:|:------:|:----:|
| X-UMX (baseline) | 6.44 | 5.54 | 4.46 | 6.54 | 5.75
| X-UMX (ours) | 6.71 | 5.79 | 4.63 | 6.93 | 6.02
| U-Net (ours) | 6.43 | 5.35 | 4.67 | 7.05 | 5.87
| Demucs (baseline) | 6.67 | 6.98 | 4.33 | 6.89 | 6.21 
| Demucs (ours) | 6.72 | 6.97 | 4.4 | 6.88 | 6.24
| Danna-Sep | **7.2** | **7.05** | **5.2** | **7.63** | **6.77**

As can be seen from the table, our modified X-UMX gained an extra 0.27 dB on average SDR compared to the original X-UMX.
Our enhanced Demucs outperformed the original model by 0.03 dB of SDR, despite the fact that the shift trick was not applied.
Notably, Danna-Sep surpassed both the original and enhanced Demucs by a large margin (+0.53 dB on average SDR).
Altogether, the results demonstrate the efficacy of the proposed fusion method in addition to our modifications for the training scheme and architecture.
The proposed framework, however, is more reliant on computing power due to the nature of model fusion, which we would like to address in furture work.


# Acknowledgements

We acknowledge contributions from Sung-Lin Yeh and Yu-Te Wu, and supports from Yin-Jyun Luo and Showmin Wang during the genesis of this project.

# References
