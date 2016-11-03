% train data directory
chdir('../../UNRDatabase/train/Female');
list = dir ;

% constants
M = 317;
h = 20;
w = 16;
n_faces = 50;
n_lighting_variation = 3;

D = h*w;
data = zeros(2*M,D); % twice because equal number of male and female images

% load the train data
for k = 1:M
  G = imread(list(k+2).name);
  G = reshape(G, [1,D]);
  data(k,:) = G;
end

chdir('../Male');
list = dir;

% load the train data
for k = 1:M
  G = imread(list(k+2).name);
  G = reshape(G, [1,D]);
  data(M+k,:) = G;
end



% normalise the data 
mean_face = mean(data);
imshow(mean_face);
centered_data = data - mean_face;

[V, Lambda] = eig( centered_data * centered_data' );
eigen_faces = centered_data' * V * (Lambda^(-0.5));

% use hueristics, the maximum variation is due to lightning, so we drop the 
% first three eigen vectors. We will take the next 50 eigenfaces as the basis.
eigen_faces = eigen_faces(:,[M - n_faces - n_lighting_variation:M - n_lighting_variation - 1]);

for k = 1:n_faces
  a = reshape(eigen_faces(:,k),[h,w]);
  %figure,imshow(a);
end

% eigenfaces is a method to represent the faces in lower dimensions by removing
% the axis which strongly corelated across the images, to give a compact 
% representation of the images. 
% It is a method for 'represenation' and not 'classification' of the images.

% now use KNN, GMM, etc.. partitioning methods to classify each test image.

centered_data = centered_data * eigen_faces;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                    %%    %%              %%                               %%
%%%                    %%  %%                %%                               %%
%%%                    %%%                   %%                               %%
%%%                    %%%               %%  %%  %%                           %%
%%%                    %%  %%             %% %% %%                            %%
%%%                    %%    %%             %%%%                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pkg load statistics

n_clusters = 10;
[idx,C] = kmeans(centered_data, n_clusters);
Y = [1;1;1;1;1;1;1;1;1;1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1];

N = 28;
D = 50; % new reduced dimension :) 
Final = zeros(1,N);

chdir('../../test/unlabled');
list = dir;

function [smallestNElements smallestNIdx] = getNElements(A, n)
     [ASorted AIdx] = sort(A);
     smallestNElements = ASorted(1:n);
     smallestNIdx = AIdx(1:n);
end

for k = 1:N
    L = imread(list(k+2).name);
    L = reshape(L,[1,320]);
    L = L - mean_face; % center the test data
    L = double(L) * eigen_faces; % project onto eigen faces
     
    Wtemp = zeros(10,D);
    for i = 1:10
        Wtemp(i,:) = L(1,:);
    end
    W = C - Wtemp;
    W = W*W';
    U =zeros(10,1);
    for i=1:10
        U(i,1)=W(i,i)^0.5;
    end
    T = U;
    A = zeros(1,5);
    [Usort,Uidx] = getNElements(U,5);
    for i=1:5
        Final(k)=Final(k)+Y(Uidx(i));
    end

end
