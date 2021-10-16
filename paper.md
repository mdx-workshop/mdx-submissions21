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

Music source separation (MSS) has shown tremendous success with deep learning models. Many MSS models perform separations on spectrogram by estimating bounded ratio mask and reusing the phase of the mixture. If the model is convolutional neural network (CNN) based, weights are usually shared within spectrogram during convolution, regardless of the dissimilar patterns between frequency bands. In this study, we proposed a new MSS model, channel-wise subband phase-aware ResUNet (CWS-PResUNet), which estimates source subband unbound mask and phase variations. CWS-PResUNet utilizes channel-wise subband (CWS) feature to limit unnecessary global weight sharing on the spectrogram and reduce computational resource consumptions. The resource saved by CWS can in turn allow for a larger architecture. On the MUSDB18HQ test set, a 276-layer CWS-PResUNet achieves state-of-the-art (SoTA) performance on `vocals` with an 8.92 signal-to-distortion ratio (SDR) score. Based on CWS-PResUNet and Demucs, our ByteMSS system^[https://github.com/haoheliu/2021-ISMIR-MSS-Challenge-CWS-PResUNet] ranks 2nd on `vocals` score and 5th on average score in the 2021 ISMIR Music Demixing (MDX) Challenge limited training data track (leaderboard A).

# Method

![Overview of our system and a comparison between using magnitude and channel-wise subband spectrogram as the input feature.](graphs/main.png){ width=100% }

**ByteMSS** is our system submitted for the MDX Challenge[@mitsufuji2021music]. we set up the open-sourced demucs[@defossez2019demucs] to separate `bass` and `drums` tracks, a 276-layer CWS-ResUNet for the `vocals` track, and a 166-layer CWS-PResUNet for `other` track.

**Demucs** is a time domain MSS model. In our study, we adopted the open-sourced pre-trained demucs^[https://github.com/facebookresearch/demucs] and do not apply the shift trick because it will slow down the inference speed.

**CWS-PResUNet** is a ResUNet[@zhang2018road;@liu2021voicefixer] based model integrating CWS feature [@liu2020channel] and the complex ideal ratio mask (cIRM) estimation strategies described in [@kong2021decoupling]. The overall pipeline is summarized in Figure 1a. For a one dimensional mixture signal ${x} \in R^{L}$, where L stands for signal length, we first utilize pre-defined analysis filters ${h}_1$,${h}_2$,${h}_3$, and ${h}_4$ to perform subband decompositions:
$$
x_{sub} = [\text{DS}_4({x}*{h}_j)]_{j=1,2,3,4},
$$
where * stands for convolution operations and $\text{DS}_{4}(\dot)$ is the downsampling operator. Then we calcuate the short time fourier transform (STFT) of the downsampled subband signals to obtain their magnitude spectrograms $|{X}_{sub}|$. 

![The architecture of Phase-aware ResUNet](graphs/arc.png){ width=100% }

As is shown in Figure.2, the phase-aware ResUNet is a symmetric architecture containing a down-sampling and an up-sampling path with skip connections between the same level. It accepts $|{X}_{sub}|$ as input and estimates four tensors with the same shape: ratio mask $\hat{M}$, phase variation $\hat{P}_{r}$, $\hat{P}_{i}$, and direct magnitude prediction $\hat{Q}$. Then the complex spectrogram can be reconstruct with the following equation:
$$
\hat{S}_{sub} = relu(|{X}_{sub}|\cdot \hat{M}+\hat{Q})e^{j(\angle X_{sub} +\angle \hat{\theta})},
$$
in which $cos\angle \hat{\theta}=\hat{P}_{r}/(\sqrt{\hat{P}_{r}^2+\hat{P}_{i}^2})$. We use relu activation to ensure the positve magnitude value. Finally we perform inverse STFT and subband reconstruction to obtain $\hat{s}_{sub}$ and source estimation $\hat{s}$:
$$
\hat{s} = \sum_{j=1}^{4}\text{US}_4(\hat{s}_{sub})*g_j,
$$
where $g_j$ is the synthesis filter and $\text{US}_4(\dot)$ is the zero-insertion upsampling function.

As is illustrated in Figure 1b, the CWS feature can make the CNN featuremaps smaller and save computational resources. Also, CWS input makes CNN having separate weights for each subband, in which case the model becomes more efficient by diverging subband information into channels and enlarging receptive fields. Moreover, because bounded mask and mixture phase can limit the theoretical upper bound of the MSS system [@kong2021decoupling], we estimate unbounded mask and phase variations in each subband to compute the unbounded cIRM. Our `vocals` model is optimized by calcualting L1 loss between $\hat{s}$ and target source $s$. Despite we also use a model dedicated to separate `other` track, we notice estimating and optimizing four sources together can result in a 0.2 SDR gain on `other`. So, we calculate both L1 loss and energy-conservation loss across four sources to optimize our `other` model. Our CWS-PResUNet `bass` and `drums` models employ the same set up as the `other` model.

# Experiments

Models are optimized using the training part of MUSDB18HQ[@rafii2019musdb18]. We calculate short time fourier transform (STFT) of the downsampled 11.05 kHz subband signals with 512 window length and 110 window shift. We use Adam optimizer with learning-rate warmup and exponential decay. CWS-PResUNet takes approximately five days to train on a Tesla V100 GPU. During inference, we utilize a 10-second long `boxcar` windowing function with no overlapping to segment the signal. For evaluation, we report the SDR on the MUSDB18HQ test set with the open-sourced tool *museval*[@SiSEC18]. 

The following table lists the results of the baselines and our proposed system. Our CWS-PResUNets achieve an SDR of 8.92 and 5.84 on `vocals` and `other` sources, respectively, outperforming baseline system X-UMX[@x-umx-sawata2021all], D3Net[@takahashi2020d3net], and Demucs by a large margin. Regardless of the inferior performance on `vocals` and `other` tracks, demucs performs better than CWS-PResUNet on `bass` and `drums` tracks. We assume that is because time-domain models are not bottlenecked by the fixed spectrogram resolution setting in the frequency model and are more suitable on percussive and band-limited sources. The average performance of our ByteMSS system is 6.97, marking a SoTA performance on MSS. Considering the high performance of the `vocals` model, we also attemp to separate three instrumental sources from `mixture` minus `vocals`. The average score in this case remains 6.97, in which drums score increase to 6.72 but other three sources drop slightly. Future work will address the integration of time and frequency models for the compensations in both domains.

|    Models    | Vocals | Drums |  Bass | Other | Average |
|:------------:|:------:|:-----:|:-----:|:-----:|:-------:|
|     X-UMX    |  6.61  |  6.47  | 5.43  | 4.64  |  5.79  |
|     D3Net    |  7.24  |  7.01 |  5.25 |  4.53 |  6.01   |
|    Demucs    |  6.89  | **6.57**  | **6.53**  | 5.14  |  6.28   |
| CWS-PResUNet |  **8.92**  | 6.38  | 5.93  | **5.84**  |  6.77   |
|    ByteMSS   |  8.92  | 6.57  | 6.53  | 5.84  |  **6.97**   |


<!-- # Conclusion -->


# Reference