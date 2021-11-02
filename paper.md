---
title: 'Learning source-aware representations of music in a discrete latent space'
tags:
  - separation
  - vq-vae
authors:
  - name: Jinsung Kim^[co-first author]
    affiliation: 1
  - name: Yeong-Seok Jeong^[co-first author]
    affiliation: 1
  - name: Woosung Choi
    orcid: 0000-0003-2638-2097
    affiliation: 2 # (Multiple affiliations must be quoted)
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
arxiv-doi:
---

# Abstract

In recent years, neural network based methods have been able to convert music representations into a single vector, but they are inadequate for humans to analyze or manipulate.
To address this issue, we propose a novel method to learn source-aware latent representations of music through Vector-Quantized Variational Auto-Encoder(VQ-VAE).
We train our VQ-VAE to encode an input mixture into a tensor of integers in a discrete latent space, and design them to have a decomposed structure which allows humans to manipulate the latent vector in a source-aware manner.
We claim that it can be adopted for various applications.
To verify this idea, we show that we can generate bass lines by estimating the sequential distribution of our model.

# Introduction
Humans have a unique auditory cortex, allowing proficiency at hearing sounds, and sensitiveness in frequencies.
For this reason, humans can differentiate individual sources in an audio signal by capturing acoustic characteristics unique to each source (e.g., timbre and tessitura).
Moreover, experts or highly skilled composers are able to produce sheet music for different instruments, just by listening to the mixed audio signal.
Meanwhile, trained orchestras or bands can reproduce the original music by playing the transcribed scores.
However, if an unskilled transcriber lacks the ability to distinguish different music sources, no matter how good the performers are, they cannot recreate the original music.
This procedure resembles the encoder-decoder concept, widely used in the machine learning field; the transcriber is an encoder, and the orchestra/band is a decoder.
Motivated by this analogy, this paper proposes a method that aims to learn source-aware decomposed audio representations for a given music signal.
To the best of our knowledge, numerous methods have been proposed for audio representation, yet no existing works have learned decomposed music representations.

# Related work

For Automatic Speech Recognition, [@baevski2020wav2vec,@sadhu2021wav2vec] used Transformer [@vaswani2017attention]-based models to predict quantized latent vectors.
From this approach, they trained their models to understand linguistic information in human utterance.
[@ericsson2020adversarial,@mun2020sound] learn voice style representations from human voice information.
They applied learned representations for speech separation and its enhancement.
Several studies have applied contrastive learning, used in representation learning@[niizumi2021byol, @wang2021multi] for computer vision.

However, the goal of this paper is different from the above audio representation researches.
We aim to learn decomposed representations through instruments' categories.
In this work, we train a model through source separation to learn decomposed representations.
In section "Experiment" , we show that we can easily manipulate latent representations for various applications such as source separation and music synthesis.
Source Separation tasks have been studied both in music source separation and on speech enhancement tasks.
Within the generating perspective, they can be categorized into two groups.
The first group attempts to generate masks that is multiplied with the input audio to acquire the target source [@chien2017variational, @jansson2017orcid].
The second group aims to directly estimate a raw audio or spectrogram [@kameoka2019supervised, @9053513, @choi2020lasaft].
We adopt the latter method to obtain more various applicable tasks.
This method can generate audio samples directly when we have a prior distribution of representation.
Many studies have proposed methods based on Variational Auto-Encoder (VAE)[@kameoka2019supervised] or U-Net [@choi2020lasaft, @9053513, @yuan2019skip] for source separation.
The U-Net-based models usually show high performance in the source separation task.
However, some studies have pointed out the fundamental limitation of U-Nets; the skip connections used in U-Nets may lead to weakening the expressive power of encoded representations [@yuan2019skip].
Therefore, we choose a VAE-based model to extract meaningful representation from the input audio.

# Proposed Methods

