---
title: 'Hybrid Spectrogram and Waveform Source Separation'
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
both prediction. We propose a hybrid version of the Demucs architecture [@demucs]
which won the Music Demixing Challenge 2021 organized by Sony.
This architecture also comes with additional improvements, such as compressed residual branches,
local attention or singular value regularization.
Overall, a 1.5 dB improvement of the Signal-To-Distortion (SDR) was observed across all sources,
an improvement confirmed by human subjective evaluation, with an overall quality
rated at 2.83 out of 5, and absence of contamination at 3.04 (against 2.86 and 2.44
for the second ranking model submitted at the competition).


# Introduction

Work on music source separation has recently focused on the task of
separating 4 well defined instruments in a completely supervised manner:
drums, bass, vocals and other accompaniments.
Recent evaluation campaigns  [@sisec] have focused on this setting,
relying on the standard MusDB benchmark [@musdb].
In 2021, Sony organized the Music Demixing Challenge (MDX) [@mdx], an online competition
where separation models are evaluated on a completely new and hidden test set composed of
36 tracks.

The challenge featured a number of baselines to start from, which could be divided
into two categories: spectrogram or waveform based methods.
The former consists in models that are fed with the input spectrogram,
either represented by its amplitude, such as Open-Unmix [@umx] and its variant
CrossNet Open-Unmix [@xumx], or as the concatenation of its real and imaginary part
(Complex-As-Channels, CAC, following [@cac]), such as LaSAFT [@lasaft].
Similarly, the output can be either a mask on the input spectrogram, complex numbers
or complex modulation of the input spectrogram [@kong2021decoupling].

On the other hand, waveform based models such as Demucs [@demucs] are directly
fed with the raw waveform, and output the raw waveform for each of the source.
Most of those methods will perform some kind of learnt time-frequency analysis in its
first layers through convolutions, such as Demucs and Conv-TasNet [@convtasnet], although some will not rely
at all on convolutional layers, like Dual-Path RNN [@dual_path].

Theoretically, there should be no difference
between spectrogram and waveform model, in particular when considering CaC (complex as channels),
which is only a linear change of base for the input and output space.
However, this would only hold true in the limit of having an infinite amount of training data.
With a constraint dataset, such as the 100 songs of MusDB, inductive bias can play an important role.
In particular, spetrogram methods varies by more than their input and output space.
For instance, with a notion of frequency, it is possible to apply convolution along frequencies,
while waveform methods must use layers that are fully connected with respect to its channels.
The final loss being still far from zero, there will also be artifacts in the separated audio.
Different representations will lead to different artifacts, some being more noticeable
for the drums and bass (phase inconsitency for spectrogram methods will make the attack sound hollow),
while others are more noticeable for the vocals (vocals separated by Demucs suffer from crunchy static noise)

In this work, we extend the Demucs architecture to perform hybrid waveform/spectrogram
domain source separation. The original U-Net architecture is extended to provide two parallel branches:
one in the time (temporal) and one in the frequency (spectral) domain.
We add extra improvements to the base architecture, namely compressed residual branches
comprising dilated convolutions [@dilated], LSTM [@lstm] and local attention [@attention].
We present the impact of those changes as measured on the MusDB benchmark and on the MDX
hidden test set, as well as subjective evaluations.
Hybrid Demucs ranked 1st at the MDX competition when trained only on MusDB, with 7.32 dB of SDR, and 2nd when extra training
data was allowed.

# Related work

There exist a number of spectrogram based music source separation architectures.
Open-Unmix [@umx] is based on fully connected layers and a bi-LSTM. It uses multi-channel Wiener filtering
[@wiener] to reduce artifacts. While the original Open-Unmix is trained independently on each source,
a multi-target version exist [@xumx], through a shared averaged representation layer.
D3Net [@d3net] is another architecture, based on dilated convolutions connected with dense skip connections.
It is currently the most competitive spectrogram architecture, with an average SDR of 6.0 dB on MusDB.
Unlike previous methods which are based on masking,
LaSAFT [@lasaft] uses Complex-As-Channels [@cac] along with a U-Net [@unet] architecture.
It is also single-target, however its weights are shared across targets, using
a weight modulation mechanism to select a specific source.

Waveform domain source separation was first explored by [@wavenet],
as well as [@waveunet_singing] and [@waveunet] with Wave-U-Net.
However, those methods were lagging in term of quality,
almost 2 dB behind their spectrogram based competitors.
Demucs [@demucs] was built upon Wave-U-Net, using faster strided convolutions rather
than DSP based downsampling, allowing for much larger number of channels (but potentially introducing aliasing artifacts [@pons2021upsampling]), and
extra Gated Linear Unit layers [@glu] and biLSTM.
For the first time, waveform domain methods surpassed spectrogram ones when considering
the overall SDR (6.3 dB on MusDB), although its performance is still inferior
on the other and vocals sources.
Conv-Tasnet [@convtasnet], a model based on masking over a learnt time-frequency representation
using dilated convolutions, was also adapted to music source separation by [@demucs],
but suffered from more artifacts and lower SDR.

