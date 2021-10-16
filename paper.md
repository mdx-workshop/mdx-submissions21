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

Music source separation (MSS) has shown tremendous success with deep learning models. Many MSS models perform separations on spectrogram by estimating bounded ratio masks and reusing the phase of mixture. If the model is convolutional neural network (CNN) based, weights are usually shared in each channel during convolution, regardless of the dissimilar patterns between frequency bands. In this study, we proposed a new model, channel-wise subband phase-aware ResUNet (CWS-PResUNet), which estimates unbound mask and phase variations in subbands for separations. CWS-PResUNet utilizes channel-wise subband (CWS) feature to limit unnecessary global weight sharing on spectrogram and reduce computational resource consumptions. The resource saved by CWS can in turn allow for a larger architecture. On MUSDB18HQ test set, a 276-layer CWS-PResUNet achieves state-of-the-art performance on *vocals* with a 8.92 SDR score. Based on CWS-PResUNet and Demucs, our ByteMSS system^[https://github.com/haoheliu/2021-ISMIR-MSS-Challenge-CWS-PResUNet] ranks 2nd on *vocals* score and 5th on average score in 2021 ISMIR Music Demixing Challenge limited training data track (leaderboard A).

# Method

![Overview of our system and a comparison between using magnitude and channel-wise subband spectrogram as the input feature.](graphs/main.png){ width=100% }

**ByteMSS** is our system submitted for the MDX Challenge[@mitsufuji2021music]. We setup demucs[@defossez2019demucs] to separate `bass` and `drums`, a 166-layer CWS-ResUNets for `other`, and a 276-layer CWS-PResUNets for `vocals`. 

**CWS-PResUNet** is a ResUNet[@zhang2018road,@liu2021voicefixer] based model integrating CWS feature [@liu2020channel] and the complex ideal ratio mask (cIRM) estimation strategies described in [@kong2021decoupling]. The overall pipline is summerized in Figure 1a. CWS-PResUNet contains a down-sampling and a up-sampling path with skip connections between the same level. As shown in Figure 1b, the CWS feature can make the CNN featuremaps smaller and save computational resources. Also, CNN will have separate weights in each channel by using CWS feature, in which case model becomes more efficient by diverging subband information into channels and enlarging receptive fields. Moreover, because bounded mask and mixture phase can limit the theoretical upper bound of MSS system [@kong2021decoupling], we estimate unbounded mask and phase variations in each subband to compute the unbounded cIRM. 

Normally source-dedicated model only need to predict one source. And our `vocals` model only calculate L1 loss between the `vocals` target and estimation. But for `other` track, we notice estimating and optimizing four sources together is beneficial. So, in this case, we calculate both L1 loss and energy conservation loss across four sources to optimize our model.

**Demucs** is a model that perform separation in the time domain. In our study we adopted the open-sourced pretrained demucs^[https://github.com/facebookresearch/demucs], which is also trained on MUSDB18HQ.

# Experiments

The following table lists the results of the baselines and our proposed system. All the models are optimized using the training part of MUSDB18HQ. We perform evaluation with the open-sourced tool *museval*[@SiSEC18]. We suppose freqeuncy domain model is more powerful on modeling complex harmonic patterns and time domain model is better for purcussive and band-limited patterns. Evaluation on MUSDB18HQ test set shows our CWS-PResUNets achieve a SDR of 8.92 and 5.84 on `vocals` and `other` sources, respectively, outperforming baseline system UMX, X-UMX[@x-umx-sawata2021all], and Demucs by a large margin. Although the performance on `bass` and `drums`

|    Models    | Vocals | Drums |  Bass | Other | Average |
|:------------:|:------:|:-----:|:-----:|:-----:|:-------:|
|      UMX     |  6.25  |  6.04 |  5.07 |  4.28 |  5.41   |
|     X-UMX    |  6.61  | 6.47  | 5.43  | 4.64  |  5.79   |
|    Demucs    |  6.89  | **6.57**  | **6.53**  | 5.14  |  6.28   |
| CWS-PResUNet |  **8.92**  | 6.38  | 5.93  | **5.84**  |  6.77   |
|    ByteMSS   |  8.92  | 6.57  | 6.53  | 5.84  |  **6.97**   |

# Discussions

# Reference