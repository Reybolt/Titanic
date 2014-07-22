%machine learning stuff

%% Pre process data

%first load the data

%filename
fn = 'train.csv';
data = import_KC(fn);


% PassengerId,Survived,Pclass,Name,Sex,Age,SibSp,
%    Parch,Ticket,Fare,Cabin,Embarked

%some of the columns are useless
useful_columns = [2 3 5 6 7 8 9 10 12];

%some of the columns are non numerical

%get number of entries in data
[m,~] = size(data{1});

data5 = data{5};
data12 = data{12};


%%%%%%%
% Male = 1     Female = 0
% 
% S = 1   C = 2    Q = 3
%
%%%%%%%


for i = 1:m
    
    if strcmp(data5{i}, 'Male');
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
    i
    derp = cellfun(@str2num,newdata{i});
    M(:,i) = derp;
end
