---
title: 'Feature-informed Latent Space Regularization for Music Source Separation'
tags:
  - separation
  - X-UMX
  - VGGish
authors:
  - name: Yun-Ning Hung
    affiliation: 1 # (Multiple affiliations must be quoted)
  - name: Alexander Lerch
    affiliation: 1
affiliations:
 - name: Center for Music Technology, Georgia Institute of Technology, USA
   index: 1
date: 15 October 2021
bibliography: paper.bib
arxiv-doi: 
---

# Abstract

The integration of additional side information to improve music source separation has been investigated numerous times, e.g., by adding features to the input or by adding learning targets in a multi-task learning scenario. These approaches, however, require additional annotations such as musical scores, instrument labels, etc. in training and possibly during inference. The available datasets for source separation do not usually provide these additional annotations. In this work, we explore self-supervised learning strategies utilizing VGGish features for latent space regularization; these features are known to be a very condensed representation of audio content and have been successfully used in many MIR tasks. We introduce three approaches to incorporate the features with a state-of-the-art source separation model, and investigate their impact on the separation result.