To the best of our model, no other work has studied true end-to-end hybrid source separation,
although other team in the MDX competition used model blending across domains as a simpler post-training alternative.


# Architecture

In this Section we present the structure of Hybrid Demucs, as well
as the other additions that were added to the original Demucs architecture.

## Original Demucs

The original Demucs architecture [@demucs] is a U-Net [@unet] encoder/decoder structure.
A BiLSTM [@lstm] is applied between the encoder and decoder to provide long range context.
The encoder and decoder have a symetric structure. Each encoder layer is composed
of a convolution with a kernel size of 8, stride of 4 and doubling the number of channels (except for
the first layer, which sets it to a fix value, typically 48 or 64). It is followed by a ReLU,
and a so called 1x1 convolution with Gated Linear Unit activation [@glu], i.e. a convolution
with a kernel size of 1, where the first half of the channels modulates the second half through a sigmoid.
The 1x1 convolution double the channels, and the GLU halves them, keeping them constant overall.
Symetrically, a decoder layer sums the contribution from the U-Net skip connection and the previous layer,
apply a 1x1 convolution with GLU, then a transposed convolution that halves the number of channels (except for the outermost layer),
with a kernel size of 8 and stride of 4, and a ReLU (except for the outermost layer).
There are 6 encoder layers, and 6 decoder layers, for processing 44.1 kHz audio.
In order to limit the impact of aliasing from the outermost layers, the input audio is upsampled by a factor of 2 before
entering the encoder, and downsampled by a factor of 2 when leaving the decoder.

## Hybrid Demucs

### Overall architecture

Hybrid Demucs extends the original architecture with a multi-domain analysis and prediction
capabilities.
The model is composed of a temporal branch, a spectral branch, and shared layers.
The temporal branch takes the input waveform and process like the standard Demucs.
It contains 5 layers, which are going to reduce the number of time steps by a factor of $4^5 = 1024$.
Compared with the original architecture, all ReLU activations are replaced by
Gaussian Error Linear Units (GELU) [@gelu].

The spectral branch takes the spectrogram obtained from an STFT over 4096 time steps,
with a hop length of 1024. Notice that the number of time steps immediately matches
that of the output of the encoder of the temporal branch. In order to reduce the frequency dimension,
we apply the same convolution as in the temporal branch, but along the frequency dimension.
Each layer reduces by a factor of 4 the number of frequencies, except for the 5th layer,
which reduces by a factor of 8. After being processed by the spectral encoder,
the signal has only one "frequency" left, and the same number of channels and sample rate
as the output of the temporal branch.

The temporal and spectral representations are summed before going through a shared encoder/decoder
layer which further reduces by 2 the number of time steps (using a kernel size of 4).
Its output serve both as the input of the temporal and spectral decoder.
Hybrid Demucs has a dual U-Net structure, with the temporal and spectral branches having
their respective skip connections.

The output of the spectral branch is inversed with the ISTFT, and summed with the
temporal branch output, giving the final model prediction. Due to this overall design,
the model is free to use whichever representation is most conveniant for different parts of the signal,
even within one source, and can freely share information between the two representations.
The hybrid architecture is represented on \autoref{fig:hyb}.

### Padding for easy alignment

One difficulty that arised when designing the architecture was to properly align the spectral
and temporal representations for any input length.
For an input length $L$, kernel size $K$, stride $S$ and padding on each side $P$, the output of a convolution
is of length $(L - K + 2 * P) / S + 1$. The usual choice of $P = K/2$ gives an output of size
$L / S + 1$. For the STFT, we have a single convolution with $K=4096$ and $S=1024$.
However, the extra $+1$ becomes problematic when stacking convolutions, and iterating the previous formula. Indeed, it is easy to have a mismatch between the number of time steps for the temporal and spectral representations.

In order to simplify computations, we instead pad by $P = (K - S) / 2$, giving an output of
$L / S$, so that matching the overall stride is now sufficiant to exactly match the length
of the spectral and temporal representations. We apply this padding both for the STFT,
and convolution layers in the temporal encoders.

### Frequency-wise convolutions

In the spectral encoder/decoder, we use frequency wise convolution.
Using the padding trick, we have that the number of frequency is divided by 4 with every layer.
The initial number of frequency bin is 2049, but for simplicity, we drop the highest bin, giving 2048
frequency bins. The input of the 5th layer has 8 frequency bins, which we reduce to 1 with
a convolution with a kernel size of 8 and no padding.

However, it has been noted that unlike the time axis, the distribution of musical audio signals
is not truely invariant to translation along the frequency axis. Instruments have specific
pitch range, vocals have well defined formants etc.
To account for that, [@zemb] suggest injecting an embedding of the frequency before applying
the convolution. We use the same approach, with the addition that we smooth the initial
embedding so that close frequencies have similar embeddings. We inject this embedding just before
the second spectral encoder layer.
We also investigated using specific weights for specific frequency bands in the
outermost spectral branch layers.

