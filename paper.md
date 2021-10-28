---
title: 'User-Guided One-Shot Deep Model Adaptation for Music Source Separation'
tags:
  - separation
  - one-shot 
  - user-guided
authors:
  - name: Giorgia Cantisani 
    affiliation: 1
  - name: Alexey Ozerov 
    affiliation: 2
  - name: Slim Essid
    affiliation: 1
  - name: Gaël Richard
    affiliation: 1
affiliations:
 - name: LTCI, Télécom Paris, Institut Polytechnique de Paris, France
   index: 1
 - name: InterDigital R&D France, France
   index: 2
date: 12 November 2021
bibliography: paper.bib
arxiv-doi: hal-03219350
---

# Abstract
Music source separation is the task of isolating individual instruments which are mixed in a musical piece. This task is particularly challenging, and even state-of-the-art models can hardly generalize to unseen test data with significant timbral variation compared to training. Nevertheless, prior knowledge about individual sources can be used to better adapt a generic source separation model to the observed signal. In this work, we propose to exploit a temporal segmentation provided by the user that indicates when each instrument is active to fine-tune a pre-trained deep model for source separation and adapt it to one specific mixture. This approach can be referred to as a one-shot adaptation, as it acts on the target song instance only using the side information available only at test time. Our results are promising and show that state-of-the-art source separation models have large margins of improvement, especially for instruments underrepresented in the training data.
