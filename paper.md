---
title: 'LightSAFT: Light weight Latent Source Aware Source Frequency Transform for Source Separation'
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
They can be distinguished depending on their approach: single source separation[@jansson:2017, @choi:2019, @defossez:2019], multi-head source
separation[@sawata:2021], conditioned source separation[@choi:2021].
The conditioned source separation method, which shares the parameters for each source separation, 
is the most attractive approach even though it falls short of other methods' 
performance since it shares parameter for each separation task. 
The LaSAFT-Net [@choi:2021] is representative conditioned source separation model. 

The LaSAFT-Net applies the LaSAFT blocks, capturing the latent source's frequency patterns depending on the target source's condition.
They assume that each latent source independently separates the mixture source, 
and the attention mechanism can capture the relevant latent sources on the target source's condition. 
According to their assumption, they show comparable performance in the MusDB18 [@rafii:2017] benchmark. 
However, they consume lots of parameters for generating latent sources. 
It prevents the model's applicability in a restricted environment like Music Demix Challenge (MDX) in ISMIR [@mitsufuji:2021]. 
Therefore, we explore the methods to decrease the LaSAFT-Net's parameters. 

We focus on the latent source separation procedure. 
The LaSAFT-Net redundantly spends its parameters to identify each latent source.
Our model LightSAFT-Net reduce the redundant parameter via removing unnecessary weights from 
LaSAFT blocks. 
Furthermore, we find performance enhancing method that replacing LaSAFT block in the encoder with the Time-Frequency Convolution
(TFC) and Time Distributed Fully-connected networks (TDF) [@choi:2019] is more adaptive for this task.

In this paper, we explore the method for light version of LaSAFT.
Our method already present the performance as comparison at MDX in ISMIR. 
This paper's contributions are as follows:

- The LightSAFT-Net, which is available applying in poor condition, shows plausible performance in MDX. 

- The enhanced version of LightSAFT shows the better performance than demucs48-HQ which is another baseline model in MDX.


# Related work
## TFC-TDF block
The TFC comprises densely connected convolutional blocks, which contains convolutional neural network layer (CNN),
Batch Norm (BN) and ReLU [@choi:2019].
It extracts high-level features from the localization features of the time-frequency dimension.

Some studies [@yin:2020, @choi:2020, @choi:2021] apply Frequency Transformation (FT) blocks comprising fully connected layers.
@choi:2019 defines the TDF block, which linear-transforms each time-distributed frequency feature like convolution filter. 
This block support that the model can capture the target sound's frequency patterns from the mixture audio.
We apply the TFC-TDF blocks in the encoder of the original LaSAFT-Net to catch the conditioned source's patterns in the received mixture.

