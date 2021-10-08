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
Overall, a 1.5dB improvement of the Signal-To-Distortion (SDR) was observed across all sources,
an improvement confirmed by human subjective evaluation, with an overall quality
rated at 2.83 out of 5, and absence of contamination at 3.04 (against 2.86 and 2.44
for the second ranking model submitted at the competition).


# Introduction

## Long talks

Long talks will use time slots of approximately 30', where the presenter will be free to
either present some recent research or an overview of a topic that may be of interest
to the music demixing community. You are free to present some work that was already
published recently on arxiv, but this work shouldn't have been presented to a public
conference already.

The architecture of the paper for this category is classical and should be self contained.
The length should be around 2 pages, excluding references, but we do accept longer papers.
The point is: there should be enough information for the committee to decide whether it
makes sense to give you the mic for half an hour !

## Ideas / Discussions

Submission from this category should include two sections:
* A _Motivations_ section would give some context and would explain why having participants
  discussing this particular topic is relevant.
* A _Questions_ section provides a list of the actual questionns / points that you want to
  raise. There should be at least around 5 of them.

Pleas note that you tacitely agree to chair to discussion if you submit in this category.

The expected length for submissions in this category is around one page, excluding references.
It would be nice to have some illustration if applicable.


# Example of content fitting the template

## Introduction

`Gala` is an Astropy-affiliated Python package for galactic dynamics. Python
enables wrapping low-level languages (e.g., C) for speed without losing
flexibility or ease-of-use in the user-interface. The API for `Gala` was
designed to provide a class-based and user-friendly interface to fast (C or
Cython-optimized) implementations of common operations such as gravitational
potential and force evaluation, orbit integration, dynamical transformations,
and chaos indicators for nonlinear dynamics. `Gala` also relies heavily on and
interfaces well with the implementations of physical units and astronomical
coordinate systems in the `Astropy` package [@astropy] (`astropy.units` and
`astropy.coordinates`).

`Gala` was designed to be used by both astronomical researchers and by
students in courses on gravitational dynamics or astronomy. It has already been
used in a number of scientific publications [@Pearson:2017] and has also been
used in graduate courses on Galactic dynamics to, e.g., provide interactive
visualizations of textbook material [@Binney:2008]. The combination of speed,
design, and support for Astropy functionality in `Gala` will enable exciting
scientific explorations of forthcoming data releases from the *Gaia* mission
[@gaia] by students and experts alike.

## Mathematics

Single dollars ($) are required for inline mathematics e.g. $f(x) = e^{\pi/x}$

Double dollars make self-standing equations:

$$\Theta(x) = \left\{\begin{array}{l}
0\textrm{ if } x < 0\cr
1\textrm{ else}
\end{array}\right.$$

You can also use plain \LaTeX for equations
\begin{equation}\label{eq:fourier}
\hat f(\omega) = \int_{-\infty}^{\infty} f(x) e^{i\omega x} dx
\end{equation}
and refer to \autoref{eq:fourier} from text.

## Figures

Figures can be included like this:

![Caption for example figure.](https://raw.githubusercontent.com/mdx-workshop/mdx-workshop.github.io/master/banner.jpg){ width=40% }

and referenced from text using \autoref{fig:example}.

## Acknowledgements

We acknowledge contributions from Brigitta Sipocz, Syrtis Major, and Semyeong
Oh, and support from Kathryn Johnston during the genesis of this project.

# References
All submissions should include a reference section.

## How to cite

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"
