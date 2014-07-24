function [err, big_beta,inds_used] = doFSS(Xtest,Ytest,Xtrain,Ytrain)
%this function uses forward step size selection
%trains on (Xtrain,Ytrain)
%tests on (Xtest, Ytest)
%returns error

%get global variable, which is the max number of cols to use
global subset_num

%get size of training data
[m,n] = size(Xtrain);

%add column of ones (so you can do calculate intercept)
Xtrain = [ones(m,1) Xtrain];

%compute norms of each column
Xnorms = sqrt(sum(Xtrain.^2,1));

%normalize columns of X
Xtmp = Xtrain./repmat(Xnorms,m,1);

%pick column of X that best approximates Y
[~,ind_start] = max(abs(Xtmp'*Ytrain));

%column ind_start is best

%first initialize Q
% ind_start = 1;

%One vector to start with
X1 = Xtrain;%(:,ind_start);
X1(:,1) = Xtrain(:,ind_start);
%leftovers
% X2 = Xtrain(:,[ 1:ind_start-1 ind_start+1:end]);

Q = X1(:,ind_start)/norm(X1(:,ind_start));

% ind_start
% rtest = Ytrain - Q*Q'*Ytrain;
% disp(norm(rtest)/sqrt(numel(Ytrain)))

%keep track of used indices and unused ones
inds_used = zeros(subset_num,1);
inds_used(1) = ind_start;
inds_unused = [ 1:ind_start-1 ind_start+1:n];

%loop through columns of X to add to basis
for j = 2:subset_num
    
    %find direction of new column of Q
    qnew_candidates = Xtrain(:,inds_unused) - Q*Q' * Xtrain(:,inds_unused);
    
    %normalize new directions
    qnew_colnorm = sqrt(sum(qnew_candidates.^2,1));
    qnew = qnew_candidates./repmat(qnew_colnorm,size(qnew_candidates,1),1);
    
    %we want to maximize:
    %max_j y^T (Q qnew ) (Q qnew)^T y
    
    candidates_num = size(qnew,2);
    holder = zeros(candidates_num,1);
    
    %loop through possible new candidates
    for l = 1:candidates_num
        holder(l) = (Ytrain' *qnew(:,l)) * qnew(:,l)' * Ytrain;
    end
    
    %find maximum index
    [~,max_ind_tmp] = max(holder);
    max_ind = inds_unused(max_ind_tmp);
    
    %update X1
    X1(:,1:j) = [X1(:,1:j-1) Xtrain(:,max_ind)];
    
    %update used indices of columns
    inds_used(j) = max_ind;
    %delete new index from unused
    inds_unused(inds_unused==max_ind) = [];
    
    %create new orthogonal projection
    [Q,~] = qr(X1(:,1:j),0);
    
%     rtest = Ytrain - Q*Q'*Ytrain;
%     disp(norm(rtest)/sqrt(numel(Ytrain)))
    
end
%calculate weights for smaller least squares problem
beta = Xtrain(:,inds_used)  \ Ytrain;

big_beta = zeros(n+1,1);
big_beta(inds_used) = beta;

%predictor is now Xtest*big_beta
Yfit = [ones(size(Xtest,1),1) Xtest]*big_beta;
Yfit = Yfit>=1/2;

err = sum(Yfit~=Ytest)/numel(Ytest);



end