## Latent Source
The music source separation task is separating arbitrary target instruments set which are defined by human's guide.
In some cases, some instruments are grouped even though they have different characteristics.
For example, the bass drum and Hi-hat are grouped together as drums set though have different frequency patterns.
To alleivate the grouping multiple instruments as one source set, some studies adopts latent sources, 
which decompose the mixture's representation in latent space [@choi:2020], to relax the arbitrary grouped instrument's characteristic.
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
The mixed latent source is taken via dot product between attention score and latent source vector like as follows:
$$Attention(Q,K,V')=softmax(QK^{T}/\sqrt{d_{k}})V'$$
while the LaSAFT generates latent sources, they apply the TDF blocks to separate latent sources($V$).
The LaSAFT apply latent sources to attentively focus the latent sources depending on the target condition and exponentially decrease unrelated latent source. 

##  Light-weight latent Source Attentive Frequency Transformation Block
The TDF block contains two fully connected layers (Figure 1.(a)).
The first fully connected layers are separate the latent sources from mixture sources.
After concatenating the first layer's output, the second layers analyse the intermediate features to separate the latent source.
The redundancy of the separating process disturbs utilising the model in the restricted environment.
Therefore, we focus on this point and explore the methods for lightening the model's parameters and maintaining the performance.

![Figure 1. Comparison the original LaSAFT block and proposed LightSAFT block. 
The $\mathbb{x}$ is the input intermediate feature and the $\mathbb{v_i} is generated latent source.](./img/comparison_of_blocks.png)

Figure 1 shows the difference between the original LaSAFT block and the proposed LightSAFT block in the latent source generating process. 
The blocks receive the intermediate feature x and generate the latent source V. 
We assume that the redundant separating process in the original block is not efficient and not necessary. 
Since the LightSAFT block has only one separating process, It alleviates the original model's complex computation process. 
From this approach, we improve the network's applicability and efficiency. 
Each FC block comprises a fully connected layer (FC), Batch Norm, and activation function in each block.
To validate our proposed blocks assumption, we check the performance in our experiment. 
Figure 1 shows the difference between the original LaSAFT block and the proposed LightSAFT block in the latent source generating process. 
We assume that the redundant separating process is not efficient and necessary. 
The LightSAFT block has only one separating process in comparison with the original block. 
To validate our assumption, we check the performance in our experiment.


## Advanced LightSAFT

The LightSAFT mechanism shows plausible results and decreases the number of parameters in the MDX challenge.  
To more lighten the number of parameters, we change the LightSAFT blocks in the encoder to TFC-TDF blocks. 
The TFC-TDF block has fewer parameters than the LightSAFT block because it does not have to generate $|S_L|$ latent source,
and the convolution filter has only a few parameters.    
Even though the advanced network which contains TFC-TDF blocks have fewer parameters, they show the bettor performance in the MDX challenge.


# Experiments
## Model Configuration
To fairly compare the number of parameters and performance, we follow the configurations of @choi:2020.
The $|S_L|$ is 16 and $d_k$ is 24.
Those are the same as the original LaSAFT's configuration.
In this same condition, the original LaSAFT's parameters are 4.5M, while the LightSAFT has 3.8M parameters sufficient compression for the MDX challenge.  
The advanced LightSAFT, which contains the TFC-TDF blocks in the encoder, has only 2M parameters.   
It is less than half of the number of the original LaSAFT's parameters. 


We trained our proposed model by minimizing the mean squared error between the target's short-Time Fourier Transformation (STFT)
and the model's output.   
For data augmentation, we generated the mixtures by mixing the different track's sources.  

## Results

 We compare the performance between the original model and the proposed models in the same condition.  
Table 1 shows the results of the model's SDR [@vincent:2006] score in the MDX challenge. 
The original LaSAFT, which cannot separate the songs in a limited time, was not reasonable for this challenge.  
On the other hand, the LightSAFT can separate the music source in a limited time and achieve comparable performance.
Its performance is posted as a comparison of the MDX challenge.
Even though the advanced LightSAFT has the fewest parameters in the comparison group, it shows the best performance. 
It seems to have no conditioning mechanism, which converts the latent space in encoder inducing stationary training.

<table>
<tr><td>

|model| # of parameters | vocals | drums | bass | other | Avg |
|--|--|--|--|--|--|--|
|LaSAFT [@choi:2020]|4.5M|-|-|-|-|-|
|LightSAFT|3.8M|6.685|5.272|5.498|4.121|5.394|
|Advanced <br>LightSAFT|2M|7.275|5.935|5.823|4.557|5.897|

</td><td>

| model | type | vocals | drums | bass | other | Avg |
|--|--|--|--|--|--|--|
|Demucs48-HQ [@defossez:2019]| Single | 6.496 | 6.509 | 6.470 | 4.018 | 5.873 |
|XUMX [@sawata:2021]| multi-head | 6.341 | 5.615 | 5.807 | 3.722 | 5.372 |
|UMX [@stoter:2019]| Single | 5.042 | 5.357 | 5.504 | 3.309 | 5.042 |
|LightSAFT|conditioned|6.685|5.272|5.498|4.121|5.394|
|Advanced <br>LightSAFT|conditioned|7.275|5.935|5.823|4.557|5.897|
  
<tr><th>Table 1. A comparison with original LaSAFT </th><th>Table 2. A comparison with other source separation models</th></tr>
</td></tr> </table>

Usually, the conditioned source separation models, which can separate all kinds of sources, show plausible performance compared to the single source separation model since the conditioned model learn generalized weights rather than source-specific weights to separate various sources. 
Despite performance degradation, the conditioned source separation model is more attractive because of its applicability and efficiency. 
Table 2 shows whether the model is conditioned or not and its performance. 
The advanced LightSAFT-Net shows comparable performance despite the conditioned source separation model. 
Even the model shows a better performance than Demucs-HQ, a single-source separation model and another comparison of the MDX challenge.  

# Conclusion
We explore the method to reduce the number of the model's parameters and maintain the performance. 
We show that our method is reasonable for source separation tasks in the performance and the applicability, which can be used in a restricted environment like the MDX challenge.  
The advanced LightSAFT-Net shows the competitive performance even though it is a conditioned source separation model. 
For future work, we will study the method for improving our model performance, like TFC-TDF in the encoder.  
# Reference
