---
title: 'Source Separation using a Score-based Generative Model'
tags:
  - separation
  - u-net
  - score-based generative model
  - diffusion model
authors:
  - name: Simon Rouard^[co-first author] 
    affiliation: "1, 2" 
  - name: Gaëtan Hadjeres^[co-first author] # note this makes a footnote saying 'co-first author'
    affiliation: 1
affiliations:
 - name: Sony CSL
   index: 1
 - name: CentraleSupélec and ENS Paris-Saclay 
   index: 2
date: 27 October 2021
---

# Abstract
Score-based generative models recently achieved good results for generating images or audios. The idea of these models is to estimate the gradient of noise-corrupted data log-densities (score function). Then, by iteratively denoising a sampled noise, we can obtain a new sound that is not in the original dataset. Some works showed that these generative models response well to conditioning. In this work, we apply a score-based generative model to the task of music source separation. The idea is to learn to denoise a noisy-stem with a mixture-conditioned U-Net. Then given a mixture and starting from random noise, we can denoise it with our mixture-conditioned U-Net until we obtain the stem.