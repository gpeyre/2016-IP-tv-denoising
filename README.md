# 2016-IP-tv-denoising
Matlab code to reproduce the results of the paper

A. Chambolle, V. Duval, G. Peyré, C. Poon. [Geometric properties of solutions to the total variation denoising problem](http://arxiv.org/abs/1602.00087). Preprint Arxiv:1602.00087, 2016.

![TV denoising results](logo/logo.png)


It solve the TV denoising problem using a 4-fold finite differences discretization (this improves the isotropy with respect to a more classical foward difference scheme).

Contains:
- perform_tv_denoising.m: main function, implements Chambolle's 2004 dual projected gradient descent.
- test_denoising.m: run the denoising for various lambda, and also display the extended support.
- load_grad.m: load the 4-fold gradient and its associated divergence.
- imgs/: sample binary shape images.
- toolbox/: useful functions.

Copyright (c) 2016 Gabriel Peyre
