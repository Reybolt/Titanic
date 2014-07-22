%machine learning stuff

%% Pre process data

%first load the data

%filename
fn = 'test-edited.csv';
data = import_KC(fn);


% PassengerId,Survived,Pclass,Name,Sex,Age,SibSp,
%    Parch,Ticket,Fare,Cabin,Embarked

%some of the columns are useless
% useful_columns = [2 3 5 6 7 8 10 12];

%for testing
useful_columns = [2 4 5 6 7 9 11];

%some of the columns are non numerical

%get number of entries in data
[m,~] = size(data{1});

data5 = data{4};
data12 = data{11};


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

newdata{4} = data5;newdata{11} = data12;
newdata = newdata(useful_columns);

M = zeros(m,size(newdata,2));
for i = 1:size(newdata,2)
    
    derp = cellfun(@str2num,newdata{i});
    M(:,i) = derp;
end

