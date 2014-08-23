clc; clear; close all;

%notations used
% in the matrix:
	% for x
		% 0: demorat
		% 1: republican
	% for y
		% 0: no
		% 1: yes
		% 2: ?
% in the tree:
	% for node/value
		% -2: democrat
		% -1: republican
		%  0: null/not predictable
	% for link
		% 0: no
		% 1: yes
		% 2: ?


%read data
fid = fopen('train.data');
C = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 'delimiter', ',');
fid = fclose(fid);
tXtrain = [C{1,2:17}];
tYtrain = [C{1,1}];
mtrain = size(tYtrain,1);

fid = fopen('test.data');
C = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 'delimiter', ',');
fid = fclose(fid);
tXtest = [C{1,2:17}];
tYtest = [C{1,1}];
mtest = size(tYtest,1);

fid = fopen('validation.data');
C = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 'delimiter', ',');
fid = fclose(fid);
tXvalidate = [C{1,2:17}];
tYvalidate = [C{1,1}];
mvalidate = size(tYvalidate,1);

Xtrain = zeros(size(tXtrain));
Ytrain = zeros(size(tYtrain));
Xtest = zeros(size(tXtest));
Ytest = zeros(size(tYtest));
Xvalidate = zeros(size(tXvalidate));
Yvalidate = zeros(size(tYvalidate));


for i=1:mtrain,
	for j=1:16,
		if (strcmp(tXtrain(i,j),'n'))
			Xtrain(i,j) = 0;
		end
		if (strcmp(tXtrain(i,j),'y'))
			Xtrain(i,j) = 1;
		end
		if (strcmp(tXtrain(i,j),'?'))
			Xtrain(i,j) = 2;
		end
	end
	if (strcmp(tYtrain(i,1),'democrat'))
		Ytrain(i,1) = 0;
	end
	if (strcmp(tYtrain(i,1),'republican'))
		Ytrain(i,1) = 1;
	end
end

for i=1:mtest,
	for j=1:16,
		if (strcmp(tXtest(i,j),'n'))
			Xtest(i,j) = 0;
		end
		if (strcmp(tXtest(i,j),'y'))
			Xtest(i,j) = 1;
		end
		if (strcmp(tXtest(i,j),'?'))
			Xtest(i,j) = 2;
		end
	end
	if (strcmp(tYtest(i,1),'democrat'))
		Ytest(i,1) = 0;
	end
	if (strcmp(tYtest(i,1),'republican'))
		Ytest(i,1) = 1;
	end
end

for i=1:mvalidate,
	for j=1:16,
		if (strcmp(tXvalidate(i,j),'n'))
			Xvalidate(i,j) = 0;
		end
		if (strcmp(tXvalidate(i,j),'y'))
			Xvalidate(i,j) = 1;
		end
		if (strcmp(tXvalidate(i,j),'?'))
			Xvalidate(i,j) = 2;
		end
	end
	if (strcmp(tYvalidate(i,1),'democrat'))
		Yvalidate(i,1) = 0;
	end
	if (strcmp(tYvalidate(i,1),'republican'))
		Yvalidate(i,1) = 1;
	end
end

Xtemp = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16; Xtrain];

%part a

%learn
minerror_tree = growtree(Xtemp, Ytrain, 'minerror');
%test error
Yminerror = predicttree(minerror_tree,Xtest) + 2;
minerror_error = 0;
for i=1:size(Ytest,1)
	if (Yminerror(i)~=Ytest(i))
		minerror_error = minerror_error + 1;
	end
end
minerror_error = minerror_error/size(Ytest,1);
%plot error at every step
steperror_minerror_train = steperror(Xtrain,Ytrain,minerror_tree);
steperror_minerror_test = steperror(Xtest,Ytest,minerror_tree);
steperror_minerror_validate = steperror(Xvalidate,Yvalidate,minerror_tree);
figure(1); hold on;
plot(steperror_minerror_train, 'r');
plot(steperror_minerror_test, 'g');
plot(steperror_minerror_validate, 'b');
title('min error tree');
legend('train error', 'test error', 'validate error');

%part b

%learn
infogain_tree = growtree(Xtemp, Ytrain, 'infogain');
%test error
Yinfogain = predicttree(infogain_tree,Xtest) + 2;
infogain_error = 0;
for i=1:size(Ytest,1)
	if (Yinfogain(i)~=Ytest(i))
		infogain_error = infogain_error + 1;
	end
end
infogain_error = infogain_error/size(Ytest,1);
%plot error at every step
steperror_infogain_train = steperror(Xtrain,Ytrain,infogain_tree);
steperror_infogain_test = steperror(Xtest,Ytest,infogain_tree);
steperror_infogain_validate = steperror(Xvalidate,Yvalidate,infogain_tree);
figure(2); hold on;
plot(steperror_infogain_train, 'r');
plot(steperror_infogain_test, 'g');
plot(steperror_infogain_validate, 'b');
title('info gain tree');
legend('train error', 'test error', 'validate error');


%part c
finished=0;

trainerrorcombined=[];
testerrorcombined=[];
validationerrorcombined=[];

while (finished==0)
	[infogain_tree, finished] = removebest(Xvalidate, Yvalidate, infogain_tree);
	
	%plot accuracies
	Yinfogain = predicttree(infogain_tree,Xtrain) + 2;
	infogain_error = 0;
	for i=1:size(Ytrain,1)
		if (Yinfogain(i)~=Ytrain(i))
			infogain_error = infogain_error + 1;
		end
	end
	infogain_error = infogain_error/size(Ytrain,1);
	trainerrorcombined = [trainerrorcombined, infogain_error];
	
	Yinfogain = predicttree(infogain_tree,Xtest) + 2;
	infogain_error = 0;
	for i=1:size(Ytest,1)
		if (Yinfogain(i)~=Ytest(i))
			infogain_error = infogain_error + 1;
		end
	end
	infogain_error = infogain_error/size(Ytest,1);
	testerrorcombined = [testerrorcombined, infogain_error];
	
	Yinfogain = predicttree(infogain_tree,Xvalidate) + 2;
	infogain_error = 0;
	for i=1:size(Yvalidate,1)
		if (Yinfogain(i)~=Yvalidate(i))
			infogain_error = infogain_error + 1;
		end
	end
	infogain_error = infogain_error/size(Yvalidate,1);
	validationerrorcombined = [validationerrorcombined, infogain_error];

end
figure(3);
hold on;
plot(trainerrorcombined,'r');
plot(testerrorcombined, 'g');
plot(validationerrorcombined, 'b');