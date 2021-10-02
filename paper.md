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

Deep learning-based music source separation has gained a lot of interest in the last decades. Existing models mainly operate on spectrograms or waveforms. Spectrogram-based models learn suitable masks for separating magnitude spectrogram into different sources while waveform-based models directly generate the waveforms for different sources. Each type has its own strengths and weaknesses. For example, spectrogram-based models are more capable on harmonic instruments such as vocals; waveform-based models tend to perform better on percussion and bass instruments. We tried to mitigate the weaknesses by blending different models together in a relatively naive way. We improved upon original X-UMX (spectrogram-based) and Demucs (waveform-based) by tweaking the training parameters and model architectures. In addition, we developed an U-Net model to emphasize the masking approach of spectrograms. Finally, we combined the outputs from different models together with different weights as our resulting model, and named it as Danna-Sep^[<https://github.com/yoyololicon/danna-sep>]. Danna-Sep surpassed published state-of-the-art models by a large margin in terms of SDR scores. However, due to its huge size and heavy computations, it takes longer to train and infer when comparing to other models. We leave this as our future work to reduce the model size or improve the training and inferring speed.

# Method

Danna-Sep is a combination of three different models: X-UMX, Demucs, and U-Net. In the following sub-sections, the modifications made in each model will be discussed.

## X-UMX
X-UMX [@sawata20] is an improved version of UMX[@stoter19] in which it concatenates different hidden layers of UMX to share information among all target instruments. We trained it using the same time domain loss as the original X-UMX, but modified the frequency domain loss such that:

$$\mathcal{L}_{MSE}^J = \sum_{j=1}^J\sum_{t,f}|Y_j(t, f) - \hat{Y}_j(t, f)|^2$$,

where $j$ denotes the jth source, $Y(t, f)$ and $\hat{Y}(t, f)$ are the time-frequency presentations of estimation and ground truth respectively. The difference is that we calculated the Euclidean norm in complex numbers instead of taking norm on the absolute value as in the original X-UMX. Also, we incorporated Multichannel Wiener Filtering (MWF)[@antoine_liutkus_2019_3269749] into our training pipeline in order to train our model in an end-to-end fashion. We initialized our X-UMX with the official pre-trained X-UMX weights^[<https://zenodo.org/record/4740378/files/pretrained_xumx_musdb18HQ.pth>] and continue training for around 70 epochs with a batch size of 4.

## Demucs
For Demucs [@defossez2019music], we chose the version with 48 hidden channels as our starting point. Then we replaced the decoder part of the network with four independent decoders, each corresponds to one source. These four decoders have the same architecture as the original decoder network while the hidden channel size was reduced to 24 so the total number of parameters is roughly the same. The training loss is a L1-norm between predicted waveforms and source-target waveforms, and it took around 10 days to train on a single RTX 3070 using mixed precision with a batch size of 16, and 4 steps of gradient accumulation.

## U-Net
The encoder and decoder of our U-Net consist of six D3 Blocks [@Takahashi2021CVPR] and we added two layers of 2D local attention [@parmar2018image] layers at the bottleneck. We used the same loss function as X-UMX during training but with MWF being disabled. It took approximately 9 days to train with a batch size of 16 on four Tesla V100 GPUs. We also experimented with using biaxial biLSTM along the time and frequency axes as the bottleneck layers. But it takes slightly longer to train, yet does not offer any significant improvements.

## Danna-Sep
Finally, we calculated the weighted average of the outputs obtained from the models mentioned above as our final output. Experiments are conducted to search for optimal weighting. The optimal weights for each source, input domain type (T for waveforms, TF for frequency masking), and the size of the models are given in the following table.

|         | Drums | Bass | Other | Vocals | Input Domain | Size (Mb) |
|---------|:-----:|:----:|:-----:|:------:|:------------:|:---------:|
| X-UMX   | 0.2   | 0.1  | 0     | 0.2    | TF | 136
| U-Net   | 0.2   | 0.17 | 0.5   | 0.4    | TF | 61
| Demucs  | 0.6   | 0.73 | 0.5   | 0.4    | T | 733

All models were trained on the training set of musdb18-hq [@musdb18-hq] using an Adam optmizier[@kingma2014adam]. 

# Separation performances
We evaluated our models in terms of Signal-to-Distortion Ratio (SDR) [@vincent2006performance] on musdb18 [@musdb18] using the *museval* toolbox [@fabian_robert_stoter_2019_3376621]. One iteration of MWF was used for X-UMX and U-Net, and we didn't apply the shift trick [@defossez2019music] for our Demucs model. The results of our models and the original X-UMX and Demucs are shown in the table below.

|         | Drums | Bass | Other | Vocals | Avg. |
|---------|:-----:|:----:|:-----:|:------:|:----:|
| X-UMX (baseline) | 6.44 | 5.54 | 4.46 | 6.54 | 5.75
| U-Net (ours) | 6.43 | 5.35 | 4.67 | 7.05 | 5.87
| X-UMX (ours) | 6.71 | 5.79 | 4.63 | 6.93 | 6.02
| Demucs (baseline) | 6.67 | 6.98 | 4.33 | 6.89 | 6.21 
| Demucs (ours) | 6.72 | 6.97 | 4.4 | 6.88 | 6.24
| Danna-Sep | **7.2** | **7.05** | **5.2** | **7.63** | **6.77**

As can be seen from the table our modified X-UMX gained an extra 0.27 dB on average SDR compared to the original X-UMX while our modified Demucs still gained an extra 0.03 dB on average SDR compared to the original Demucs despite the fact that the shift trick has not been applied. To ensure a fair comparison, the all models reported in this table are trained on musdb18-hq. To the best of our knowledge, Demucs is currently the state-of-the-art demixing model. Yet, our Danna-Sep still surpasses Demucs by a great margin (+0.53 dB on average SDR). These results show the effectiveness of our training method and architecture change and the importance of model blending.




# Acknowledgements

We acknowledge contributions from Sung-Lin Yeh and Yu-Te Wu , and supports from Yin-Jyun Luo and Showmin Wang during the genesis of this project.

# References
