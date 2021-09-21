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
arxiv-doi: 10.21105/joss.01667
---

# Summary

We present and release a new tool for music source separation with pre-trained models called
Danna-Sep. Danna-Sep is designed for ease of use and separation performance with a compact command-line interface. Danna-Sep is based on PyTorch[@NEURIPS2019_9015], and it incorporates:

- split music audio files into 4 stems (vocals, drums, bass, and other) as .wav files with a single command line using pre-trained
models. 
- train source separation models or fine-tune pre-trained ones with PyTorch on musdb18-hq dataset [@musdb18-hq].

The performance of the pre-trained models surpassed published state-of-the-art and won the 4th place at Music Demixing Challenge 2021 [@mitsufuji2021music] under the constraint of training solely on musdb18.

# Implementation details

The output of Danna-Sep is computed by blending three different models. The first one is X-UMX [@sawata20]. We trained it using the same loss function as the original, but modified the frequency domain loss to the following equation:

$$\mathcal{L}_{MSE}^J = \sum_{j=1}^J\sum_{t,f}|Y_j(t, f) - \hat{Y}_j(t, f)|^2$$

Also, we incorporated Multichannel Wiener Filtering (MWF)[@antoine_liutkus_2019_3269749] into our training pipeline. The training was done by using the official X-UMX model as initial values and continue training around 70 epochs with a batch size of 4.

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

We evaluated our models in terms of Signal-to-Distortion Ratio (SDR) [@vincent2006performance] scores evaluated on musdb18 dataset [@musdb18] using the *museval* toolbox [@fabian_robert_stoter_2019_3376621]. One iteration of MWF was used for X-UMX and U-Net, and we didn't use the shift trick [@defossez2019music] for our Demucs model. The results are presented in the following table compared to the original X-UMX and Demucs, which is, to author's knowledge, the only published system that has state-of-the-art performances. As can be seen, our X-UMX gains extra 0.11 dB on average than the original X-UMX, and our Demucs scores are on par with the original Demucs even the shift trick was not applied. These results shows the effectiveness of our training method and architecture changes to the models. Furthermore, the score of Danna-Sep even surpass Demucs by a great margin (+0.5 dB on average), which implies the importance of blending.

|         | Drums | Bass | Other | Vocals | Avg. |
|---------|:-----:|:----:|:-----:|:------:|:----:|
| U-Net (ours) | 6.09 | 5.25 | 4.52 | 7.08 | 5.74
| X-UMX | 6.47 | 5.43 | 4.64 | 6.61 | 5.79
| X-UMX (ours) | 6.26 | 5.73 | 4.56 | 7.04 | 5.90
| Demucs (48 channels) | - | - | - | - | 6.20
| Demucs (ours) | 6.63 | 6.9 | 4.39 | 6.97 | 6.22
| Demucs | 6.86 | 7.01 | 4.42 | 6.84 | 6.28
| Danna-Sep | 7.04 | 6.97 | 5.18 | 7.71 | 6.73

# Future Work

The choice of blending weights plays a critical role on the model performances, so we plan to emphasize it more in the future, like developinig a systematic way to come uup a set of weights given a couple of source separation models (it were set empirically for Danna-Sep). Also, since pre-trained models are stored as TorchScript which can be easily converted to ONNX format, we would like to make Danna-Sep as a standalone application without python dependency.


# Acknowledgements

We acknowledge contributions from Sung-Lin Yeh and Yu-Te Wu , and supports from Yin-Jyun Luo and Showmin Wang during the genesis of this project.

# References