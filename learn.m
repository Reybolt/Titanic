%machine learning stuff

%% Pre process data

%first load the data

%filename
fn = 'train-edited.csv';
data = import_KC(fn);


% PassengerId,Survived,Pclass,Name,Sex,Age,SibSp,
%    Parch,Ticket,Fare,Cabin,Embarked

%some of the columns are useless
useful_columns = [2 3 5 6 7 8 10 12];

%some of the columns are non numerical

%get number of entries in data
[m,~] = size(data{1});

data5 = data{5};
data12 = data{12};


%%%%%%%
% Male = 1      Female = 0
% 
% S = 1    C = 2     Q = 3
% 
% 
%%%%%%%


for i = 1:m
    
    if strcmp(data5{i}, 'male');
        data5{i} = '1';
    else
        data5{i} = '0';
    end
    
    if strcmp(data12{i},'S')
        data12{i} = '1';
    elseif strcmp(data12{i},'C')
        data12{i} = '2';
    else
        data12{i} = '3';
    end

end

newdata = data;

newdata{5} = data5;newdata{12} = data12;
newdata = newdata(useful_columns);

M = zeros(m,size(newdata,2));
for i = 1:size(newdata,2)
    derp = cellfun(@str2num,newdata{i});
    M(:,i) = derp;
end


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
