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

In the last decade, using deep learning to solve music source separation problems has gained a lot of interests progressively. Different types of models have been proposed, and most of them can be categorized into two categories: one that uses time-frequency representation like Short-Time Fourier Transform (STFT) as input to the model, or the other one that directly operate on time domain signals. 

The choice of representations could affect the separation result. It has been shown that time-domain models tend to have better performances on percussions and bass instruments, while frequency-domain models are more capable on harmonic instruments like vocals [@defossez2019music]. We tried to mitigate this problem by blending different models together with a relatively naive approach. The resulting model, Danna-Sep^[<https://github.com/yoyololicon/danna-sep>], surpassed published state-of-the-art by a large margin in respect to Signal-to-Distortion Ratio (SDR) [@vincent2006performance]. 

# Method

The output of Danna-Sep is computed by blending three different models. The first one is X-UMX [@sawata20]. We trained it using the same loss function as the original, but modified the frequency domain loss to the following equation:

$$\mathcal{L}_{MSE}^J = \sum_{j=1}^J\sum_{t,f}|Y_j(t, f) - \hat{Y}_j(t, f)|^2$$

Also, we incorporated Multichannel Wiener Filtering (MWF)[@antoine_liutkus_2019_3269749] into our training pipeline in order to train in an end-to-end fashion. The training was done by using the official X-UMX model as initial values and continue training around 70 epochs with a batch size of 4.

The second one was originated from Demucs [@defossez2019music]. We chose the version with 48 hidden channel size as our starting point, then we replaced the decoder part of the network by four independent decoders, each of which corresponds to one source. These four decoders have the same architecture compared to the original decoder network while the hidden channel size was reduced to 24 so the total number of parameters is roughly the same. The training loss is a L1-norm between predicted waveform and source-target waveform, and it took about 10 days to train on a single RTX 3070 using mixed precision with a batch size of 16, 4 steps of gradient accumulation.

The third one is a U-Net with 6 layers for the decoder and the encoder. We use D3 Block [@Takahashi2021CVPR] for each layer and add two layers of 2D local attention [@parmar2018image] at the bottleneck. The same loss fucntion we trained on X-UMX was used with MWF being disabled. Training time took approximately 9 days with a batch size of 16 on four Tesla V100.

Finally, we multiply each source from each model with different weights, and take summation among the models as our final values. The weights for each source and the size of the models are given in the following table.

|         | Drums | Bass | Other | Vocals | Size (Mb) |
|---------|:-----:|:----:|:-----:|:------:|:---------:|
| X-UMX   | 0.2   | 0.1  | 0     | 0.2    | 136
| U-Net   | 0.2   | 0.17 | 0.5   | 0.4    | 61
| Demucs  | 0.6   | 0.73 | 0.5   | 0.4    | 733

All models were trained on the training set of musdb18-hq [@musdb18-hq] using Adam [@kingma2014adam]. 

# Separation performances

We evaluated our models in terms of SDR scores evaluated on musdb18 dataset [@musdb18] using the *museval* toolbox [@fabian_robert_stoter_2019_3376621]. One iteration of MWF was used for X-UMX and U-Net, and we didn't apply the shift trick [@defossez2019music] for our Demucs model. The results are presented in the following table compared to the original X-UMX and Demucs, which is, to author's knowledge, the only published system that has state-of-the-art performances. These baselines^[<https://zenodo.org/record/4740378/files/pretrained_xumx_musdb18HQ.pth>] were also trained on musdb18-hq for a fair comparison. As can be seen, our X-UMX gains extra 0.27 dB on average than the original X-UMX, and our Demucs scores are on par with the original Demucs even the shift trick has not been applied. These results shows the effectiveness of our training method and architecture changes to the models. Furthermore, the score of Danna-Sep even surpass Demucs by a great margin (+0.5 dB on average), which implies the importance of blending.

|         | Drums | Bass | Other | Vocals | Avg. |
|---------|:-----:|:----:|:-----:|:------:|:----:|
| X-UMX (baseline) | 6.44 | 5.54 | 4.46 | 6.54 | 5.75
| U-Net (ours) | 6.43 | 5.35 | 4.67 | 7.05 | 5.87
| X-UMX (ours) | 6.71 | 5.79 | 4.63 | 6.93 | 6.02
| Demucs (baseline) | 6.67 | 6.98 | 4.33 | 6.89 | 6.21 
| Demucs (ours) | 6.72 | 6.97 | 4.4 | 6.88 | 6.24
| Danna-Sep | 7.2 | 7.05 | 5.2 | 7.63 | 6.77


# Acknowledgements

We acknowledge contributions from Sung-Lin Yeh and Yu-Te Wu , and supports from Yin-Jyun Luo and Showmin Wang during the genesis of this project.

# References
