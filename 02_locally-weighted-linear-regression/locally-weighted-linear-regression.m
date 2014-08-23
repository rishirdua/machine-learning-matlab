clc; clear; close all;

load datax.dat;
load datay.dat;

X = [ones(size(datax, 1),1) datax];
Y = datay;

m = size(X,1);
n = size(X,2)-1;

%part a
figure(1); hold on;
theta = inv(X'*X)*X'*Y;
scatter (q2x, Y);
Xp = -6:0.01:13;
Yp = theta(1) + theta(2)*Xp;
plot (Xp, Yp);

%part b
figure(2); hold on;
W = zeros(m);
t = 0.8;
LWRXp = -6:0.01:13;
LWRYp = [];
for temp = 1:size(LWRXp,2),
	for i=1:m,
		W(i,i) = 0.5 * exp(-((LWRXp(temp)-X(i,2))^2)/(2*t*t));
	end;
	theta = inv(X'*W*X)*X'*W*Y;
	LWRYp(temp) = theta(1)+theta(2)*LWRXp(temp);
end;
scatter (q2x, Y);
plot (LWRXp, LWRYp);

%part c
figure(3); hold on;
scatter (q2x, Y);
W = zeros(m);
t_array = [0.1, 0.3, 2,10];
LWRXp = -6:0.01:13;
LWRYp = [];
for t=1:4,
	for temp = 1:size(LWRXp,2),
		for i=1:m,
			W(i,i) = 0.5 * exp(-((LWRXp(temp)-X(i,2))^2)/(2*t_array(t)*t_array(t)));
		end;
		theta = inv(X'*W*X)*X'*W*Y;
		LWRYp(t,temp) = theta(1)+theta(2)*LWRXp(temp);
	end;
end;
plot (LWRXp, LWRYp);