% Loading the dataset
dataSet = load('TestDataSet.txt');

%% Storing the values in seperate vectors
%x = dataSet(:, 1);
%y = dataSet(:, 2);

chdir('C:\Users\abhi\Videos\smai\train\Female');
list = dir;  
M = 317; %no. of samples
h = 20;  %size of the image
w = 16;
D = h*w;
X = zeros (M,D);
%load female train data
for k = 1:M
    G = imread(list(k+2).name);
    G = reshape(G, [1 D]);
    X(k,:) = G;  % X is input.
end

%%% load y matrix here..............!!!
y = ones(317 1);

% Do you want feature normalization?
normalization = true;

% Applying mean normalization to our dataset
if (normalization)
    maxX = max(x);
    minX = min(x);
    x = (x - maxX) / (maxX - minX);
end

% Adding a column of ones to the beginning of the 'x' matrix
x = [ones(length(x), 1) x];

%%  Plotting the dataset
% figure;
% plot(x(:, 2), y, 'rx', 'MarkerSize', 10);
% xlabel('Size ( squared meters )');
% ylabel('Price');
% title('Housing Prices');

% Running gradient descent on the data
% 'x' is our input matrix
% 'y' is our output vector
% 'parameters' is a matrix containing our initial theta and slope
parameters = [0; 0];
learningRate = 0.1;
repetition = 2000;
[parameters, costHistory] = gradient(x, y, parameters, learningRate, repetition);

% Plotting our final hypothesis
figure;
plot(min(x(:, 2)):max(x(:, 2)), parameters(1) + parameters(2) * (min(x(:, 2)):max(x(:, 2))));
hold on;

% Plotting the dataset on the same figure
plot(x(:, 2), y, 'rx', 'MarkerSize', 10);

% Plotting our cost function on a different figure to see how we did
figure;
plot(costHistory, 1:repetition);

% Finally predicting the output of the provided input
input = 5;
if (normalization)
    input = (input - maxX) / (maxX - minX);
end
output = parameters(1) + parameters(2) * input;
disp(output);