% image pre-processing. 
% each image is 256x256.

i1 = double(rgb2gray(imread('1.jpg')));
i2 = double(rgb2gray(imread('2.jpg')));
i3 = double(rgb2gray(imread('3.jpg')));
i4 = double(rgb2gray(imread('4.jpg')));
i5 = double(rgb2gray(imread('5.jpg')));
i6 = double(rgb2gray(imread('6.jpg')));
i7 = double(rgb2gray(imread('7.jpg')));
i8 = double(rgb2gray(imread('8.jpg')));

i_mean = (i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8)/8;


s1 = i1 - i_mean;
s2 = i2 - i_mean;
s3 = i3 - i_mean;
s4 = i4 - i_mean;
s5 = i5 - i_mean;
s6 = i6 - i_mean;
s7 = i7 - i_mean;
s8 = i8 - i_mean;

s1c = reshape( s1, [530432,1]);
s2c = reshape( s2, [530432,1]);
s3c = reshape( s3, [530432,1]);
s4c = reshape( s4, [530432,1]);
s5c = reshape( s5, [530432,1]);
s6c = reshape( s6, [530432,1]);
s7c = reshape( s7, [530432,1]);
s8c = reshape( s8, [530432,1]);

% preprocesing over, 530432x1 dmension 8 images.


D = [s1c ,s2c ,s3c ,s4c ,s5c ,s6c ,s7c ,s8c];
% 530432 x 8 matrix

% now we need to find DD' eigen vectors
% but that is very large matrix and not 
% possible to mainpuate. We know inv(DD')
% = D'D . Hence eigenvalues will be same.

% the covariance matrix 
Sigma = D' * D;

% now, the eigen vectors and eigen values 
% are

[ EVec, EVal ] = eig(Sigma);

% EVec are 8 x 8 eigen vectors. Lets call
% these v_i, i is <1,2,3..,8>

% but we need the eigen values u_i for DD'.

% since D'Dv_i = s_i v_i
% multiplying both side by D
% DD' D v_i = s_i D v_i
% C (Dv_i) = s_i (Dv_i)
% hence u_i = Dv_i

% so now we have 8 eigen vectors 
 U = D * EVec;

% now lets summon a sample image and preprocess
% them
t1 = double(rgb2gray(imread('9.jpg')));
t2 = double(rgb2gray(imread('10.jpg')));
t3 = double(rgb2gray(imread('11.jpg')));
t4 = double(rgb2gray(imread('12.jpg')));
t5 = double(rgb2gray(imread('13.jpg')));
t6 = double(rgb2gray(imread('14.jpg')));


% now lets find the distance from mean,

% males test
ts1 = t1 - i_mean;
ts2 = t2 - i_mean;
ts5 = t5 - i_mean;
%females test
ts3 = t3 - i_mean;
ts4 = t4 - i_mean;
ts6 = t6 - i_mean;


ts1c = reshape( ts1, [530432,1]);
ts2c = reshape( ts2, [530432,1]);
ts3c = reshape( ts3, [530432,1]);
ts4c = reshape( ts4, [530432,1]);
ts5c = reshape( ts5, [530432,1]);
ts6c = reshape( ts6, [530432,1]);

dist_1 = (ts1c' * U)*(ts1c' * U)';
dist_2 = (ts2c' * U)*(ts2c' * U)';
dist_5 = (ts5c' * U)*(ts5c' * U)';

dist_3 = (ts3c' * U)*(ts3c' * U)';
dist_4 = (ts4c' * U)*(ts4c' * U)';
dist_6 = (ts6c' * U)*(ts6c' * U)';




