---
title: "Transfer Learning with Jukebox for Music Source Separation"
tags:
  - Audio signal processing
  - Neural networks
  - Transfer learning
  - Jukebox
authors:
  - name: Wadhah Zai El Amri^[corresponding author] # note this makes a footnote saying 'co-first author'
    orcid: 0000-0002-0238-4437
    affiliation: 1 # (Multiple affiliations must be quoted)
  - name: Oliver Tautz # note this makes a footnote saying 'co-first author'
    affiliation: 1
  - name: Helge Ritter
    affiliation: 1
  - name: Andrew Melnik
    affiliation: 1
affiliations:
  - name: University of Bielefeld
    index: 1
date: 26 October 2021
bibliography: paper.bib
arxiv-doi:
---

# Abstract

In this paper, we demonstrate a neural network architecture that uses representations of a publicly available pretrained _Jukebox_ model and transfer learning to solve the problem of audio source separation. Jukebox takes 3 days of training on 256 GPUs. In this work, we demonstrate how to adapt Jukebox's audio representations for the problem of extraction of an audio source from a single mixed audio channel. Results demonstrate competitive performance to the other state-of-the-art approaches. Our approach is fast to train. We provide an open-source code implementation of our architecture.

# Introduction

Music source separation from mixed audio is a challenging problem, especially if the source itself should be learned from a dataset of examples. Additionally, such models are expensive to train from scratch. We tested our model on the MUSDB18-HQ [@MUSDB18HQ] dataset which supplies full songs with groundtruth stems of: bass, drums, vocals and other, which includes instruments such as guitars, synths etc. The task is to separate a mixed audio channel into the separately recorded instruments, called stems here. Most baseline models in the Music Demixing Challenge 2021 [@mitsufuji2021music] used masking of input transformed to frequency domain by short-time Fourier transformation. _Demucs_ [@DBLP:journals/corr/abs-1909-01174] showed a successful approach that works in waveform domain. _Demucs_ is an autoencoder, based on a bidirectional long short-term memory network, with an architecture inspired by generative approaches. This encouraged us to adapt _Jukebox_ [@dhariwal2020jukebox], a powerful, generative model using multiple, deep Vector Quantized-Variational Autoencoders (VQ-VAE) [@DBLP:journals/corr/abs-1711-00937] to automatically generate real sounding music, and using its publicly available pretrained weights for the task.

# Related Works

