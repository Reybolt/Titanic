%write to file

pass_id = cellfun(@str2num,data{1});

csvmat = [pass_id abs(yhat)];

csvwrite('output.csv',csvmat);

% fid = fopen('output.txt');
% 
% for i = 1:numel(yhat)
%    s = strcat(pass_id(i),',',num2str(yhat(i)));
%    
%    write to file
%    fprintf(fid,'%s \n',s);
% end
% 
% fclose(fid);