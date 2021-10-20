---
title: 'Learning source-aware representations of music on a discrete latent space'
tags:
  - separation
  - vq-vae
authors:
  - name: Jinsung Kim^[co-first author]
    affiliation: 1
  - name: Yeong-Seok Jeong^[co-first author]
    affiliation: 1
  - name: Woosung choi
    orcid: 0000-0003-2638-2097
    affiliation: 2 # (Multiple affiliations must be quoted)
  - name: Jaehwa Chung
    affiliation: 3
  - name: Soonyoung Jung^[corresponding author]
    affiliation: 1

affiliations:
 - name: Korea University
   index: 1
 - name: Queen Mary University of London
   index: 2
 - name: Korea National Open University
   index: 3
date: 10 August 2021
bibliography: paper.bib
arxiv-doi: 
---

# Abstract

Since humans have an auditory cortex, we can decompose individual sources by capturing the unique acoustic characteristics of them.
Within the same perspective, we claim that the representation of music can be decomposed into the representation of the sources.
In this paper, we propose a novel method to learn a decomposed latent representation of music through Vector-Quantized Variational Auto-Encoder (VQ-VAE).
We train our VQ-VAE to encode an input mixture into a tensor of integers in a discrete latent space. 
We designed the discrete latent space to have a decomposed structure which allows us to manipulate the encoded latent vector adaptive to human perception.
We claim that it can be adopted for various applications.
To verify this idea, we show that we can generate bass lines by estimating the sequential distribution of our model.

# Introduction
Music is a protean art, combining distinctive individual sources (e.g., vocal, instrumental sounds) in such a way to produce a creative single audio signal.
Humans have a unique auditory cortex, allowing proficiency at hearing sounds, and sensitiveness in frequencies.
For this reason, humans can differentiate individual sources by capturing the unique acoustic characteristics (e.g., timbre and tessitura) of them, even though what they hear is a mixture of sources.
Moreover, experts or highly skilled composers are able to produce sheet music for different instruments.
Meanwhile, trained orchestras or band can reproduce the original music by playing the transcribed scores.
However, if the unskilled transcriber who writes the sheet music lacks the ability to distinguish between different music sources, no matter how good the performers are, they cannot recreate the original music.
This procedure resembles the encoder-decoder concept, widely used in the machine learning field; a transcriber is an encoder, and an orchestra/band is a decoder.
Motivated by this analogy, this paper proposes a method that aims to learn source-aware decomposed audio representations for the given music.
To the best of our knowledge, numerous methods have been proposed for audio representation, yet no existing works have learned decomposed music representations.
For Automatic Speech Recognition, \cite{baevski2020wav2vec,sadhu2021wav2vec} are proposed using Transformer\cite{vaswani2017attention}-based models to predict quantized latent vectors.
From this approach, they trained their models to understand linguistic information in human utterance.
\cite{ericsson2020adversarial,mun2020sound} learn voice style representations for human voice information. 
They applied learned representations for speech separation and its enhancement. 
Several studies have applied contrastive learning, used in representation learning\cite{niizumi2021byol,wang2021multi} for computer vision.

However, the goal of this paper is different from the above audio representation researches.
We aim to learn decomposed representations through instruments' categories.
In this work, we train a model through source separation for learning decomposed representations.
In section \ref{sec:exp}, we show that we can easily manipulate latent representations for various applications such as source separation and music synthesis.
Source Separation tasks have been studied both in music source separation and on speech enhancement tasks. 
Within the generating perspective, they can be categorized into two groups. 
The first group attempts to generate masks multiplying with the input audio through this preserving target source \cite{chien2017variational,jansson2017orcid}.
The second group aims to directly estimate a raw audio or spectrogram \cite{kameoka2019supervised, 9053513, choi2020lasaft}.
We adopt the latter method to obtain more various applicable tasks.
It can generate audio samples directly when we have a prior distribution of representation.
Many studies have proposed methods based on Variational Auto-Encoder (VAE)\cite{kameoka2019supervised} or U-Net \cite{choi2020lasaft,9053513,yuan2019skip} for source separation.
The U-Net-based models usually show high performance in the source separation task.
However, some studies have pointed out the fundamental limitation of U-Nets; the skip connections used in U-Nets may lead to weakening the expressive power of encoded representations \cite{yuan2019skip}.
Therefore, we choose a VAE-based model to extract meaningful representation from the input audio.


# Proposed Methods

# Model

# Experiment

# Conclusion

# Acknowledgements

# References
