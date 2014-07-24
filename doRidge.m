function [err,beta] = doRidge(Xtest,Ytest,Xtrain,Ytrain)

global lambda

%add column of zeros
Xtrain = [ones(size(Xtrain,1),1) Xtrain];

%penalty matrix
penalty_mat = lambda*eye(size(Xtrain,2));
%don't penalize \beta_0
penalty_mat(1,1) = 0;

beta  = (Xtrain'*Xtrain + penalty_mat) \ (Xtrain'*Ytrain);

yhat = [ones(size(Xtest,1),1) Xtest]*beta;
Yhat = (yhat>=1/2);

%calculate misclassification rate
err = sum(Yhat~=Ytest)/numel(Ytest);


end