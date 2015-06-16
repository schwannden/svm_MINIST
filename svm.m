% svm.m
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
[t0, t1, t2, t3] = arg2vars (10, 0.1, 0, 0);
kernel = @(X,Y) t0 * exp(t1*norm(X-Y)^2/(-2)) + t2 + t3 * X' * Y;
[trainingData, trainingLabel] = select (trainingData, trainingLabel, 0, 1);
N = length (trainingLabel);
K = zeros (N);
toc;
disp('making kernel');tic;
for i = 1:N
    for j = i:N
        K(i, j) = 10 * exp ( 0.1 * norm(trainingData(i) - trainingData(j)));
    end
end
K = K + triu(K,1)';
K = K + 0.01 * eye(N);
save ('K.mat', 'K')
toc;

% modify the labels before svmTrain.
[C, tolerance, epsilon] = arg2vars (1, 0.1, 0.1);
[alpha, bias] = smoTrain (K, trainingLabel, C, tolerance, epsilon);