% train data directory
chdir('../../train_data');
list = dir ;

% constants
M = 161;
h = 231;
w = 195;
n_faces = 50;
n_lighting_variation =3;

D = h*w;
data = zeros(M,D);

% load the train data
for k = 1:M
  G = imread(list(k+2).name);
  G = reshape(G, [1,D]);
  data(k,:) = G;
end

% normalise the data 
mean_face = mean(data);
imshow(mean_face);
centered_data = data - mean_face;

% C = cov(centered_data);
[V, Lambda] = eig( centered_data * centered_data' );
eigen_faces = centered_data' * V * (Lambda^(-0.5));

% use hueristics, the maximum variation is due to lightning, so we drop the 
% first three eigen vectors. We will take the next 50 eigenfaces as the basis.
eigen_faces = eigen_faces(:,[M - n_faces - n_lighting_variation:M - n_lighting_variation]);

for k = 1:n_faces
  figure,imshow((reshape(eigen_faces(:,k),[h,w])))
end

% eigenfaces is a method to represent the faces in lower dimensions by removing
% the axis which strongly corelated across the images, to give a compact 
% representation of the images. 
% It is a method for 'represenation' and not 'classification' of the images.

% now use KNN, GMM, etc.. partitioning methods to classify each test image.