When a mixture audio is given, we aim to learn quantized representations that can be decomposed into $n$ vectors, where $n$ denotes the number of sources.
We denote the given source set as $S=\{s_i\}_{i=1}^n$, where $s_i \in S$ is the $i^{th}$ source. We formulate the mixture audio $\mathcal{M}(S)$ as follows:
$$ \mathcal{M}(S) = \sum_{i}^{n} s_i$$

In the following section, we describe our method for learning decomposed latent representations.
Figure 1 describes the overall idea of the proposed model.

![Illustration of the proposed method.](figs/Figure2.png){width=100%}

## Latent Quantization
We quantize latent vectors by adopting the vector quantization method proposed in [@oord2017neural].
In this original VQ-VAE [@oord2017neural], straight-through estimation was used, but instead we adopted Gumbel softmax estimation [@jang2016categorical] where the softmax is done over all encoder outputs z. 
$$ y_{i,j} = \frac{\exp((z_{i,j} + g_j) / \tau ) }{\sum_{k}^{m}\exp((z_{i,k} + g_k)/\tau) }$$
while $\tau$ is a non-negative temperature, $g$ are categorical distribution from $n= -log(-log(u))$, and $u$ are uniform samples from uniform distribution $\mathcal{U}(0,1)$.

During training, Gumbel softmax estimation stochastically maps the representation of the encoder output to the discrete latents. In other words, $q_i$ is a weighted sum of all discrete latents.
This way it is easier to compute the gradients and can simply implement the reparameterization trick that approximates the categorical distributions. 
However, during inference we deterministically choose one discrete latent in the codebook.

$$ q_i =\begin{cases}
   [e_1, e_2, ... e_m] \otimes y_i &\quad \text{if train step} \\
   e^*                   &\quad \text{if inference step}
\end{cases}$$
where $q_i$ is the quantized representation of the $i$-th source, $e$ are the discrete latents in the codebook, $z$ is the output of encoder, and $e^*=e_{\operatorname{argmax}(y_i)}$.

## Multi-latent Quantization
One limitation of the latent quantization approach is the restricted expressive power compared to continuous latent space approaches.
To increase the number of source representations, we could have simply increased the number of elements in a codebook.
Instead, we use a more memory-efficient way to increase expressive power. We use multiple codebooks and construct each $q_i$ with a combination of quantized vectors $(e^*){(h)} (h \in [1,H])$, where h is the codebook index.

$$ q_i=[(e^*)^{(1)}, ..., (e^*)^{(H)}]$$ 

Through this approach, the number of available source representations increases exponentially with the total number of codebooks.

## Task definition

When the input mixture $\mathcal{M}(S)$ is given, we want to obtain decomposed and quantized representations ${q_i}^{n}_{i=1}$.
We assume that each decomposed representation vector $q_{i}$ can fully represent each $s_i$.

If we select some representations from $[q_1, ..., q_n]$, they also have to represent $s_i$ that are chosen.
For example, if we select $q_1$, $q_2$ and $q_4$, those are the representation of $\mathcal{M}(\{s_1, s_2, s_4\})$.
We apply this \textit{seletive source reconstruction task} to our model, where we aim to minimize the \textit{selective reconstruction loss}.
The selective source reconstruction loss can be formulated, as follows:

