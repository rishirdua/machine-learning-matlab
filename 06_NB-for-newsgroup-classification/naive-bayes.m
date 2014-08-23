clc; clear; close all;

% Note: run wrapper.pl first


% read data
M = dlmread('20ng-rec_talk_features.txt', '\t');
m = max(M(:,1));
tXfull = sparse(M(:,1), M(:,2), M(:,3), m, max(M(:,2)));
tYfull = dlmread('20ng-rec_talk_labels.txt');
randval = randperm(m);
Xtrain = tXfull(randval,:);
Ytrain = tYfull(randval,:);

%part a
error = zeros(1,5);
for cn = 1:5
	if (cn==5)
		Xnewtrain = Xtrain(1:1446*(cn-1),:);
		Ynewtrain = Ytrain(1:1446*(cn-1),:);
	else
		elements = [1:1446*(cn-1),1446*cn+1:7230];
		Xnewtrain = Xtrain(elements,:);
		Ynewtrain = Ytrain(elements,:);
	end
	Xnewtest = Xtrain(1+1446*(cn-1):1446*cn,:);
	Ynewtest = Ytrain(1+1446*(cn-1):1446*cn,:);
	
	[learntprob, learntprob_tokens] = trainnb(Xnewtrain, Ynewtrain);
	error(cn) = testnb(Xnewtest, Ynewtest, learntprob, learntprob_tokens);
end
avgerr_cv = mean(error);
avgacc_cv = (1-avgerr_cv)*100;

%part b
Yrand = randi(8,size(Ytrain,1),1);
numdocs_wrong = 0;
for i=1:size(Ytrain,1),
	if (Yrand(i)~=Ytrain(i))
		numdocs_wrong = numdocs_wrong + 1;
	end
end
avgerr_random = numdocs_wrong/size(Ytrain,1);
avgacc_random = (1-avgerr_random)*100;

%part c
%In these cases predicting either of the two newsgroups is counted as a correct prediction.

%part d
tss = [1000,2000,3000,4000,5000,5784];
averageerror = zeros(1,size(tss,2));
for i=1:size(tss,2)
	error = zeros(1,5);
	for cn = 1:5
		if (cn==5)
			Xnewtrain = Xtrain(1:1446*(cn-1),:);
			Ynewtrain = Ytrain(1:1446*(cn-1),:);
		else
			elements = [1:1446*(cn-1),1446*cn+1:7230];
			Xnewtrain = Xtrain(elements(1:tss(i)),:);
			Ynewtrain = Ytrain(elements(1:tss(i)),:);
		end
		Xnewtest = Xtrain(1+1446*(cn-1):1446*cn,:);
		Ynewtest = Ytrain(1+1446*(cn-1):1446*cn,:);
		[learntprob, learntprob_tokens] = trainnb(Xnewtrain, Ynewtrain);
		error(cn) = testnb(Xnewtest, Ynewtest, learntprob, learntprob_tokens);
	end
	avg_err_tsscombined(i) = mean(error);
end
figure(1);
plot(avg_err_tsscombined);
legend('average error');
title('learning curve');

%part e
confusion = zeros(8,8,5);
for cn = 1:5
	if (cn==5)
		Xnewtrain = Xtrain(1:1446*(cn-1),:);
		Ynewtrain = Ytrain(1:1446*(cn-1),:);
	else
		elements = [1:1446*(cn-1),1446*cn+1:7230];
		Xnewtrain = Xtrain(elements,:);
		Ynewtrain = Ytrain(elements,:);
	end
	Xnewtest = Xtrain(1+1446*(cn-1):1446*cn,:);
	Ynewtest = Ytrain(1+1446*(cn-1):1446*cn,:);
	
	[learntprob, learntprob_tokens] = trainnb(Xnewtrain, Ynewtrain);
	[~,confusion(:,:,cn)] = testnb(Xnewtest, Ynewtest, learntprob, learntprob_tokens);
end