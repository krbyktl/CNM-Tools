%adjust directory based on file locations
testfiledir = '/Users/kirbyleo/Documents/JHU CNM/Spring 2020/RGC Counting/02-20-20 analyzed images/';
matfiles = dir(fullfile(testfiledir, '*.csv'));
names = [];
values = [];
for i = 1:length(matfiles)
    selectedfile = fullfile(testfiledir, matfiles(i).name);
    names = [names, string(matfiles(i).name)];
    num = csvread(selectedfile, 1, 0);
    values = [values, length(num)];
end
%create a table with file names and number of cell counts
table = [names.', double(values.')];
T=array2table(table);
%adjust output file name
writetable(T,'02-20-20images.csv');