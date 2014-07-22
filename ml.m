%% Set up machine learning stuffs

%target var is survival
y = M(:,1);

%features are remaining stuffs
X = M(:,2:end);

%center data;
X = (X - repmat(mean(X),m,1))./repmat(std(X),m,1);

% SPLIT INTO TRAINING AND TESTING DATA

m = size(y,1);

%build training data
mtest = floor(8/10*m);

r = randperm(m);

Xtrain = X(r(1:mtest),:);
ytrain = y(r(1:mtest));

Xtest = X(r(mtest+1:end),:);
ytest = y(r(mtest+1:end));



%% LINEAR REGRESSION

bigX = [ones(mtest,1) Xtrain];
beta = bigX \ ytrain;

%tset
yhat = [ones(m-mtest,1) Xtest]*beta;
yhat = round(yhat);

%find percent of misclassified
misclass = sum(yhat~=ytest);
err_rat_ls = misclass/numel(ytest);

%rss
err = 1/sqrt(numel(ytest))*norm(yhat - ytest);


%% DO QDA AND LDA

%LDA
yhat_lda = classify(Xtest,Xtrain,ytrain,'linear');

%QDA
yhat_qda = classify(Xtest,Xtrain,ytrain,'quadratic');

%find percent of misclassified
misclass = sum(yhat_lda~=ytest);
err_rat_lda = misclass/numel(ytest);

%find percent of misclassified
misclass = sum(yhat_qda~=ytest);
err_rat_qda = misclass/numel(ytest);