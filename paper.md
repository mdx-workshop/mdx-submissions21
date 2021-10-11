---
title: 'Hybrid Spectrogram Waveform Music Source Separation'
tags:
  - separation
  - u-net
authors:
  - name: Alexandre Défossez
    affiliation: 1
affiliations:
 - name: Facebook AI Research
   index: 1
date: 8 October 2021
bibliography: paper.bib
---

# Abstract

Source separation models either work on the spectrogram or waveform domain.
In this work, we show how to perform end-to-end hybrid source separation,
letting the model decide which domain is best suited for each source, and even combining
both prediction. We propose a hybrid version of the Demucs architecture [@defossez2019music]
which won the Music Demixing Challenge 2021 organized by Sony.
This architecture also comes with additional improvements, such as compressed residual branches,
local attention or singular value regularization.
Overall, a 1.5 dB improvement of the Signal-To-Distortion (SDR) was observed across all sources,
an improvement confirmed by human subjective evaluation, with an overall quality
rated at 2.83 out of 5, and absence of contamination at 3.04 (against 2.86 and 2.44
for the second ranking model submitted at the competition).


# Introduction

Work on music source separation has recently focused on the task of
separating 4 well defined instruments in a completely supervised manner:
drums, bass, vocals and other accompaniments.
Recent evaluation campaigns  [@sisec] have focused on this setting,
relying on the standard MusDB benchmark [@musdb].
In 2021, Sony organized the Music Demixing Challenge (MDX) [@mdx], an online competition
where separation models are evaluated on a completely new and hidden test set composed of
36 tracks.

The challenge featured a number of baselines to start from, which could be divided
into two categories: spectrogram or waveform based methods.
The former consists in models that are fed with the input spectrogram,
either represented by its amplitude, such as Open-Unmix [@umx] and its variant
CrossNet Open-Unmix [@xumx], or as the concatenation of its real and imaginary part
(Complex-As-Channels, CAC, following [@choi_2020]), such as LaSAFT [@lasaft].
Similarly, the output can be either a mask on the input spectrogram, complex numbers
or complex modulation of the input spectrogram [@kong2021decoupling].

On the other hand, waveform based models such as Demucs [@demucs] are directly
fed with the raw waveform, and output the raw waveform for each of the source.
Most of those methods will perform some kind of learnt time-frequency analysis in its
first layers through convolutions, such as Demucs and Conv-TasNet [@convtasnet], although some will not rely
at all on convolutional layers, like Dual-Path RNN [@dual_path].

Theoretically, there should be no difference
between spectrogram and waveform model, in particular when considering CaC (complex as channels),
which is only a linear change of base for the input and output space.
However, this would only hold true in the limit of having an infinite amount of training data.
With a constraint dataset, such as the 100 songs of MusDB, inductive bias can play an important role.
In particular, spetrogram methods varies by more than their input and output space.
For instance, with a notion of frequency, it is possible to apply convolution along frequencies,
while waveform methods must use layers that are fully connected with respect to its channels.
The final loss being still far from zero, there will also be artifacts in the separated audio.
Different representations will lead to different artifacts, some being more noticeable
for the drums and bass (phase inconsitency for spectrogram methods will make the attack sound hollow),
while others are more noticeable for the vocals (vocals separated by Demucs suffer from crunchy static noise)

In this work, we extend the Demucs architecture to perform hybrid waveform/spectrogram
domain source separation. The original U-Net architecture is extended to provide two parallel branches:
one in the time (temporal) and one in the frequency (spectral) domain.
We add extra improvements to the base architecture, namely compressed residual branches
comprising dilated convolutions [@dilated], LSTM [@lstm] and local attention [@attention].
We present the impact of those changes as measured on the MusDB benchmark and on the MDX
hidden test set, as well as subjective evaluations.
Hybrid Demucs ranked 1st at the MDX competition when trained only on MusDB, with 7.32 dB of SDR, and 2nd when extra training
data was allowed.

# Related work

There exist a number of spectrogram based music source separation architectures.
Open-Unmix [umx] is based on fully connected layers and a bi-LSTM. It uses multi-channel Wiener filtering
[@wiener] to reduce artifacts. While the original Open-Unmix is trained independently on each source,
a multi-target version exist [@xumx], through a shared averaged representation layer.
D3Net [@d3net] is another architecture, based on dilated convolutions connected with dense skip connections.
It is currently the most competitive spectrogram architecture, with an average SDR of 6.0 dB on MusDB.
Unlike previous methods which are based on masking,
LaSAFT [@lasaft] uses Complex-As-Channels [@cac] along with a U-Net [@unet] architecture.
It is also single-target, however its weights are shared across targets, using
a weight modulation mechanism to select a specific source.

Waveform domain source separation was first explored by [@wavenet],
as well as [@waveunet_singing] and [@waveunet] with Wave-U-Net.
However, those methods were lagging in term of quality,
almost 2 dB behind their spectrogram based competitors.
Demucs [@demucs] was built upon Wave-U-Net, using faster strided convolutions rather
than DSP based downsampling, allowing for much larger number of channels, and
extra Gated Linear Unit layers [@glu] and biLSTM.
For the first time, waveform domain methods surpassed spectrogram ones when considering
the overall SDR (6.3 dB on MusDB), although its performance is still inferior
on the other and vocals sources.
Conv-Tasnet [@convtasnet], a model based on masking over a learnt time-frequency representation
using dilated convolutions, was also adapted to music source separation by [@demucs],
but suffered from more artifacts and lower SDR.

To the best of our model, no other work has studied true end-to-end hybrid source separation,
although other team in the MDX competition used model blending across domains as a simpler post-training alternative.


# Architecture

