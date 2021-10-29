---
title: 'LightSAFT'
tags:
  - separation
  - u-net
authors:
  - name: Yeong-Seok Jeong^[co-first author] # note this makes a footnote saying 'co-first author'
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

# Abstract

Conditioned source separations have attracted significant attention because of their flexibility, applicability and extensionality.
Their performance was usually inferior to the existing approaches such as the single source separation model.
However, a recently proposed method called LaSAFT-Net has shown that conditioned models can show comparable performance against existing single source separation models.
This paper presents Lightsaft-Net, a lightweight version of LaSAFT-Net. As a baseline, 
it provided a plausible SDR performance for comparison during the Music Demixing Challenge at ISMIR 2021.
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


# Related work
## TFC-TDF block
The TFC comprises densely connected convolutional blocks, which contains convolutional neural network layer (CNN),
Batch Norm (BN) and ReLU (cite).
It extracts high-level features from the localization features of the time-frequency dimension.

Some studies apply Frequency Transformation (FT) blocks comprising fully connected layers.
(cite) paper define the TDF block, which linear-transforms each time-distributed frequency feature like convolution filter. 
This block support that the model can capture the target sound's frequency patterns from the mixture audio.
We apply the TFC-TDF blocks in the encoder of the original LaSAFT-Net to catch the conditioned source's patterns in the received mixture.

## Latent Source
The music source separation task is separating arbitrary target instruments set which are defined by human's guide.
In some cases, some instruments are grouped even though they have different characteristics.
For example, the bass drum and Hi-hat are grouped together as drums set though have different frequency patterns.
To alleivate the grouping multiple instruments as one source set, some studies adopts latent sources to relax the arbitrary grouped instrument's characteristic.
They mix the latent sources depending on the conditions for target source.
In this paper, we adopt the latent sources for source separation tasks.  


# Light-weight latent Source Attentive Frequency Transformation Network

## Latent Source Attentive Separation mechanism
The LaSAFT-Net combines the latent source features via the attention mechanism.
The query vector($Q \in \mathbb{R}^{1 \times d_{k}}$) is target source's embedding vector which has $d_{k}$ dimensions.
The key vectors($K \in \mathbb{R}^{|S_L| \times d_{k}}$) are each latent source's representative value.
The $i^{th}$ key vector($K^{th} \in \mathbb{R}^{d_{k}}$) indicates what information the $i^{th}$ latent source contain.
The query vector and key vector conduct dot product and softmax after scaled by $\sqrt{d_k}$
to take the attention scores which determine each latent source's ratio.
The multiple TDF layers generate latent source features $V \in \mathbb{R}^{T \times d_{k} \times |S_L|}$, where the $T$ is the number of frames.
The mixed latent source is taked via dot product between attention score and latent source vector like as follows:
$$Attention(Q,K,V')=softmax(QK^{T}/\sqrt{d_{k}})V'$$
while the LaSAFT generating latent sources, they apply the TDF blocks for separating latent sources($V$).

The LaSAFT apply latent sources to attentively focus the latent sources depending on the target condition and exponentialy decrease unrelated latent source. When generating latent sources, the two fully connected layers are repeatedly applied for the same reason. Furthermore, we exchange the LightSAFT block in encoder to TFC-TDF block to encourage the model performance and lighten the model size.

##  Light-weight latent Source Attentive Frequency Transformation Block
The TDF block contain two fully connected layers (Figure 1.(a)).
The first fully connected layers are separate the latent sources from mixture sources.
The second layers analyze, after concatenating the the first layer's output, the intermediate features to separate the latent source.
The redundency of the separating process disturb utilizing the model in restricted environment.
Therefore, we focus on this point, and explore the methods for lighten the model's parameters and maintain the performance.

![Figure 1. Comparison the original LaSAFT block and proposed LightSAFT block. 
The $\mathbb{x}$ is the input intermediate feature and the $\mathbb{v_i} is generated latent source.](./img/comparison_of_blocks.png)

The Figure 1 shows difference between original LaSAFT block and the proposed LightSAFT block in the latent source generating process. 
The blocks receive the intermediate feature x and gernerate the latent source V. 
We assume that the redundant separating process in original block is not efficient and not necessary. 
Since LightSAFT block has only one separating process, It alleviate the original model's complex computation process. 
From this approach, we improve the network's applicability and efficiency. 
In each block, each FC block comprises fully connected layer (FC), Batch Norm and activation function.
To validate our proposed blocks assumption(?), we check the performance in our experiment. 
The Figure 1 shows difference between original LaSAFT block and the proposed LightSAFT block in the latent source generating process. 
We assume that the redundant separating process is not efficient and necessary. 
The LightSAFT block has only one separating process in comparison with the original block. 
Each FC block comprises fully connected layer (FC), Batch Norm and activation function. To validate our assumption, we check the performance in our experiment.

## Advanced LightSAFT

The LightSAFT mechanism shows the plausible results and decreasing the number of parameter in MDX challenge.  
To more lighten the number of parameters, we change the LightSAFT blocks in encoder to TFC-TDF blocks. 
The TFC-TDF block have fewer number of parameters in comparison with LightSAFT block, 
because of it do not have to generate $|S_L|$ latent source and convolution filter has only few parameters.    
Even though the advanced network which contain TFC-TDF blocks have the fewer parameter, they show the bettor performance in MDX challenge.

# Experiments
## Model Configuration
To fairly compare the number of parameters and performance, we follow the configurations of [cite: LaSAFT]
The |S_L| is 16 and d_k is 24.
Those are same as original LaSAFT's configuration.
In this same condition, the the number of the original LaSAFT's parameters is 4.5M, while the LightSAFT has 3.8M parameters which is sufficient compression for MDX challenge.  
The advanced LightSAFT, which contains tfc-tdf blocks in encoder, has only 2M parameters.   
It less than half of the number of the original LaSAFT's parameters. 

We trained our proposed model via minimizing the mean squared error between Short-Time Fourier Transformation (STFT) of the target and the model's output.   
For data augmentation, we generated the mixtures through mixing the different track's sources.  

## Results

 We compare the performance between the original model and the proposed models in the same condition.  
The Table 1 shows the results of model's SDR score in MDX challenge. 
The original LaSAFT, which cannot separate the musics in limited time, was not reasonable for this challenge.  
On the other hand, the LightSAFT can separate the music source in limeted time, and achieve the comparable performance.
It's performance is posted as comparison of the MDX challnge.
Even though the advanced LightSAFT has fewest parameters in comparison group, it shows the best performance. 
It seems to no conditioning mechanism, which convert the latent space, in encoder inducing stationary training.

<Table....>

Normally, the conditioned source separation models which can separate all kinds sources show plausible performance compared to the single source separation model since the conditioned model learn generalized weights rather than source specific weights to separate various sources. 
In spite of performance degradation, the conditioned source separation model is more attractive because of its applicability and efficiency. 
The Table 2 shows the whether the model is conditioned or not and its performance. 
The advanced LightSAFT-Net shows comparable performance despite conditioned source separation model. 
Even the model shows the better performance than Demucs-HQ which is single source separation model and another comparison of MDX challenge.  

# Conclusion
We explore the method to reduce the number of model's parameter and maintain the performance. 
We shows that our method is reasonable for source separation task in the performance and the applicability which can be used on restricted environment like MDX challenge.  
The advanced LightSAFT-Net shows the competitive performance even though it is conditioned source separation model. 
For future work, we will study the method for improving our model performance like TFC-TDF in encoder.  
# Reference