function [ A, X, b ] = svmTrain( trainingData, trainingLabel, kernel )
% svmTrain 
% Input: 
%     [trainingData, trainingLabel]: Training set
%     kernel: kernel function in (7.32). Should be positive definite
% Output:
%     A: list of coefficient, A(i) = a_i as in (7.13)
%     X: list of support vectors. X(i)(j) is the jth pixel of the ith
%     support vector
%     b: bias as in (7.13). Notice this can be computed from A and X, we
%     provide this as return value just for convenience.
% Function:
% Find A that minimizes loss, where loss is defined by
N = length(X);    % dimension of support vector
K = zeros (N, N); % K(i)(j) = kernel(X(i), X(j))
V = zeros (N);    % V(i) = A(i) * trainingLabel(i);
for i = 1:N
    V(i) = A(i) * trainingLabel(i);
    for j = 1:N
        K(i, j) = kernel(X(i), X(j));
    end
end
% Notice this is equivalent to expression in (7.32)
loss = sum(A) - 0.5 * V' * K * V;

end

