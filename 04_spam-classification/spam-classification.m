clc; clear; close all;

% Note: Run wrapper.pl first

[Ytrain, Xtrain] = libsvmread('q4train_mod.dat');
[Ytest, Xtest] = libsvmread('q4test_mod.dat');

mtrain = size(Xtrain,1);
mtest = size(Xtest,1);
n = size(Xtrain,2);

% part a
% learn perceptron
Xtrain_perceptron = [ones(mtrain,1) Xtrain];
Xtest_perceptron = [ones(mtest,1) Xtest];
alpha = 0.1;
%initialize
theta_perceptron = zeros(n+1,1);
trainerror_mag = 100000;
iteration = 0;
%loop
while (trainerror_mag>1000)
	iteration = iteration+1;
	for i = 1 : mtrain
		Ypredict_temp = sign(theta_perceptron'*Xtrain_perceptron(i,:)');
		theta_perceptron = theta_perceptron + alpha*(Ytrain(i)-Ypredict_temp)*Xtrain_perceptron(i,:)';
	end
	Ytrainpredict_perceptron = sign(theta_perceptron'*Xtrain_perceptron')';
	trainerror_mag = (Ytrainpredict_perceptron - Ytrain)'*(Ytrainpredict_perceptron - Ytrain)
end
Ytestpredict_perceptron = sign(theta_perceptron'*Xtest_perceptron')';
testerror_mag = (Ytestpredict_perceptron - Ytest)'*(Ytestpredict_perceptron - Ytest)

%part b
theta_svm = svmtrain(Ytrain, Xtrain, '-t 0');
[Ytestpredict_svm, svm_accuracy, decision_values] = svmpredict(Ytest, Xtest, theta_svm);

%part c
accuracy = zeros(9,1);
for mtemp = 1000:1000:9000
	theta_svm = svmtrain(Ytrain(1:mtemp,:), Xtrain(1:mtemp,:), '-t 0');
	[Ytestpredict_svm, accuracy_temp, decision_values] = svmpredict(Ytest, Xtest, theta_svm);
	accuracy(mtemp/1000) = accuracy_temp(1,1);
end
plot (1000:1000:9000, accuracy);

%part d
numberofSV = theta_svm.nSV;

[spamValues,spamIndex] = sort(theta_svm.sv_coef,'ascend');
hamindices = theta_svm.sv_indices(spamIndex(1:5));
spamindices = theta_svm.sv_indices(spamIndex(theta_svm.totalSV-4:theta_svm.totalSV))

for i=1:numberofSV
	Y(i) = Ytrain(theta_svm.sv_indices(i));
	alpha_svm(i) = theta_svm.sv_coef(i)./Y(i);
end

%part e
w = theta_svm.SVs' * theta_svm.sv_coef;
b = -theta_svm.rho;
if theta_svm.Label(1) == -1
  w = -w;
  b = -b;
end
distance = 1/norm(w);

%part f
theta_svm = svmtrain(Ytrain, Xtrain, '-t 2');
[Ytestpredict_svm, rbf_accuracy, decision_values] = svmpredict(Ytest, Xtest, theta_svm);

%part g
XtrainMean = repmat(mean(Xtrain),mtrain,1);
XtrainVariance = repmat(std(Xtrain),mtrain,1);
Xtrain_n = (Xtrain - XtrainMean)./(XtrainVariance);
XtestMean = repmat(mean(Xtest),mtest,1);
XtestVariance = repmat(std(Xtest),mtest,1);
Xtest_n = (Xtest - XtrainMean)./(XtrainVariance);

theta_svm = svmtrain(Ytrain, Xtrain_n, '-t 0');
[Ytestpredict_svm, norm_svm_accuracy, decision_values] = svmpredict(Ytest, Xtest_n, theta_svm);
theta_svm = svmtrain(Ytrain, Xtrain_n, '-t 2');
[Ytestpredict_svm, norm_rbf_accuracy, decision_values] = svmpredict(Ytest, Xtest_n, theta_svm);

%part h
rbf_accuracy = zeros(19,1);
i = 0;
for gamma_i = 0.00010:0.00005:0.00100
	i = i+1;
	arguments_i  = strcat('-t 2 -g',{' '},num2str(gamma_i))
	theta_svm = svmtrain(Ytrain, Xtrain, arguments_i{1,1})
	[Ytestpredict_svm, temp_rbf_accuracy, decision_values] = svmpredict(Ytest, Xtest, theta_svm);
	rbf_accuracy(i) = temp_rbf_accuracy(1,1);
end
plot (0.00010:0.00005:0.00100, rbf_accuracy);

%part i
%in report