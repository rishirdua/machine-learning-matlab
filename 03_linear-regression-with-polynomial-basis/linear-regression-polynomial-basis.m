clc; clear; close all;

%fileread
Xtrain_tmp = []; Ytrain_tmp = [];
Xtest_tmp = []; Ytest_tmp = [];

fileID = fopen('q3.dat');

for linenum = 1:101
	C = textscan(fileID,'%s', 8, 'CommentStyle',{'"', '"'});
	if strcmp(C{1,1},'?') == 0
		Xtrain_tmp = [Xtrain_tmp; C{1,1}(2:8,1)'];
		Ytrain_tmp = [Ytrain_tmp; C{1,1}(1,1)];
	end
end;
Xtrain = str2double(Xtrain_tmp);
Ytrain = str2double(Ytrain_tmp);
mtrain = size(Xtrain,1);

for linenum = 102:399
	C = textscan(fileID,'%s', 8, 'CommentStyle',{'"', '"'});
	if strcmp(C{1,1},'?') == 0
		Xtest_tmp = [Xtest_tmp; C{1,1}(2:8,1)'];
		Ytest_tmp = [Ytest_tmp; C{1,1}(1,1)];
	end
end;
Xtest = str2double(Xtest_tmp);
Ytest = str2double(Ytest_tmp);
mtest = size(Xtest,1);

%normalize
XMin = min([Xtrain; Xtest]);
XMax = max([Xtrain; Xtest]);
YMin = mean([Ytrain; Ytest]);
YMax = std([Ytrain; Ytest]);
Xtrain = (Xtrain - repmat(XMin,mtrain,1))./(repmat(XMax,mtrain,1) - repmat(XMin,mtrain,1));
Xtest = (Xtest - repmat(XMin,mtest,1))./(repmat(XMax,mtest,1) - repmat(XMin,mtest,1));
Ytrain = (Ytrain - repmat(YMin,mtrain,1))./(repmat(YMax,mtrain,1) - repmat(YMin,mtrain,1));
Ytest = (Ytest - repmat(YMin,mtest,1))./(repmat(YMax,mtest,1) - repmat(YMin,mtest,1));

fclose(fileID);
max_dimension = 10;

% part a and b
training_error = zeros(max_dimension,1);
test_error = zeros(max_dimension,1);
figure(1); hold on;
for d = 1:max_dimension
	X = [ones(size(Xtrain, 1),1) Xtrain];
	Xtest_s = [ones(size(Xtest, 1),1) Xtest];
	for j=2:8,
		for k=2:d,
			X = [X X(:,j).^k];
			Xtest_s = [Xtest_s Xtest_s(:,j).^k];
		end;
	end;
	
	theta_closed = pinv(X'*X)*X'*Ytrain;
	
	n = size(X,2)-1;
	alpha = 0.01;
	theta_grad = zeros(n+1,1);
	for k = 1:1000,
		for i=1:mtrain,
			theta_grad = theta_grad + alpha * (Ytrain(i) - theta_grad'*X(i,:)') * X(i,:)';
		end;
	end;
	
	difference = norm(theta_grad - theta_closed)/size(theta_grad,1);
	
	for i=1:mtrain,
		training_error(d) = training_error(d) + (Ytrain(i) -(theta_grad'*X(i,:)'))^2;
	end;
	for i=1:mtest,
		test_error(d) = test_error(d) + (Ytest(i) -(theta_grad'*Xtest_s(i,:)'))^2;
	end;
end;
plot (1:max_dimension, training_error);
plot (1:max_dimension, test_error);

% part c and d
training_error = zeros(max_dimension,1);
test_error = zeros(max_dimension,1);
figure (2); hold on;
scatter (Xtrain(:,3), Ytrain);
for d = 1:max_dimension
	X = [ones(size(Xtrain, 1),1) Xtrain(:,3)];
	Xtest_s = [ones(size(Xtest, 1),1) Xtest(:,3)];
	for j=2:2,
		for k=2:d,
			X = [X X(:,j).^k];
			Xtest_s = [Xtest_s Xtest_s(:,j).^k];
		end;
	end;

	n = size(X,2)-1;

	alpha = 0.01;
	theta_grad = zeros(n+1,1);
	for k = 1:1000,
		for i=1:mtrain,
			theta_grad = theta_grad + alpha * (Ytrain(i) - theta_grad'*X(i,:)') * X(i,:)';
		end;
	end;
	
	if ((d==1)||(d==2)||(d==8))
		X_plot = 0:0.01:1;
		Y_plot = [];
		for i=0:0.01:1,
			X_matrix = [1];
			for k = 1:d,
				X_matrix = [X_matrix; i.^k];
			end;
			Y_plot = [Y_plot, theta_grad'*X_matrix];
		end;
		plot (X_plot,Y_plot);
	end;
	
	for i=1:mtrain,
		training_error(d) = training_error(d) + (Ytrain(i) -(theta_grad'*X(i,:)'))^2;
	end;
	for i=1:mtest,
		test_error(d) = test_error(d) + (Ytest(i) -(theta_grad'*Xtest_s(i,:)'))^2;
	end;
end;

figure(3); hold on;
plot (1:max_dimension, training_error);
plot (1:max_dimension, test_error);

%part e
training_error = zeros(6,1);
test_error = zeros(6,1);
figure (4); hold on;
d=8;
gn=0;
for gamma = [0.01, 0.1, 1, 10, 100, 1000]
	gn = gn+1;
	X = [ones(size(Xtrain, 1),1) Xtrain(:,3)];
	Xtest_s = [ones(size(Xtest, 1),1) Xtest(:,3)];
	for j=2:2,
		for k=2:d,
			X = [X X(:,j).^k];
			Xtest_s = [Xtest_s Xtest_s(:,j).^k];
		end;
	end;

	n = size(X,2)-1;

	alpha = 0.01;
	theta_grad = zeros(n+1,1);
	for k = 1:1000,
		for i=1:mtrain,
			theta_grad = theta_grad + alpha * ((Ytrain(i) - theta_grad'*X(i,:)') * X(i,:)' - gamma*theta_grad);
		end;
	end;
	
	X_plot = 0:0.01:1;
	Y_plot = [];
	for i=0:0.01:1,
		X_matrix = [1];
		for k = 1:d,
			X_matrix = [X_matrix; i.^k];
		end;
		Y_plot = [Y_plot, theta_grad'*X_matrix];
	end;
	plot (X_plot,Y_plot);

	
	for i=1:mtrain,
		training_error(gn) = training_error(gn) + (Ytrain(i) -(theta_grad'*X(i,:)'))^2;
	end;
	for i=1:mtest,
		test_error(gn) = test_error(gn) + (Ytest(i) -(theta_grad'*Xtest_s(i,:)'))^2;
	end;
end;
figure(5);
semilogx ([0.01, 0.1, 1, 10, 100, 1000], training_error, [0.01, 0.1, 1, 10, 100, 1000], test_error);


%part f
XYdata = [Xtrain Ytrain];
I_rand = XYdata(randperm(size(Xtrain,1)), :);
Xtrain = I_rand(:,1:7);
Ytrain = I_rand(:,8);
test_error = zeros(6,5);
test_error_avg = zeros(6,1);
mtrain_new = 80; 
mtest_new = 20;

figure (6); hold on;
scatter (Xtrain(:,3), Ytrain);
d=8;
gn=0;
for gamma = [0.01, 0.1, 1, 10, 100, 1000]
	gn = gn+1;
	for cn = 1:5
		if (cn==5)
			Xnewtrain = [Xtrain(1:20*(cn-1),:)];
		else
			Xnewtrain = [Xtrain(1:20*(cn-1),:);Xtrain(20*cn+1:100,:)];
		end
		Xnewtest = [Xtrain(1+20*(cn-1):20*cn,:)];
		
		X = [ones(size(Xnewtrain, 1),1) Xnewtrain(:,3)];
		Xtest_s = [ones(size(Xnewtest, 1),1) Xnewtest(:,3)];
		for j=2:2,
			for k=2:d,
				X = [X X(:,j).^k];
				Xtest_s = [Xtest_s Xtest_s(:,j).^k];
			end;
		end;

		n = size(X,2)-1;

		alpha = 0.01;
		theta_grad = zeros(n+1,1);
		for k = 1:1000,
			for i=1:mtrain_new,
				theta_grad = theta_grad + alpha * ((Ytrain(i) - theta_grad'*X(i,:)') * X(i,:)' - gamma*theta_grad);
			end;
		end;

		for i=1:mtest_new,
			test_error(gn,cn) = test_error(gn) + (Ytest(i) -(theta_grad'*Xtest_s(i,:)'))^2;
		end;
	end;
	test_error_avg(gn) = ( test_error(gn,1) + test_error(gn,2) + test_error(gn,3) + test_error(gn,4) + test_error(gn,5) ) / 5;
end;
figure(7);
semilogx ([0.01, 0.1, 1, 10, 100, 1000], test_error_avg);
