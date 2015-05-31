% svm.m
% Testing the performance of SVM on MNIST
% author: schwannden
% e-mail: schwannden@gmail.com

trainingData  = loadMNISTImages ('./MNIST/train-images.idx3-ubyte');
trainingLabel = loadMNISTLabels ('./MNIST/train-labels.idx1-ubyte');

testingData  = loadMNISTImages ('./MNIST/t10k-images.idx3-ubyte');
testingLabel = loadMNISTLabels ('./MNIST/t10k-labels.idx3-ubyte');

[t0, t1, t2, t3] = arg2vars (10, 0.1, 0, 0);
kernel = @(X,Y) t0 * exp(t1*norm(X-Y)^2/(-2)) + t2 + t3 * X' * Y;
% modify the labels before svmTrain.
[A, X, b] = svmTrain (trainingData, trainingLabel, kernel);