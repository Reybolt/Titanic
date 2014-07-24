%build matrix of stuffs (assumes train-original.csv is imported to
%workspace

%change Sex var to double
m = size(Sex1,1);
sex_double = zeros(size(Sex1));
embark_double = zeros(size(Embarked1));

for i = 1:m
    
    if strcmp(Sex1{i}, 'male');
        sex_double(i) = 1;
    else
        sex_double(i) = 0;
    end
   
    if strcmp(Embarked1{i}, 'C');
        embark_double(i) = 1;
    elseif strcmp(Embarked1{i},'S');
        embark_double(i) = 2;
    elseif strcmp(Embarked1{i},'Q');
        embark_double(i) = 3;
    end
        
end

M = [Age1 embark_double Fare1 Parch1 Pclass1 sex_double SibSp1];
