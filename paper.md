---
title: 'LightSAFT: Light weight Latent Source Aware Source Frequency Transform for Source Separation'
tags:
  - separation
  - u-net
authors:
  - name: Yeong-Seok Jeong^[co-first author] # note this makes a footnote saying 'co-first author'
    orcid: 0000-0003-0872-7098
    affiliation: 1 # (Multiple affiliations must be quoted)
  - name: Jinsung Kim^[co-first author] # note this makes a footnote saying 'co-first author'
    affiliation: 1
  - name: Woosung Choi
    orcid: 0000-0003-2638-2097
    affiliation: 2
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
arxiv-doi: 10.21105/joss.01667
---

# Summary

Conditioned source separations have attracted significant attention because of their flexibility, applicability and extensionality.
Their performance was usually inferior to the existing approaches such as the single source separation model.
However, a recently proposed method called LaSAFT-Net has shown that conditioned models can show comparable performance against existing single source separation models.
This paper presents Lightsaft-Net, a lightweight version of LaSAFT-Net. As a baseline, it provided a plausible SDR performance for comparison during the Music Demixing Challenge at ISMIR 2021.
This paper also enhances the existing Lightsaft-Net by replacing the  Lightsaft blocks in the encoder with TFC-TDF blocks.
Our enhanced Lightsaft-Net outperforms another baseline, demucs48-HQ.

# Introduction

Many methods were conducted for Music Source Separation task. 
They can be distinguished depending on their approach: single source separation, multi-head source separation, 
conditioned source separation.
The conditioned source separation method, which shares the parameters for each source separation, 
is the most attractive approach even though it falls short of other methods' 
performance since it shares parameter for each separation task. 
The LaSAFT-Net is representative conditioned source separation model. 

The LaSAFT-Net applies the LaSAFT blocks, capturing the latent source's frequency patterns depending on the target source's condition.
They assume that each latent source independently separates the mixture source, 
and the attention mechanism can capture the relevant latent sources on the target source's condition. 
According to their assumption, they show comparable performance in the MusDB18 benchmark. 
However, they consume lots of parameters for generating latent sources. 
It prevents the model's applicability in a restricted environment like Music Demix Challenge (MDX) in ISMIR. 
Therefore, we explore the methods to decrease the LaSAFT-Net's parameters. 

We focus on the latent source separation procedure. 
The LaSAFT-Net redundantly spends its parameters to identify each latent source.
Our model LightSAFT-Net reduce the redundant parameter via removing unnecessary weights from 
LaSAFT blocks. 
Furthermore, we find performance enhancing method that replacing LaSAFT block in the encoder with the Time-Frequency Convolution
(TFC) and Time Distributed Fully-connected networks (TDF) is more adaptive for this task.

In this paper, we explore the method for light version of LaSAFT.
Our method already present the performance as comparison at MDX in ISMIR. 
This paper's contributions are as follows:
- The LightSAFT-Net, which is available applying in poor condition, shows plausible performance in MDX. 
- The enhanced version of LightSAFT shows the better performance than demucs48-HQ which is another baseline model in MDX.


# References
