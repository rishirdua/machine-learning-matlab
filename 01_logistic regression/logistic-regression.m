clc; clear; close all;

load datax.dat;
load datay.dat;

X = [ones(size(datax, 1),1) datax];
Y = datay;

m = size(X,1);
n = size(X,2)-1;

%initialize
theta = zeros(n+1,1);
thetaold = ones(n+1,1);

while ( ((theta-thetaold)'*(theta-thetaold)) > 0.0000001 )
	%calculate dellltheta
    dellltheta = zeros(n+1,1);
	for j=1:n+1,
		for i=1:m,
			dellltheta(j,1) = dellltheta(j,1) + [Y(i,1) - (1/(1 + exp(-theta'*X(i,:)')))]*X(i,j);
		end;
	end;
	%calculate hessian
	H = zeros(n+1, n+1);
	for j=1:n+1,
		for k=1:n+1,
				for i=1:m,
					H(j,k) = H(j,k) -[1/(1 + exp(-theta'*X(i,:)'))]*[1-(1/(1 + exp(-theta'*X(i,:)')))]*[X(i,j)]*[X(i,k)];
				end;
		end;
	end;
	thetaold = theta;
	theta = theta - inv(H)*dellltheta;
	(theta-thetaold)'*(theta-thetaold)
end



%part b
figure(1); hold on;
X0 = []; Y0 = []; X1 = []; Y1 = [];

%training points
for i=1:m,
	if Y(i)==0
		X0 = [X0 X(i,2)];
		Y0 = [Y0 X(i,3)];
	else
		X1 = [X1 X(i,2)];
		Y1 = [Y1 X(i,3)];
	end;
end;
scatter(X0, Y0, 'o');
scatter(X1, Y1, '+');

%decision boundary
Xb = -2:0.01:8;
Yb = (0.5 - theta(1) - theta(2)*Xb)/(theta(3));
plot(Xb, Yb);