---
title: 'Monotimbral Ensemble Separation using Permutation Invariant Training'
tags:
  - choral separation
  - TasNet
authors:
  - name: Saurjya Sarkar # note this makes a footnote saying 'co-first author'
    affiliation: 1 # (Multiple affiliations must be quoted)
  - name: Emmanouil Benetos # note this makes a footnote saying 'co-first author'
    affiliation: 1
  - name: Mark Sandler
    affiliation: 1
affiliations:
 - name: Centre for Digital Music, Queen Mary University of London, London, UK
   index: 1
date: 28 October 2021
bibliography: paper.bib
arxiv-doi: 10.21105/joss.01667
---

# Abstract

The majority of research in Music Source Separation is focussed around the "Music De-mixing" problem of separating vocals, drums and bass from mastered songs [@cano2018musical]. We have seen that the quality of separation achievable is very directly related to the relative loudness of the target source in the input mixture. This makes separation of vocals, drums and bass feasible from pop songs as they are typically amongst the loudest components in a mastered pop song. Additionally they also have very distinctive spectro-temporal features which allow effective separation using spectrogram masking. Separating other sources from similar tracks can be challenging due to the lack of data, the low input SNR for the target instruments and the high spectral overlap with other sources. In our work we focus on the specific task of separating similar sounding sources from unmastered mixtures. We focus on unmastered tracks so that the input SNR of our target monotimbral sources is reasonable. While models trained on such mixtures may be ineffective in the typical music demixing paradigm, they have ample opportunities to be used as music production tools for recording ensembles in non-ideal conditions.

We first present our work on Vocal Harmony Separation, which is the task of separating multiple vocal tracks performed in a harmonised fashion from an a capella mixture. We utilise a time-domain neural network architecture re-purposed from speech separation [@luo2019conv] research and modify it to separate a capella mixtures at a high sampling rate [@sarkar21_interspeech]. Polyphonic vocal recordings are an inherently challenging source separation task due to the melodic structure of the vocal parts and unique timbre of its constituents. We use four-part (soprano, alto, tenor and bass) a capella recordings of Bach Chorales and Barbershop Quartets for our experiments. Unlike current deep learning based choral separation models where the training objective is to separate constituent sources based on their class [@petermann2020deep; @gover2019score], we train our model using a permutation invariant objective [@yu2017permutation]. Using this we achieve state-of-the-art results for choral music separation. 

We also present our ongoing work on separating other monotimbral ensembles like string sections. To study this problem, we introduce a novel multitrack dataset generated using the Spitfire BBC Symphony Orchestra Professional sample library and the RWC classical music dataset [@goto2002rwc]. Our dataset utilizes a more realistic data generation method than other synthesized multi-track datasets due to the ability of this plugin to incorporate various articulation methods dynamically based on the input symbolic music data and a round-robin sampling technique introducing uniqueness to each note articulation. The sample library also enables us to render the dataset with various microphone configurations on which the library was recorded in, allowing us to study various recording scenarios for the same performance in the same acoustic space. We explore the monotimbral separation task of separating any 2 string instruments (i.e. Violin, Viola, Cello, Bass) by training a DPTNet [@chen2020dual] based model in a permutation invariant fashion. 

# References