$$ \mathcal{L}_{select} = {\| \mathcal{M}(S')  - \hat{\mathcal{M}}' \|}_1^1$$ 
where $\hat{\mathcal{M}}'$ is estimated audio through decoder network from selected representation.

When calculating the gradients through the selective latent reconstruction loss, there is no gradient for unselected representations.
This lack of gradients is inefficient to train the model.
To prevent this problem, we train our model with the \textit{complement source reconstruction task}, where we aim to minimize the \textit{complement loss}.
The complement loss $\mathcal{L}_{compl}$ is defined as follows:
$$ \mathcal{L}_{compl} = {\| \mathcal{M}(S'')  - \hat{\mathcal{M}}''\|}_1^1$$
where $\hat{\mathcal{M}}''$ is estimated audio through decoder network from unselected representation.

We also conduct the STFT loss as auxiliary loss defined as follows:
$$\mathcal{L}_{STFT} =
\| \operatorname{STFT}(\mathcal{M}) - \operatorname{STFT}(\hat{\mathcal{M}}) \|_1^1$$
We apply it to both $\mathcal{L}_{select}$ and $\mathcal{L}_{compl}$.

# Experiment
## Dataset
We use the MUSDB18 dataset [@rafii2017musdb18]. It contains a total of 150 tracks. We divided the training set into 86 tracks for training, 14 tracks for validation.
In MUSDB18, each track has a sampling rate of 44100 and each mixture has four stereo sources(vocal, bass drum, and other instruments).

## Training Setting
Given an input audio, we trained models to predict the target audio, following the selective source condition.
The input mixture audio is a summation of randomly selected sources from different tracks, and the target sources are randomly selected from the input mixture's sources.
When computing the STFT loss, We set the number of FFTs to 2048, and hop length to 512.
We trained models using the Adam optimizer [@kingma2014adam] and set the learning rate to 0.0001.

## Results
To validate our method, we visualize the result of decomposed representations using t-SNE [@van2008visualizing].
After training with the MUSDB18 training dataset, we obtained decomposed representations of single-source tracks in the MUSDB18 test dataset.
Then we apply t-SNE to the set of representations as shown in Figure 2.
In Figure 2, each color means different sources and the dots are the decomposed representations.
It can be examined that the latent vectors from the same sources tend to be clustered even though there is no constraint about the classification.
It indicates that our method has learned source-aware representations.

![tSNE visualization of quantized vectors in multi-codebook(left) and bass generation result(right)](figs/Figure3.png){width=100%}

To better understand that the vector quantization method affects to model's performance, we train a VAE and an Auto-Encoder with the same training framework and almost the same structure to produce representations of the same size.
As a result, they reconstruct only the noise sound instead of the mixtures with their representation vectors.
We also conduct an experiment using methods without the STFT and complement loss, introduced in Section "Proposed Methods" to compare the effects of them.
To this end, we first separate sources from mixtures in the  MUSDB18 test dataset using each model.
Then, we measure Source-to-Distortion Ratio (SDR) @[vincent2006performance], following Musdb18 benchmark to evaluate each models.

<table>

|            | vocals |  bass  | drums | other | Avg   |
|:----------:|:------:|:------:|:-----:|:-----:|-------|
|  proposed  |  1.270 |  1.761 | 1.403 | 0.812 | 1.311 |
|  w/o STFT  |  1.546 |  1.026 | 1.480 | 1.069 | 1.280 |
| w/o comple |  0.996 | -0.031 | 1.458 | 0.576 | 0.749 |

</table>

# Conclusion
This paper explores learning decomposed representations for musical signals.
We propose novel training methods (i.e., selective source reconstruction and complementary source reconstruction) and a VQ-VAE-based model.
To validate our approaches, we visualize the latent representation through the t-SNE algorithm and perform two experiments.
The visualized representation shows that the latent representations of sources are decomposed into different spaces.
The bass generation task shows that the decoder can generate bass lines via new prior.
We consider that our model can be used in other music processing tasks.
For example, our model, which represents discrete representations of input audio, can be adopted in music compression tasks.
In addition, the characteristics of the model generating decomposed audio representation for each source is appropriate for the music sheet transcription task.
We plan to design a decoder that can generate high-quality audio. This can be applied to real-world audio in future work. This methodology can generate a decomposed representation of the various sounds of the real world. As a result, it can be implemented to various tasks such as audio generation and audio event detection, and localization.

# Acknowledgements
This research was supported by Basic Science Research Program through the National Research Foundation of Korea(NRF) funded by the Ministry of Education(NRF-2021R1A6A3A03046770).
This work was also supported by the National Research Foundation of Korea(NRF) grant funded by the Korea government(MSIT)(No. NRF-2020R1A2C1012624, NRF-2021R1A2C2011452).

# References