### Spectrogram representation

We investigated both with representing the spectrogram as complex numbers [@cac] or
as amplitude spectrograms. For this second option, we use Wiener filtering [@wiener].
We use Open-Unmix implementation of this filtering [@umx], which uses an iterative
estimation procedure. Using more iterations at evaluation time is usually optimal,
but sadly doesn't work well with the hybrid approach, as changing the spectrogram output,
without the waveform output being able to adapt, will drastically reduce the SDR.



![Hybrid Demucs architecture. The input waveform is processed
both through a temporal encoder, and first through the STFT followed by
a spectral encoder. The two representations are summed when their dimensions align.
The opposite happens in the decoder. The output spectrogram go through the ISTFT
and are summed with the waveform outputs, giving the final model output.
The $\mathrm{Z}$ prefix is used for spectral layers, and $\mathrm{T}$ prefix for the
temporal ones.](figures/hybrid.pdf){width=80%, #fig:hyb}

## Compressed residual branches

The original Demucs encoder layer is composed of a convolution with kernel size of 8 and stride of 4,
followed by a ReLU, and of a convolution with kernel size of 1 followed by a GLU.
Between those two convolutions, we introduce a novel compressed residual branch, composed
of dilated convolutions, and for the innermost layers, of a biLSTM with limited span and local attention layer.

There are two compressed residual branch per encoder layer.
Both are composed
of a convolution with a kernel size of 3, stride of 1, dilation of 1 for the first branch and 2 for the second, and times less output dimensions than the input,
followed by layer normalization [@layernorm] and a GELU activation.

For layer 4, 5 and 6 of the encoder (with the 6-th layer being shared by the
spectral and temporal branch), long range context is processed through a local
attention layer (see definition hereafter) as well as a biLSTM with 2 layers, inserted with a skip connection, and with a maximum span of 200 steps.
In practice, the input is splitted into frames of 200 time steps, with a stride of 100
time steps. Each frame is processed concurrently by the biLSTM. Then, for any
time step, the output from the frame for which it is the furthest away from the edge is kept.

Finally, and for all layers, a final convolution with a kernel size of 1
outputs twice as many channels as the input dimension of the residual branch,
followed by a GLU. This output is then summed with the original input,
after having been scaled through a LayerScale layer [@layerscale], with an initial scale of
$1\mathrm{e}{-}3$.
A complete representation of the compressed residual branches is given on \autoref{fig:residual}.


![Representation of the compressed residual branches
that are added to each encoder layer. For the 5th and 6th layer,
a BiLSTM and a local attention layer are added.](figures/residual.pdf){width=80%, #fig:residual}

### Local attention

Local attention builds on regular attention [@attention] but replaces positional embedding
by a controllable penalty term that penalizes attending to positions that are far away.
Formally, the attention weights from position $i$ to position $j$ is given by
$$
w_{i, j} = \mathrm{softmax}(Q_i^T K_j - \sum_{k=1}^4 k \beta_{i, k} |i -j|) $$
where $Q_i$ are the queries and $K_j$ are the keys. The value $\beta_{i, k}$
is obtained as the output of a linear layer, initialized so that it is initially very close to 0.
Having multiple $\beta_{i, k}$ with different weights $k$ allows the network
to efficiently reduce its receptive field without requiring $\beta_{i, k}$ to take large values. In practice, we use a sigmoid activation to derive the values $\beta_{i, k}$.


## Stabilizing training

We observed that Demucs training could be unstable, especially as we added more layers
and increased the training set size with 50 extra songs.
Loading the model just before its divergence point, we realized that the weights
for the innermost encoder and decoder layers would get very large eigen values.

A first solution is to use group normalization (with a 4 groups) just after
the non residual convolutions for the layers 5 and 6 of the encoder and the decoder. Using normalization on all layers will deteriorate
performance, but using it only on the innermost layer seems to stabilize training
without hurting performance. Interestingly, when the training is stable (in particular
when trained only on MusDB), using normalization was at best neutral with respect
to the separation score, but never improved it, and considerably slowed down
training during the first half of the epochs.
When the training was unstable, using normalization would improve the overall performance
as it allows the model to train for a larger number of epochs.

A second solution we investigated was to use singular value regularization [@spectral].
While previous work used the power method iterative procedure, we obtained better and faster
approximations of the largest singular value using a low rank SVD method [@lowranksvd].
This solution had the advantage of always improving generalization, even when
the training was already stable. Sadly, it was not sufficient on its own to
remove entirely instabilities, but only to reduce them. Another down side
was the longer training time due to the extra low rank SVD evaluation.
In the end, in order to both achieve the best performance and remove entirely
training instabilities, the two solutions were combined.



