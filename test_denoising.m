%%
% Test for TV denoinsing using a 4-fold finite differences gradient.
% Test for various regularization parameters lambda.

addpath('toolbox/');
addpath('imgs/');

% size of the image
N = 512;

if not(exist('name'))
name = 'lena';
name = 'square-tube-50';
name = 'square';
name = 'pacman';
end

rep = ['results/N' num2str(N) '/' name '/'];
if not(exist(rep))
    mkdir(rep);
end


%%
% Helpers and parameters.

dotp = @(x,y)sum(x(:).*y(:));
ampl = @(z)sqrt(sum(z.^2,3));
% saturation factor for display
rho = .05;

%%
% load the image

f = load_image(name, N);
f = rescale(sum(f,3));
f = double(f>.5);
imwrite(f, [rep 'original.png'], 'png');

%%
% Test grad and div operator. div=-grad^T

% image and its Laplacian.
[grad,div,lapl] = load_grad(N);
figure(1);
clf;
imageplot({f lapl(f)});
% check for adjointness
e = abs( dotp(grad(f),grad(f)) + dotp(div(grad(f)),f) ) / abs(dotp(grad(f),grad(f)));
fprintf('Should be 0: %.1e.\n',e);
% check for Laplacian norm, should be 16
% [L,e] = compute_operator_norm(lapl,randn(N), 20);


%%
% Result without any noise.


options.niter = 5000;

if 0
lambda = .5;
options.z0 = [];
[f1,E,z] = perform_tv_denoising(f,lambda, options);
options.z0 = z;

figure(2);
clf;
plot(E); axis tight;

u = image_saturation(f1,rho);
imwrite(u, [rep 'tv-noiseless-img.png']);
clf;
hold on;
imageplot(u);
contour(f1, linspace(min(f1(:))+.1,max(f1(:))-.1,6), 'b');
axis ij;
saveas(gcf, [rep 'tv-noiseless-ls.png'], 'png');
end

%%
% Extended support

options.niter = 3000;
lambda = .05;
options.z0 = [];
[f1,E,z] = perform_tv_denoising(f,lambda, options);
options.z0 = z;

a = ampl(z);

figure(1);
clf;
imageplot({f f1});

clf; hold on;
imageplot(double(abs(a-1)<.01));
contour(f, [.5 .5], 'b');
axis ij;
saveas(gcf, [rep 'extended-support.png'], 'png');
imwrite(rescale(a), [rep 'z-amplitude.png']);

clf; hold on; 
imageplot(a);
colormap gray(256);
%contour(f, [1 1]*.5, 'b:');
contour(a, [1 1]*.99, 'b'); 
caxis([0 1]); 
saveas(gcf, [rep 'extended-support.png']);
saveas(gcf, [rep 'extended-support.eps'], 'epsc');

%%
% Results with noise.

sigma = .2;
randn('state', 1234);
y = f+randn(N)*sigma;
u = image_saturation(y,rho);
imwrite(u, [rep 'noisy-img.png']);


q = 10; % number of tests
% for N=256, [.1,.17]
lambda_list = linspace(.1,.17,q); % 
% for N=512, [.1,.17]
lambda_list = linspace(.1,.17,q); %
options.niter = 3000;

for i=1:length(lambda_list)
    lambda = lambda_list(i);
    [f1,E,z] = perform_tv_denoising(y,lambda, options);
    options.z0 = z;
    u = image_saturation(f1,rho);
    imwrite(u, [rep 'tv-noisy-' num2str(i) '-img.png']);
    clf;
    hold on;
    imageplot(u);
    contour(f1, linspace(min(f1(:))+.1,max(f1(:))-.1,100), 'b');
    % contour(f1, linspace(-rho,1+rho,100), 'b');
    axis ij;
    saveas(gcf, [rep 'tv-noisy-' num2str(i) '-ls.png'], 'png');
end
