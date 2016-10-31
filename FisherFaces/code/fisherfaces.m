% class 1 == male
% class 2 == female

% train data directory
chdir('../../train_data');
list = dir;

% constants
M_1 = 152;
M_2 = 9;
h = 231;
w = 195;
epsilon = 0.01;

% since, in absence of other information we are equally likely to 
% encounter male and female faces, the prior probablity P1 & P2 is 0.5

P1 = 0.5;
P2 = 0.5;

D = h*w;
data_1 = zeros(D,M_1);
data_2 = zeros(D,M_2);

% load the class-1 train data
for k = 1:M_1
  G = imread(list(k+2).name);
  G = reshape(G, [D,1]);
  data_1(:,k) = G;
end

% load the class-2 train data
for k = (M_1+1):M_2
  G = imread(list(k+2).name);
  G = reshape(G, [D,1]);
  data_2(:,k) = G;
end

% normalise the data for each class
mean_face_1 = (mean(data_1'))';
%imshow(mean_face_1);
centered_data_1 = data_1 - mean_face_1;
C_1 = cov(centered_data_1');
C_1 = C_1 + epsilon*eye(D);

mean_face_2 = (mean(data_2'))';
%imshow(mean_face_2);
centered_data_2 = data_2 - mean_face_2;
C_2 = cov(centered_data_2');
C_2 = C_2 + epsilon*eye(D);

% calculate discriminant score for a test data (x) 
function score = d_1(x, mean_face_1, C_1, P1)
  score = ((x - mean_face_1)')*(inv(C_1))*(x - mean_face_1) + log(det(inv(C_1))) - 2*log(P1) ;
end

function score = d_2(x, mean_face_2, C_2, P2)
  score = ((x - mean_face_2)')*(inv(C_2))*(x - mean_face_2) + log(det(inv(C_2))) - 2*log(P2) ;
end

function ans = classify(x, mean_face_1, mean_face_2, C_1, C_2, P1, P2)
  if d_1(x, mean_face_1, C_1, P1) >= d_2(x, mean_face_2, C_2, P2)
    score = 1;
  else
    score = 2;
  end

end

% load test data 
chdir('../test_data');
list = dir;

T = 4;
data = zeros(D,T);
score = zeros(T);

for k = 1:T
  G = imread(list(k+2).name);
  G = reshape(G, [D,1]);
  data(:,k) = G;
  % classify the data
  score(k) = classify(data(:,k),mean_face_1, mean_face_2, C_1, C_2, P1, P2);
end