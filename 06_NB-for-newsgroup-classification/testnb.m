function [fraction_wrong, confusion] = testnb(X, Y, prob, prob_tokens)
	mtest = size(X,1);

	% Calculate log p(x|y=1) + log p(y=1) and log p(x|y=0) + log p(y=0) for every doc and select highest one
	log_autos = X*(log(prob_tokens(1,:)))' + log(prob(1,:));
	log_motorcycles = X*(log(prob_tokens(2,:)))'+ log(prob(2,:));
	log_baseball = X*(log(prob_tokens(3,:)))'+ log(prob(3,:));
	log_hockey = X*(log(prob_tokens(4,:)))'+ log(prob(4,:));
	log_guns = X*(log(prob_tokens(5,:)))'+ log(prob(5,:));
	log_mideast = X*(log(prob_tokens(6,:)))'+ log(prob(6,:));
	log_politics = X*(log(prob_tokens(7,:)))'+ log(prob(7,:));
	log_religion = X*(log(prob_tokens(8,:)))'+ log(prob(8,:));
	Ylog = [log_autos log_motorcycles log_baseball log_hockey log_guns log_mideast log_politics log_religion];
	[~, Ypredict] = max(Ylog,[],2);

	% Compute the error on the test set
	numdocs_wrong = 0;
	for i=1:mtest,
		if (Y(i)~=Ypredict(i))
			numdocs_wrong = numdocs_wrong + 1;
		end
	end
	fraction_wrong = numdocs_wrong/mtest;


	%Compute confusion matrix
	confusion = zeros(8);
	for i=1:mtest,
		confusion(Y(i),Ypredict(i)) = confusion(Y(i),Ypredict(i)) + 1;
	end
end