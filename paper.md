---
title: 'Deep learning for automatic mixing: challenges and next steps'
tags:
  - automatic mixing
  - deep learning
authors:
  - name: Christian J. Steinmetz
    affiliation: 1
affiliations:
 - name: Centre for Digital Music, Queen Mary University of London
   index: 1
date: 28 October 2021
bibliography: paper.bib
arxiv-doi: 10.21105/joss.01667
---

# Abstract
The process of transforming a set of audio recordings into a cohesive mixture for film, radio, or music production encompasses a number of artistic and technical considerations. 
Due to the inherent complexity in this task, a great deal of training and expertise on the part of the audio engineer is generally required. 
This has motivated the design of automated or assistive systems for the audio production process that aid both amateur and expert users [@moffat2019approaches]. 
While classical machine learning approaches and expert systems have been investigated, they often fail to generalize to the diversity and scale of real-world projects, with the inability to adapt to a varying number of sources, capture stylistic elements across genres, or apply sophisticated processing [@deman2017tenyears]. 
Recently, deep learning approaches have shown promise in addressing these limitations and bring the potential to model the complex mixing process directly from data [@steinmetz2020msc; @steinmetz2021automatic; @martinez2021deep]. 
However, automatic mixing poses a number of unique challenges for deep learning approaches including very low tolerance of artifacts, high sample rates, need for interpretability and controllability, along with limited multitrack data. 
This talk will provide an overview of the field of automatic mixing and outline recent developments in deep learning approaches, with a focus on potential directions for advancement. 
This overview will include ideas on how source separation may play a role in advancing automatic mixing, such as data generation [@ward2017estimating] and audio manipulation [@choi2021amss], along with tasks like audio effect removal [@gorlow2014restoring]. 