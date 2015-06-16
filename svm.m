function [] = svm()% svm.m
% Testing the performance of SVM on MNIST, with smo
% author: schwannden
% e-mail: schwannden@gmail.com
disp('reading data');tic;
trainingData  = loadMNISTImages ('./MNIST/train-images.idx3-ubyte');
trainingLabel = loadMNISTLabels ('./MNIST/train-labels.idx1-ubyte');

testingData  = loadMNISTImages ('./MNIST/t10k-images.idx3-ubyte');
testingLabel = loadMNISTLabels ('./MNIST/t10k-labels.idx1-ubyte');
toc;

disp('initializing');tic;
[trainingData, trainingLabel] = select (trainingData, trainingLabel, 0, 1);
[testingData , testingLabel ] = select (testingData , testingLabel , 0, 1);
% trainingData = trainingData(1:5000, :);
% trainingLabel = trainingLabel(1:5000);
% testingData = testingData(1:5000, :);
% testingLabel = testingLabel(1:5000);
N = length (trainingLabel);
toc;
disp('making kernel');tic;
K = zeros (N);
for i = 1:N
    for j = i:N
        K(i, j) = kernel (trainingData(i,:), trainingData(j,:));
    end
end
K = K + triu(K,1)';
K = K + 0.01 * eye(N);
save ('K.mat', 'K')
toc;

disp('smo');tic;
[C, tolerance, epsilon] = arg2vars (10000, 0.1, 0.1);
[alpha, bias] = smoTrain (K, trainingLabel', C, tolerance);
toc;

disp ('predicting');tic;
N = length (testingLabel);
M = length (trainingLabel);
correctCount = 0;
correct = 0;
k = zeros (M, 1);
for i = 1:N
    x = testingData (i, :);
    for j = 1:M
        k(j) = kernel (x, trainingData(j, :));
    end
    correct = sum(alpha' .* trainingLabel .* k) + bias > 0;
    correctCount = correctCount + correct;
end
sprintf ('prediction accuracy is: %d', 100* correctCount / N)
toc;
end

function [k] = kernel (X, Y)
    k = 10 * exp(0.1*norm(X-Y)^2/(-2));
end
