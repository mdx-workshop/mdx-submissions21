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
In 2021, Sony organized the Music Demixing Challenge [@mdx], an online competition
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
For instance, with a notion of frequency, it is possible to apply convolution along this axis,
while waveform methods must use layers that are fully connected with respect to its channels.
The final loss being still far from zero, there will also be artifacts in the separated audio.
Different representations will lead to different artifacts, some being more noticeable
for the drums and bass (phase inconsitency for spectrogram methods will make the attack sound hollow),
while others are more noticeable for the vocals (vocals separated by Demucs suffer from crunchy static noise)




