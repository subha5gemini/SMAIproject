pkg load statistics
%train female data directory
chdir('../UNRDatabase/train/Female');
list = dir;  

M = 317; %no. of samples, same for both classes
h = 20;  %size of the image
w = 16;
n_clusters = 10;

D = h*w;

data1 = zeros (M,D);

%load female train data
for k = 1:M
    G = imread(list(k+2).name);
    G = reshape(G, [1,D]);
    data1(k,:) = G;
end

[idx1,C1] = kmeans(data1, n_clusters);

chdir('../Male');
list = dir;  %train male data directory

data2 = zeros(M,D);

%load male train data
for k = 1:M
    G = imread(list(k+2).name);
    G = reshape(G, [1,D]);
    data2(k,:) = G;
end

[idx2,C2] = kmeans(data2, n_clusters);

X = vertcat(C1,C2);

%Showing the representative faces
% tempC = reshape(X(1,:), [h w]);
% imshow(tempC/255)

% applying KNN classfication on these 20 representative faces
% with K = 5

Y = [1;1;1;1;1;1;1;1;1;1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1];

%testing

chdir('../../test/unlabled');
list=dir;
N = 28;
Final = zeros(1,N);

function [smallestNElements smallestNIdx] = getNElements(A, n)
     [ASorted AIdx] = sort(A);
     smallestNElements = ASorted(1:n);
     smallestNIdx = AIdx(1:n);
end

for k = 1:N
    L = imread(list(k+2).name);
    L = reshape(L, [1,D]);
    Wtemp = zeros(20,D);
    for i = 1:20
        Wtemp(i,:) = L(1,:);
    end
    W = X - Wtemp;
    W = W*W';
    U =zeros(20,1);
    for i=1:20
        U(i,1)=W(i,i)^0.5;
    end
    T = U;
    A = zeros(1,5);
    [Usort,Uidx] = getNElements(U,5);
    for i=1:5
        Final(k)=Final(k)+Y(Uidx(i));
    end

end

