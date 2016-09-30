    % image pre-processing. 

M = 150; % number of male train images M
F = 150; % number of female train images F
X = M + F;
N2 = 530432; % number of pixels in each image
NX = 592;
NY = 896;
% Read files m1.jpg through m250.jpg
% Files are in the current directory.

sum = zeros(NX,NY);
i = zeros(NX,NY,X);
s = zeros(NX,NY,X);
sc = zeros(N2,M);

for k = 1:M
    filename = sprintf('../MalesTrain/m%d.jpg', k);
    i(:,:,k) = im2double(rgb2gray(imread(filename)));
    sum = sum + i(:,:,k);
    
end

for k = 1:F
    filename = sprintf('../FemalesTrain/f%d.jpg', k);
    i(:,:,M+k) = im2double(rgb2gray(imread(filename)));
    sum = sum + i(:,:,M+k);
    
end

i_mean = sum / X ;
imshow(i_mean);
%pause;

for k = 1:M
    s(:,:,k) = i(:,:,k) - i_mean ;    
end

for k = 1:M
    sc(:,k) = reshape(s(:,:,k),[N2,1]);
    
end

% preprocesing over, N2x1 dimension M images.
D = zeros(N2,M);
for l = 1:M
    D(:,l) = (reshape(s(:,:,l),[N2,1]))';
end
% N2 x M matrix

% now we need to find DD' eigen vectors
% but that is very large matrix and not 
% possible to mainpuate. We know inv(DD')
% = D'D . Hence eigenvalues will be same.

% the covariance matrix 

Sigma = D' * D;
[ EVec, EVal ] = eig(Sigma);

% EVec are M x M eigen vectors. Lets call
% these v_i, i is <1,2,3..,8>

% but we need the eigen values u_i for DD'.

% since D'Dv_i = s_i v_i
% multiplying both side by D
% DD' D v_i = s_i D v_i
% C (Dv_i) = s_i (Dv_i)
% hence u_i = Dv_i

% so now we have M eigen vectors 
U = D * EVec;

% now lets summon a sample image and preprocess
% them

T = 50; % Number of test images
t = zeros(NX, NY, T);
ts = zeros(N2, T);
dist = zeros(1,T);

threshold = 5.5e+9;
for l = 1:T
    filename = sprintf('../Test/t%d.jpg', l);
    t(:,:,T) = im2double(rgb2gray(imread(filename)));
    
    % now lets find the distance from mean,
    
    t(:,:,T) = t(:,:,T) - i_mean ;
    ts(:,T) = reshape( t(:,:,T), [N2,1]);
    dist = (ts(:,T)' * U)*(ts(:,T)' * U)' ;
%     dist = sqrt(dist);
    
    if dist <= threshold 
%         g = sprintf('%d',l);
        fprintf('test case %d %d is male\n',l,dist);
    else
%         g = sprintf('%d',l);
        fprintf('test case %d %d is female\n',l,dist);    
    end
end
