clc; clear; close all;

X = dlmread('digitdata.txt', ' ', 1, 1);
m = size(X,1);
n = size(X,2);
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen('digitdata.txt','r');
dataArray = textscan(fileID, formatSpec, 1, 'Delimiter', ' ', 'MultipleDelimsAsOne', true, 'ReturnOnError', false);
fclose(fileID);

raw = [dataArray{:,1:end-1}];
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=1:157
    % Converts strings in the input cell array to numbers. Replaced non-numeric strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Regular expression to detect and remove non-numeric prefixes and suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end
labels = cell2mat(raw);
%% Clear temporary variables
clearvars fileID formatSpec dataArray ans raw numericData col rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me;
fileID = fopen('digitlabels.txt','r');
dataArray = textscan(fileID, '%*s%f%[^\n\r]', 'Delimiter', ' ', 'MultipleDelimsAsOne', true, 'HeaderLines' ,1, 'ReturnOnError', false);
fclose(fileID);
Yactual = [dataArray{1:end-1}];

%part a
Im = zeros(28,28,157);
for i=1:m
	for j=1:n
		Im (idivide(labels(1,j),int8(28))+1, rem(labels(1,j),28)+1, i) = X(i,j);
	end
end


for k=1:157,
	imwrite(Im(:,:,k),strcat('visualized/',int2str(k),'.jpg'));
end


%part b
[clustered, S, error] = Kmean(X,4, Yactual);

%part c
figure(1);
if(size(S)>=20)
	plot(S(1:20));
else
	plot(S);
end
legend('S');
title('sum of squares of distance of each of the data points x(i) from the mean of the cluster it is assigned to vs iteration');

%part d
figure(2);
plot(error);
legend('error');
title('ratio of the number of mis-classified examples to the total number of examples vs iteration');