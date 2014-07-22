function data = import_KC(filename)
    fid = fopen(filename);
    format = '%s%s%s %s%s%s %s%s%s %s%s%s';
    data = textscan(fid, format, 'Delimiter', {','},'headerlines',1);
    fclose(fid);
end 