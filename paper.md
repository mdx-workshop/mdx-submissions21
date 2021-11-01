---
title: 'Post-Processing Source Separation Output With MSG-GAN'
tags:
  - separation
  - GAN
  - Denoising
  - Post-Processor
authors:
  - name: Boaz Cogan^[co-first author] 
    affiliation: 1 # (Multiple affiliations must be quoted)
  - name: Noah Schaffer^[co-first author] # note this makes a footnote saying 'co-first author'
    affiliation: 1
  - name: Ethan Manilow
    affiliation: 1
  - name: Bryan Pardo
    affiliation: 1
affiliations:
 - name: Interactive Audio Lab, Northwestern University.
   index: 1
date: 12 November 2021
bibliography: paper.bib
arxiv-doi: 10.21105/joss.01667
---

# Abstract

Music source separation is the task of isolating individual components, or sources, in a musical mixture, e.g., isolating a singer from a full band. In general, the output of source separation systems, including recent state-of-the-art methods, exhibits two common issues: unwanted noise not present in the original source (“artifacts”), and missing content from the original source. These two issues greatly affect the perceptual quality of the output.  We propose to use an additional post-processing step applied to the output of source separation systems, designed to reduce artifacts and restore missing content to the initial source estimates. Taking inspiration from recent advances in speech processing, we use a Generative Adversarial Network (GAN) as a post-processor. We call our system the Make it Sound Good (MSG) GAN. Illustrative results on the widely-used MUSDB18 dataset show that MSG-GAN is able to reduce the presence of artifacts and restore missing frequencies from an upstream source separation system. 

## Figures
![MSG Figure](https://raw.githubusercontent.com/boazcogan/mdx-submissions21/Cogan-Schaffer-Manilow-Pardo/MSG%20Figure.jpg){ width=40% }

# References


