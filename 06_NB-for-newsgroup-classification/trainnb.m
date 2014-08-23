function [prob, prob_tokens] = trainnb (X, Y)
	
	mtrain = size(X,1);
	n = size(X,2);
	
	% Find the indices for the class labels
	autos_indices = find(Y == 1);
	motorcycles_indices = find(Y == 2);
	baseball_indices = find(Y == 3);
	hockey_indices = find(Y == 4);
	guns_indices = find(Y == 5);
	mideast_indices = find(Y == 6);
	politics_indices = find(Y == 7);
	religion_indices = find(Y == 8);

	% Calculate probability of labels
	prob_autos = length(autos_indices) / mtrain;
	prob_motorcycles = length(motorcycles_indices) / mtrain;
	prob_baseball = length(baseball_indices) / mtrain;
	prob_hockey = length(hockey_indices) / mtrain;
	prob_guns = length(guns_indices) / mtrain;
	prob_mideast = length(mideast_indices) / mtrain;
	prob_politics = length(politics_indices) / mtrain;
	prob_religion = length(religion_indices) / mtrain;
	prob = [prob_autos; prob_motorcycles; prob_baseball; prob_hockey; prob_guns; prob_mideast; prob_politics; prob_religion];

	% Sum the number of words in each article by summing along each row of X
	email_lengths = sum(X, 2);

	% Now find the total word counts of all the article of each class
	autos_wc = sum(email_lengths(autos_indices));
	motorcycles_wc = sum(email_lengths(motorcycles_indices));
	baseball_wc = sum(email_lengths(baseball_indices));
	hockey_wc = sum(email_lengths(hockey_indices));
	guns_wc = sum(email_lengths(guns_indices));
	mideast_wc = sum(email_lengths(mideast_indices));
	politics_wc = sum(email_lengths(politics_indices));
	religion_wc = sum(email_lengths(religion_indices));

	% Calculate the probability of the tokens in category articles
	% Now the k-th entry of prob_tokens_spam represents phi_(k|y=yi)
	prob_tokens_autos = (sum(X(autos_indices, :)) + 1) ./ (autos_wc + n);
	prob_tokens_motorycles = (sum(X(motorcycles_indices, :)) + 1) ./ (motorcycles_wc + n);
	prob_tokens_baseball = (sum(X(baseball_indices, :)) + 1) ./ (baseball_wc + n);
	prob_tokens_hockey = (sum(X(hockey_indices, :)) + 1) ./ (hockey_wc + n);
	prob_tokens_guns = (sum(X(guns_indices, :)) + 1) ./ (guns_wc + n);
	prob_tokens_mideast = (sum(X(mideast_indices, :)) + 1) ./ (mideast_wc + n);
	prob_tokens_politics = (sum(X(politics_indices, :)) + 1) ./ (politics_wc + n);
	prob_tokens_religion = (sum(X(religion_indices, :)) + 1) ./ (religion_wc + n);
	prob_tokens = [prob_tokens_autos; prob_tokens_motorycles; prob_tokens_baseball; prob_tokens_hockey; prob_tokens_guns; prob_tokens_mideast; prob_tokens_politics; prob_tokens_religion];
	
end