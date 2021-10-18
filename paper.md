---
title: 'Upsampling Artifacts in Music Source Separation'
tags:
  - separation
  - artifacts
authors:
  - name: Jordi Pons
    affiliation: 1
  - name: Santiago Pascual
    affiliation: 1
  - name: Giulio Cengarle
    affiliation: 1
  - name: Joan Serrà
    affiliation: 1
affiliations:
 - name: Dolby Laboratories
   index: 1
date: 9 February 2021
arxiv-doi: https://arxiv.org/abs/2010.14356
---

# Abstract

A number of recent advances in neural audio synthesis rely on upsampling layers, which can introduce undesired artifacts. In computer vision, upsampling artifacts have been studied and are known as checkerboard artifacts (due to their characteristic visual pattern). However, their effect has been overlooked so far in audio processing. Here, we address this gap by studying this problem from the audio signal processing perspective. We first show that the main sources of upsampling artifacts are: (i) the tonal and filtering artifacts introduced by problematic upsampling operators, and (ii) the spectral replicas that emerge while upsampling. We then compare different upsampling layers, showing that nearest neighbor upsamplers can be an alternative to the problematic (but state-of-the-art) transposed and subpixel convolutions which are prone to introduce tonal artifacts.
