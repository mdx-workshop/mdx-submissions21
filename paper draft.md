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
affiliations:
 - name: Independent Researcher
   index: 1
date: 14 September 2021
bibliography: paper.bib
arxiv-doi: 10.21105/joss.01667
---

# Summary

We present and release a new tool for music source separation with pre-trained models called
Danna-Sep. Danna-Sep is designed for ease of use and separation performance with a compact command-line interface. Danna-Sep is based on PyTorch[@], and it incorporates:

- split music audio files into 4 stems (vocals, drums, bass, and other) as .wav files with a single command line using pre-trained
models. 
- train source separation models or fine-tune pre-trained ones with PyTorch with musdb18 dataset [@].

The performance of the pre-trained models surpassed published state-of-the-art and won the 4th place at Music Demixing Challenge 2021 [@] within the constraint of training solely on musdb18. Because the pre-trained models are stored as TorchScript, the required dependencies to operate the model is in minimum, which also make it possible to port it on edge devices.

# Implementation details

# Separation performances

# Distribution

Danna-Sep is available as a standalone Python package, and also provided as a conda recipe and
self-contained Dockers which makes it usable as-is on various platforms.

# Future Work

# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"


# Acknowledgements

We acknowledge contributions from Brigitta Sipocz, Syrtis Major, and Semyeong
Oh, and support from Kathryn Johnston during the genesis of this project.

# References