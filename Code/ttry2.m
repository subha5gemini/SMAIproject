% image pre-processing. 
M = 220; % number of train images M
N2 = 530432; % number of pixels in each image
NX = 592;
NY = 896;
% Read files m1.jpg through m250.jpg
% Files are in the current directory.

sum1 = zeros(NX,NY);
i1 = zeros(NX,NY,M);
s1 = zeros(NX,NY,M);
sc1 = zeros(N2,M);

for k = 1:M
    filename = sprintf('../MalesTrain/m%d.jpg', k);
    i1(:,:,k) = im2double(rgb2gray(imread(filename)));
    sum1 = sum1 + i1(:,:,k);
    
end
i_mean1 = sum1 / M ; 

for k = 1:M
    s1(:,:,k) = i1(:,:,k) - i_mean1 ;    
end

%for k = 1:M
%    sc1(:,k) = reshape(s1(:,:,k),[N2,1]);
    
%end

% preprocesing over, N2x1 dimension M images.
D1 = zeros(N2,M);
for l = 1:M
    D1(:,l) = (reshape(s1(:,:,l),[N2,1]))';
end
% N2 x M matrix

% now we need to find DD' eigen vectors
% but that is very large matrix and not 
% possible to mainpuate. We know inv(DD')
% = D'D . Hence eigenvalues will be same.

% the covariance matrix 

Sigma1 = D1' * D1;
[ EVec1, EVal1 ] = eig(Sigma1);

% EVec are M x M eigen vectors. Lets call
% these v_i, i is <1,2,3..,8>

% but we need the eigen values u_i for DD'.

% since D'Dv_i = s_i v_i
% multiplying both side by D
% DD' D v_i = s_i D v_i
% C (Dv_i) = s_i (Dv_i)
% hence u_i = Dv_i

% so now we have M eigen vectors 
U1 = D1 * EVec1;

% now lets summon a sample image and preprocess
% them

% image pre-processing. 

F = 150; % number of train images M
N2 = 530432; % number of pixels in each image
NX = 592;
NY = 896;
% Read files m1.jpg through m250.jpg
% Files are in the current directory.

sum2 = zeros(NX,NY);
i2 = zeros(NX,NY,F);
s2 = zeros(NX,NY,F);
sc2 = zeros(N2,F);

for k = 1:F
    filename = sprintf('../FemalesTrain/f%d.jpg', k);
    i2(:,:,k) = im2double(rgb2gray(imread(filename)));
    sum2 = sum2 + i2(:,:,k);
    
end
i_mean2 = sum2 / F ; 

for k = 1:F
    s2(:,:,k) = i2(:,:,k) - i_mean2 ;    
end

% preprocesing over, N2x1 dimension M images.
D2 = zeros(N2,F);
for l = 1:F
    D2(:,l) = (reshape(s2(:,:,l),[N2,1]))';
end
% N2 x M matrix

% now we need to find DD' eigen vectors
% but that is very large matrix and not 
% possible to mainpuate. We know inv(DD')
% = D'D . Hence eigenvalues will be same.

% the covariance matrix 

Sigma2 = D2' * D2;
[ EVec2, EVal2 ] = eig(Sigma2);

% EVec are M x M eigen vectors. Lets call
% these v_i, i is <1,2,3..,8>

% but we need the eigen values u_i for DD'.

% since D'Dv_i = s_i v_i
% multiplying both side by D
% DD' D v_i = s_i D v_i
% C (Dv_i) = s_i (Dv_i)
% hence u_i = Dv_i

% so now we have M eigen vectors 
U2 = D2 * EVec2;

% now lets summon a sample image and preprocess
% them

T = 50; % Number of test images
t2 = zeros(NX, NY, T);
ts2 = zeros(N2, T);
dist2 = zeros(1,T);

% threshold = 1.5e+17;
for l = 1:T
    
    filename = sprintf('../Test/t%d.jpg', l);
    t1(:,:,k) = im2double(rgb2gray(imread(filename)));
    t2(:,:,k) = im2double(rgb2gray(imread(filename)));

    % now lets find the distance from mean,
    
    t1(:,:,k) = t1(:,:,k) - i_mean1 ;
    ts1(:,k) = reshape( t1(:,:,k), [N2,1]);
    dist1 = (ts1(:,k)' * U1)*(ts1(:,k)' * U1)' ;
    dist1 = sqrt(dist1);

    t2(:,:,k) = t2(:,:,k) - i_mean2 ;
    ts2(:,k) = reshape( t2(:,:,k), [N2,1]);
    dist2 = (ts2(:,k)' * U2)*(ts2(:,k)' * U2)' ;
    dist2 = sqrt(dist2);
    
    if dist1<dist2 
        fprintf('The testcase %d is male\n',l);
    else
        fprintf('The testcae %d is female\n',l);
    end
   
end
