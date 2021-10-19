---
title: 'KUIELAB-MDX-Net'
tags:
  - separation
  - u-net
authors:
  - name: Minseok Kim^[co-first author]
    affiliation: 1
  - name: Woosung choi^[co-first author]
    orcid: 0000-0003-2638-2097
    affiliation: 2 # (Multiple affiliations must be quoted)
  - name: Jaehwa Chung
    affiliation: 3
  - name: Daewon Lee
    affiliation: 4
  - name: Soonyoung Jung^[corresponding author]
    affiliation: 1

affiliations:
 - name: Korea University
   index: 1
 - name: Queen Mary University of London
   index: 2
 - name: Korea National Open University
   index: 3
 - name: Seokyeong university
   index: 4

date: 10 August 2021
bibliography: paper.bib
arxiv-doi: 10.21105/joss.01667
---

# Summary

This paper presents KUIELAB-MDX-Net, a source separation model based on deep learning.
KUIELab-MDX-Net took second place on leaderboard A and third place on leaderboard B in the Music Demixing Challenge.

# Introduction

# Related work

## Frequency Transformation for Source Separation

<!-- from lasaft-v2 -->
A Frequency Transformation} (FT) block captures frequency patterns of the target source observed in the Time-Frequency (TF) spectrograms.
Recently proposed methods have shown that employing FT blocks in a source separation model can significantly enhance the performance.

For example, proposed an FT block called Time Distributed Fully connected layers (TDF).
%It is a series of fully connected layers.
A TDF is applied to each frame of a spectrogram-like internal feature map.
It aims to analyse frequency-to-frequency dependencies that are helpful to capture distinguishable characteristics such as the timbre of the target source.
By applying an FT block after each convolutional building block in a conventional U-Net structure, their model achieved outstanding performance of 7.98dB SDR on the singing voice separation task of the MUSDB18 benchmark.

### Visualizations

<!-- from mapping or masking -->
\caption{Weight Visualization in single-layered TIFs}
\label{fig:vis}
\end{figure}

\subsubsection{Bottleneck Layers in TIFs}
The second row in Table \ref{table:ablation} shows the SDR performance of TFC-TIF-U-Net architecture without bottleneck layers in TIFs. Its performance is slightly lower than that of the reference model. However, it is worthy to say we can reduce a large amount of the number of parameters for each TIFs: about $bf^{2}/2$ times smaller than a single-layered TIF, where $bf$ is a bottleneck factor.

Despite its low SDR, single-layered TIFs provide us insight for a better understanding of how it enhances frequency correlation features. Inspired by \cite{phasen}, we also visualized the weight matrix after training, as shown in Figure \ref{fig:vis}. Figure \ref{fig:vis} (a),(b),(c) and (d) visualize the weight matrix of the first TIFs for each model. We can observe each matrix is optimized to enhance timbre features for its own instrument by capturing distinct frequency dependencies observed along the frequency axis. Also, we can observe that each TIF still performs well in multi-scales.

## Latent Source Analysis

<!-- from lasaft-v2 -->
Humans are used to classifying a group of instruments as a single label, such as `drums'.
However, a symbolically labelled source comprises sub-components with different sonic characteristics such as `kick', `snare', and `hats.'
Recent methods introduced the concept called {latent sources} to take such sub-components into account.
We can perform fine-grained sound analysis with this approach by relaxing the hard-coded labelling over instruments.
For example, models can learn the characteristics of `kick drums', which is not human-labelled, from training data.
It should be noted that a latent source is not manually defined but automatically trained to minimise the loss function.

# KUIELAB-MDX-Net

## Overall Architecture

## Conv-TDF-U-Net

## Mixer

## Blending with Demucs

# Experimental Results


# Acknowledgements

# References