Transfer learning helped deep learning models reach new heights in many domains, such as natural language processing [@DBLP:journals/corr/abs-1810-04805],[@DBLP:journals/corr/abs-1910-10683] and computer vision [@HAN201843],[@https://doi.org/10.1111/mice.12363]. Although relatively unexplored for the audio domain, [@7472128] proved feature representation learned on speech data could be used to classify sound events. Their results verify that cross-acoustic transfer learning performs significantly better than a baseline trained from scratch. TRILL [@Shor_2020] showed great results of pre-training deep learning models with an unsupervised task on a big dataset of speech samples. Its learned representations exceeded SOTA performance on a number of downstream tasks with datasets of limited size.

We take a similar approach that is heavily based on _Jukebox_ [@dhariwal2020jukebox]. It uses multiple VQ-VAEs to compress raw audio into discrete codes. They are trained self-supervised, on a large dataset of about 1.2 million songs, needing the compute power of 256 V100 to train in acceptable time. Our experiments show that _Jukebox's_ learned representations can be used for the task of source separation.

# Method

## Architecture

Our architecture utilizes _Jukebox's_ [@dhariwal2020jukebox] the standard variant of the publicly available pre-trained VQ-VAE model. _Jukebox's_ uses three separated VQ-VAEs. We use only the smallest one with the strongest compression. It employs dilated 1-D convolutions in multiple residual blocks to find a less complex sequence representation of music. An audio sequence $x_t$ gets mapped by an encoder $E_1$ to a latent space $e_t=E_1(x_t)$ of 64 dimensions so that it can be mapped to the closest prototype vector in a collection $C$ of vectors called _codebook_. These 2048 prototype vectors, denoted $c_{st}$, are learned in training and help to form a high-quality representation.

The rate of compression for a sequence is called the hop length, for which a value of 8 is used. It depends on the stride values of the convolutional layers. We set the stride value to 2 as well as the down sampling to 3. All other values remain as defined in [@dhariwal2020jukebox]. After mapping to the codebook, a decoder $D$ aims to reconstruct the original sequence. In summary, equation (\autoref{eq:1})

\begin{equation}
\label{eq:1}
y_t=D(argmin(\|E_1(x_t)- c)\|) \;\; \text{for} \;\; c \in C
\end{equation}

describes a full forward pass through the VQ-VAE, where $ y_t $ is the prediction for an input sequence $x_t$ and $\|.\|$ is the euclidean norm. For further technical details on the used VQ-VAE architecture, refer to the paper of Dhariwal et al. [@dhariwal2020jukebox]. The model is fine-tuned on data for one stem, learning good representations for a single instrument. In addition, we train a second encoder $E_2$, identical to the one already mentioned, to project an input sequence of the mixture to the space already known by the codebook and decoder. For deployment, the encoder of the VQ-VAE is switched with the second one, effectively mapping from the full mixture to one stem.

## Data

Our models are trained on the MUSDB18-HQ [@musdb18-hq] dataset, also used in the music demixing challenge [@mitsufuji2021music]. It consists of 150 full-length songs, sampled at 44KHz, providing the full audio mixture and four stems, vocals, bass, drums and other for each sample, which can be regarded as ground truth in the context of source separation. We train on the full train set composed of 100 songs, testing is done on the remaining 50.

## Training

![Visualization of the proposed transfer learning model architecture.](https://github.com/wzaielamri/mdx-submissions21/blob/ZaiElAmri-Tautz-Ritter-Melnik/Figure.jpg){ width=30% }

One model is trained per stem (see Fig.\autoref{fig:Figure}), furthermore, each is trained in two stages. In stage one, we train the adapted VQ-VAE (our Model 1) to produce good latent representations of a single stem specifically. _Jukebox's_ provided weights are fine-tuned with a self-supervised learning task on the data for one stem with the same three losses, $L = L_{recons} + L_{codebook} + \beta L_{commit}$ used by [@dhariwal2020jukebox] so that the auto-encoder learns how to compress a single stem and reconstruct it.

For stage two, the second encoder is trained on the mix to learn the same encoding as the already trained encoder in the VQ-VAE. So for each training sample ($x_mt$: the sequence of the mixed audio, $x_st$: the sequence of stem audio), we feed $x_st$, to the already trained encoder $E_1$, producing $e_{st}$. Separately, the full mixture $x_mt$ is passed through the new encoder $E_2$, yielding $e_{mt}$. Now, we can backpropagate through $E_2$ using MSE loss $||e_{st}-e_{mt}||^2$. To clarify, we should mention that the weights of $E_1$ are not updated in stage 2. For deployment, we use the VQ-VAE trained in stage 1, but swap in the encoder trained in stage 2. On a more technical note, in both training stages and deployment, the data is processed chunk wise, with a size of about 9 seconds. For a clear overview of the content of this chapter refer to Figure \autoref{fig:Figure}.

For all conducted experiments that will be defined in the next section, two Tesla GPUs with 16Gb each are used. The length of each input sequence is equal to 393216 data points as used by _Jukebox_. The batch size is equal to 4.

To benchmark the conducted experiments, signal-to-distortion ratio (SDR) metric is used, which is a common metric in other SOTA papers[@DBLP:journals/corr/abs-1909-01174][@stoeter2019][@Hennequin2020][@sawata2021all][@stoller2018waveunet].
'Total' SDR is the mean SDR for all stems.

# Experiments and Results

The main key point of this paper consists of proving that it is possible to get decent audio quality by using transfer learning. For this, we did two different experiments on the four audio stems. We trained the first VQ-VAE networks for each audio stem from scratch without using any pretraining values. Then, we trained in a second experiment, the VQ-VAE with pretrained weights of the _Jukebox_. For all these VQ-VAE we pick the checkpoint 80K and train the corresponding encoder of the second model. For all the second models (experiment 1 and 2) we initialized randomly the weights, when starting the training.

For the first experiment, we found out that all the results are low, and no good audio quality is reached. The SDR values are equal or near 0 for all the four stems.

For the second experiment, the model converges after 32 hours of training in total on two Tesla GPU units with 16GB of VRAM each.

We present the results in the following figure \ref{fig:fig_1}, corresponding each to the SDR results of the second experiment for the four audio stems.

![SDR results of the 4 audio signal stems for the second experiment.](https://github.com/wzaielamri/mdx-submissions21/blob/ZaiElAmri-Tautz-Ritter-Melnik/fig_1.jpg){ width=40% }

In Figure \ref{fig:fig_1} demonstrates decent SDR values for networks trained with a pretraining weights in comparison to others trained with random initialized weights from scratch. It is also to be deduced that it is even enough to train until early checkpoint values, such as 20K, in order to get fairly good SDR values. Then, the checkpoint 20K is reached after 16 hours for each of the two models on two Tesla GPUs.
Table (1) gives a comparison of different approaches for audio signal separation. Our approach achieves here comparable results, when benchmarked with other state-of-the-art networks.

![Table 1: SDR values for different approaches for the four stems.](https://github.com/wzaielamri/mdx-submissions21/blob/ZaiElAmri-Tautz-Ritter-Melnik/res_1.png){ width=100% }

# Conclusion

Transfer learning is used in modern architectures for image processing, neural language processing, etc. In this work we demonstrate how to use transfer learning for the problem of audio signal processing and in particular in demixing audio signal from a single mixed audio channel into four different stems: drums, bass, vocals and rest. We show that it is possible to succeed in such tasks with a small-sized dataset and this is achieved, when using pretrained weights from _Jukebox_ [@dhariwal2020jukebox] network.
