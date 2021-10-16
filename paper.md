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

Music source separation (MSS) has shown tremendous success with deep learning models. Many MSS models perform separations on spectrogram by estimating bounded ratio mask and reusing the phase of the mixture. If the model is a convolutional neural network (CNN) based, weights are usually shared within channels during convolution, regardless of the dissimilar patterns between frequency bands. In this study, we proposed a new MSS model, channel-wise subband phase-aware ResUNet (CWS-PResUNet), which estimates unbound mask and phase variations in subbands for separations. CWS-PResUNet utilizes channel-wise subband (CWS) feature to limit unnecessary global weight sharing on the spectrogram and reduce computational resource consumptions. The resource saved by CWS can in turn allow for a larger architecture. On the MUSDB18HQ test set, a 276-layer CWS-PResUNet achieves state-of-the-art (SoTA) performance on `vocals` with an 8.92 signal-to-distortion ratio (SDR) score. Based on CWS-PResUNet and Demucs, our ByteMSS system^[https://github.com/haoheliu/2021-ISMIR-MSS-Challenge-CWS-PResUNet] ranks 2nd on `vocals` score and 5th on average score in the 2021 ISMIR Music Demixing Challenge limited training data track (leaderboard A).

# Method

![Overview of our system and a comparison between using magnitude and channel-wise subband spectrogram as the input feature.](graphs/main.png){ width=100% }

**ByteMSS** is our system submitted for the MDX Challenge[@mitsufuji2021music]. we set up a 276-layer CWS-ResUNet to separate the `vocals` track, a 166-layer CWS-PResUNet for `other` track, and the open-sourced demucs[@defossez2019demucs] for `bass` and `drums` tracks. 

**CWS-PResUNet** is a ResUNet[@zhang2018road;@liu2021voicefixer] based model integrating CWS feature [@liu2020channel] and the complex ideal ratio mask (cIRM) estimation strategies described in [@kong2021decoupling]. The overall pipeline is summarized in Figure 1a. We use pre-defined filters to perform subband analysis and synthesis. The phase-aware ResUNet is a symmetric architecture containing a down-sampling and an up-sampling path with skip connections between the same level. It accepts subband magnitude spectrograms as input and estimates unbounded cIRMs. The CWS input is illustrated in Figure 1b, where * stands for convolution operation and the subscripts denote the shape of tensors. The CWS feature can make the CNN featuremaps smaller and save computational resources. Also, CWS input makes CNN to have separate weights for each subband, in which case the model becomes more efficient by diverging subband information into channels and enlarging receptive fields. Moreover, because bounded mask and mixture phase can limit the theoretical upper bound of the MSS system [@kong2021decoupling], we estimate unbounded mask and phase variations in each subband to compute the unbounded cIRM. Our `vocals` model is optimized by calcualting L1 loss between the estimation and target. Despite we also use a model dedicated to separate `other` track, we notice estimating and optimizing four sources together can result in a 0.2 SDR gain on `other`. So, we calculate both L1 loss and energy-conservation loss across four sources to optimize our `other` model. Our CWS-PResUNet `bass` and `drums` models employ the same set up as the `other` model.

**Demucs** is a time domain MSS model. In our study, we adopted the open-sourced pre-trained demucs^[https://github.com/facebookresearch/demucs] and do not apply the shift trick because it will slow down the inference speed.

# Experiments

Models are optimized using the training part of MUSDB18HQ[@rafii2019musdb18]. We use Adam optimizer with learning-rate warmup and exponential decay. CWS-PResUNet takes approximately five days to train on a Tesla V100 GPU. During inference, we utilize a 10-second long `boxcar` windowing function with no overlapping to segment the signal. For evaluation, we report the SDR on the MUSDB18HQ test set with the open-sourced tool *museval*[@SiSEC18]. 

The following table lists the results of the baselines and our proposed system. Our CWS-PResUNets achieve an SDR of 8.92 and 5.84 on `vocals` and `other` sources, respectively, outperforming baseline system X-UMX[@x-umx-sawata2021all], D3Net[@takahashi2020d3net], and Demucs by a large margin. Regardless of the inferior performance on `vocals` and `other` tracks, demucs performs better than CWS-PResUNet on `bass` and `drums` tracks. We assume that is because time-domain models are not bottlenecked with fixed spectrogram resolution setting as in the frequency model and are more suitable on percussive and band-limited sources. On considering the high performance of the `vocals` model, we also attemp to separating three instrumental sources from `mixture` minus `vocals`. The average performance of our ByteMSS system is 6.97, marking a SoTA performance on MSS. The average score in this case remain 6.97, in which drums score increase to 6.72 but other three sources drop slightly. Future work will address the integration of time and frequency models for the compensations in both domains.

|    Models    | Vocals | Drums |  Bass | Other | Average |
|:------------:|:------:|:-----:|:-----:|:-----:|:-------:|
|     X-UMX    |  6.61  |  6.47  | 5.43  | 4.64  |  5.79  |
|     D3Net    |  7.24  |  7.01 |  5.25 |  4.53 |  6.01   |
|    Demucs    |  6.89  | **6.57**  | **6.53**  | 5.14  |  6.28   |
| CWS-PResUNet |  **8.92**  | 6.38  | 5.93  | **5.84**  |  6.77   |
|    ByteMSS   |  8.92  | 6.57  | 6.53  | 5.84  |  **6.97**   |


<!-- # Conclusion -->


# Reference