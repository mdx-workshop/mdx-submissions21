---
title: 'Music Demixing with the sliCQ Transform'
tags:
  - separation
  - cqt
  - time-frequency
authors:
  - name: Sevag Hanssian
    affiliation: "1"
affiliations:
 - name: McGill University
   index: 1
date: 19 September 2021
bibliography: paper.bib
---

# Abstract

Music source separation, or music demixing, is the task of decomposing a song into its constituent sources, which are typically isolated instruments (e.g., drums, bass, vocals). The Music Demixing Challenge^[<https://www.aicrowd.com/challenges/music-demixing-challenge-ismir-2021>] [@mdx21] was created to inspire new demixing research. Open-Unmix [UMX\; @umx], and the improved variant CrossNet-Open-Unmix [X-UMX\; @xumx], were included in the challenge as the baselines. Both models use the Short-Time Fourier Transform (STFT) as the representation of music signals.

@gabor1946's time-frequency uncertainty principle states that the STFT of a signal cannot be maximally precise in both time and frequency. The tradeoff of time-frequency resolution can significantly affect music demixing results [@tftradeoff1]. Our proposed adaptation of Open-Unmix replaced the STFT with the sliCQT [@slicq], a time-frequency transform with varying time-frequency resolution. The resulting model, xumx-sliCQ^[<https://github.com/sevagh/xumx-sliCQ>] [@xumxslicq], was 5x smaller than UMX, but achieved lower demixing scores.

# Background

The STFT is computed by applying the Discrete Fourier Transform on fixed-size windows of the input signal. From both auditory and musical motivations, variable-size windows are preferred, with long windows in low frequency regions to capture detailed harmonic information with a high frequency resolution, and short windows in high frequency regions to capture transients with a high time resolution [@doerflerphd]. The sliCQ Transform [sliCQT\; @slicq] is a realtime variant of the Nonstationary Gabor Transform [NSGT\; @balazs]. These are time-frequency transforms with complex Fourier coefficients and perfect inverses that use varying windows to achieve nonlinear time or frequency resolution. An example application of the NSGT/sliCQT is an invertible Constant-Q Transform [CQT\; @jbrown].

# Methodology

In music demixing, the oracle estimator represents the theoretical upper limit of performance of a given strategy using ground truth signals. In Open-Unmix, the phase of the STFT is discarded, and the estimated magnitude STFT of the target is combined with the phase of the mix for the first estimate of the waveform. This is sometimes referred to as the "noisy phase" [@noisyphase1; @noisyphase2], described by \autoref{eq:noisyphaseoracle}.
\begin{equation}\label{eq:noisyphaseoracle}
\hat{X}_{\text{target}}(j\omega) = |X_{\text{target}}(j\omega)| \cdot \measuredangle{X_{\text{mix}}(j\omega)}
\end{equation}

The sliCQT parameters were chosen by maximizing the median SDR across all 4 targets from the noisy-phase waveforms in a 60-iteration random grid search on the validation set of MUDB18-HQ [@musdb18hq]. The sliCQT parameters of 262 frequency bins on the Bark scale in 32.9-22050 Hz achieved 7.42 dB, which surpassed the 6.23 dB of the STFT using the Open-Unmix default window and overlap of 4096 and 1024 respectively.

\autoref{fig:spectrograms} shows the magnitude STFT and sliCQT spectrograms of a glockenspiel signal.^[<https://github.com/ltfat/ltfat/blob/master/signals/gspi.wav>]

![Spectrograms of the musical glockenspiel signal.\label{fig:spectrograms}](https://raw.githubusercontent.com/sevagh/mdx-submissions21/HANSSIAN/static-assets/spectrograms_comparison.png){ width=100% }

The STFT outputs a single time-frequency matrix where all of the frequency bins are spaced uniformly apart and have the same time resolution. The sliCQT by contrast groups the frequency bins, which may be nonuniformly spaced, in a ragged list of time-frequency matrices, where each matrix contains frequency bins that share the same time resolution. In xumx-sliCQ, convolutional layers adapted from an STFT-based vocal separation model [@plumbley2] were applied separately to each time-frequency matrix, shown in \autoref{fig:ragged}.

![Example of convolutional layers applied to a ragged sliCQT.\label{fig:ragged}](https://raw.githubusercontent.com/sevagh/mdx-submissions21/HANSSIAN/static-assets/xumx_slicq_pertarget.png){ width=100% }

# Results

xumx-sliCQ was evaluated on the test set of MUSDB18-HQ and compared with the pretrained models of UMX and X-UMX. xumx-sliCQ achieved a median SDR of **3.6 dB**, versus the **4.64 dB** of UMX and **5.54 dB** of X-UMX. xumx-sliCQ's inference was 2x slower than UMX, and the size of the trained model on disk was 5x smaller. The overall system architecture of xumx-sliCQ remains similar to UMX/X-UMX, as shown in \autoref{fig:blockdiagram}.

![xumx-sliCQ overall system diagram.\label{fig:blockdiagram}](https://raw.githubusercontent.com/sevagh/mdx-submissions21/HANSSIAN/static-assets/xumx_overall_arch.png){ width=100% }

\newpage

# Acknowledgements

Thanks to my colleagues Néstor Nápoles López and Timothy Raja de Reuse, and to my master's thesis supervisor Prof. Ichiro Fujinaga, for help throughout the creation of xumx-sliCQ.

# References
