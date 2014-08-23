Machine Learning
===============
Matlab implementation of Machine Learning algorithms


Author
------
Rishi Dua <http://github.com/rishirdua>


Disclaimer
-----------
- The problem below has been borrowed (with minor changes) from the Introduction to Machine Learning course offered by Dr. Parag Singla at IIT Delhi (Fall 2013 Semester).
- The codes in this repository might have been modified from my original submission for the CSL341 Introduction to Machine Learning at IIT Delhi.

Problem 1: Logistic Regression
------------------------------
- The files q1x.dat and q1y.dat contain the inputs x and outputs y respectively for a binary classification problem, with one training example per row. Implement Newton’s method for optimizing log likelihood and apply it to fit a logistic regression model to the data. Initialize Newton’s method with the vector of all zeros.
- Plot the training data (your axes should be x1 and x2 , corresponding to the two coordinates of the inputs, and you should use a different symbol for each point plotted to indicate whether that example had label 1 or 0). Also plot on the same figure the decision boundary fit by logistic regression. (i.e., this should be a straight line showing the boundary separating the region where h(x) > 0.5 from
the rest.


Problem 2: Locally Weighted Linear Regression
---------------------------------------------
Consider a linear regression problem in which we want to weigh different training examples differently. In the above setting, the cost function can also be written
$J(\theta) = (X\theta − y)^T W (X\theta − y)$
for an appropriate diagonal matrix W. By finding the derivative
and setting that to zero, generalize the normal equation to this weighted setting, and find the value of \theta that minimizes the cost function in closed form as a function of X, W and y. The files q2x.dat and q2y.dat contain the inputs (x(i)) and outputs and q2y.dat(y(i)), respectively, fuor a regression problem, with one training example per row.
- Implement (unweighted) linear regression on this dataset using the normal equations, and plot on the same figure the data and the straight line resulting from your fit.
- Implement locally weighted linear regression on this dataset using the weighted normal equations, and plot on the same figure the data and the curve resulting from your fit. When evaluating, use weights
$w(i) = exp (-\frac{(x − x(i))^2}{2\tau^2})$
with a bandwidth parameter \tau = 0.8.
- Repeat with bandwidth parameter = 0.1, 0.3, 2 and 10


Problem 3: Linear Regression with Polynomial Basis Functions
------------------------------------------------------------
We ignore the last feature (car name) for this problem. The goal is to predict miles per gallon (mpg), given the values of remaining seven features. We will use the first 100 points as the training data and the remainder as the test data. You can ignore any examples with missing values for any of the features.

Implement linear regression with polynomial basis functions. Given the input feature vector x = (x1 , x2 · · · x7 ), define a polynomial basis function of degree d where we consider only the terms for each variable independently. In other words, we define our basis function as
\phi(x) = (x0 , x1 , x1^2 , x1^3 · · · x1^d , x2 , x2^2 , x2^3 · · · x2^d · · · x7 , x7^2 , x7^3 · · · x7^d). Here, x0 denotes the intercept
term. For each of the parts below, you should normalize your data (both training and testing together) so that each feature has zero mean and unit variance. Remember to do the normalization each time you learn a model for a different d.

- Implement linear regression over the polynomial basis function defined above to learn a model for this problem. Vary the value of d from 1 to 10. Use stochastic gradient descent to learn the parameters. Plot the train and test set accuracies with varying values of d.
Note: It is ok if you find that your algorithm does not converge for certain (high) values of d.
- For each of the above cases, find the value of the parameters directly using the closed form expression. Compare with what you obtained using stochastic gradient descent.
- In order to visualize the data well (and for convergence), use only one of the features (horsepower) and again perform linear regression over the polynomial basis function defined over this single input feature. Make sure to include the intercept term. Use stochastic gradient descent to learn the parameters. Plot the training as well as test set accuracies with varying d from 1 to 10. Note: You may want to verify the correctness of the parameters learnt by directly finding them using the closed form solution.
- For the models learned, plot the training data points, learned polynomial, and test data points.
- One of the ways to keep the weights from growing too large is to include a quadratic penalty term in the cost function. Implement L2 -regularized regression. Using only one of the features (horsepower) as
earlier, fit a degree 8 polynomial and find the parameters using stochastic gradient descent. Use y = { 0.01, 0.1, 1, 10, 100, 1000 }. Plot the training as well as test set accuracies for varying γ (plot γ on a log scale)
- Find the best value of γ using 5-fold cross validation
over the training data. For the best value of the γ obtained obtained using cross-validation, report the average validation set and test set accuracies. Plot training data points, learned degree 8 polynomial
(for the best γ obtained using cross-validation) and test data points. Also, plot the learned degree 8 polynomial when γ = 0 on the same graph

Problem 4: Spam classification
------------------------------
In this problem, we will use perceptron and SVM training algorithms to build a spam classifier. The dataset we will be using is a subset of 2005 TREC Public Spam Corpus. It contains a training set and a test set. Both files use the same format: each line represents the space-delimited properties of an email, with the first one being the email ID, the second one being whether it is a spam or ham (non-spam), and the rest are words and their occurrence numbers in this email. The dataset presented to you is processed version of the original dataset where non-word characters have been removed and some basic feature selection has been done.
- Implement the perceptron training algorithm to classify spam (use the delta training rule. Learn the model on the training examples and report the accuracy on the test set.
- Vary the number of examples used in training from 1000 to 9000 at the interval of 1000 and plot on a graph the test set accuracies (y-axis) as you vary the number of training examples (x-axis) for the two algorithms. This is called a learning curve.
- Train an SVM on this dataset using the LibSVM library. Convert the data into the format required by LibSVM and train a linear SVM. You can use the default set of parameters that come with the package. Report the accuracies on the test set. Write the wrapper code in any language
- For SVMs, find the number of support vectors output by your algorithm and find out 5 support vectors with the highest values of \alpha for each class (spam/not spam)
- Calculate the distance of the support vectors from the hyperplane
- Now train an SVM using the RBF kernel (provided in the package) over all of the 9000 training examples. Use the default settings of parameters. Report the test set accuracies.
- Normalize your data (both training and testing together) to have zero mean and unit variance for each of the features. Again train an SVM using the RBF kernel. Report the test set accuracies.
- Vary the value of the γ parameter in the RBF kernel in the range going from 0.00010 to 0.00100 at intervals of 0.00005. For each value of γ, train on all the 9000 examples in the training set and report the test set accuracies. Which value of γ gives best results on the test set? Note: The principled way to select γ would be to use cross-validation as done in Question 3, though we are not doing it here to save the computational time involved.


Problem 5: Decision Trees for Classification
--------------------------------------------
Build a decision tree which would learn a model to predict whether a US congressman is democrat or republican based their voting pattern on various issues
- Construct a decision tree using the given data to classify a congressman as democrat or republican. Use net error as the criterion for choosing the attribute to split on. In case of a tie, choose the attribute with the lowest index as the splitting attribute. For now, you can treat the missing values (”?”) simply as another attribute value. Consider splitting each attribute using a 3-way split i.e. using the values y/n/”?” 3 Plot the train, validation and test set accuracies against the number of nodes in the tree as you grow the tree. On X-axis you should plot the number of nodes in the tree
and Y-axis should represent the accuracy.
- Repeat the part above using the information gain as the criterion. Again plot the train, validation and test set accuracies as you grow the tree.
- One of the ways to reduce overfitting in decision trees is to grow the tree fully and then use post-pruning based on a validation set. In post-pruning, we greedily prune the nodes of the tree (and sub-tree below them) by iteratively picking a node to prune so that resultant tree gives maximum increase in accuracy on the validation set. In other words, among all the nodes in the tree, we prune the node such that pruning it (and sub-tree below it) results in maximum increase in accuracy over the validation set. This is repeated until any further pruning leads to decrease in accuracy over the validation set. Post prune the tree obtained in step (b) above using the validation set. Again plot the the training, validation and test set accuracies against the number of nodes in the tree as you successively prune the tree.


Problem 6: Naive Bayes for Newsgroup Classification
---------------------------------------------------
The data and its description is available through the UCI data repository. We have processed the data further to remove punctuation symbols, stopwords etc. The processed dataset contains the subset of the articles in the newsgroups rec.* and talk.*. This corresponds to a total of 7230 articles in 8 different newsgroups. The processed data is made available to you in a single file with each row representing one article. Each row contains the information about the class of an article followed by the list of words appearing in the article.

- Implement the Naive Bayes algorithm to classify each of the articles into one of the newsgroup categories. Randomly divide your data into 5 equal sized splits of size 1446 each. Now, perform 5-fold cross validation and report average test set accuracies. Note: Make sure to use the Laplace smoothing to avoid any zero probabilities and implement your algorithm using logarithms to avoid underflow issues.
- What is the accuracy that you would obtain by randomly guessing one of the newsgroups as the target class for each of the articles. How much improvement does your algorithm give over a random prediction?
- Some (4% in the original data) of the articles were cross-posted i.e. posted on more than one newsgroup. Does it create a problem for the learner? Explain in comments in code.
- For each of the train/test splits in part (a) above, vary the number of articles used in training from 1000 to 5784 (training split size) at the interval of 1000 and evaluate on the test split (sized 1446). Plot on a graph the train as well as the test set accuracies (y-axis) averaged over the 5 random splits, as you vary the number of training examples (x-axis).
- Draw the confusion matrix for your results in the part (a) above.


Problem 7: K-means for Digit Recognition
----------------------------------------
In this problem, you will be working with a subset of the OCR (optical character recognition dataset) from the Kaggle website. Each of the images in the dataset is represented by a set of 784 (28 × 28) grayscale pixel values varying in the range [0, 255]. The data was further processed 4 so that it could be easily used to experiment with K-means clustering. The processed dataset contains 1000 images for four different (1, 3, 5, 7) handwritten digits. Each image is represented by a sequence of 157 grayscale pixel values (a subset of the original 784 pixel values). A separate file is provided which contains the actual digit value for each of the images.
- Write a program to visualize the digits in the data. Your script should take an example index and display the image corresponding to the gray scale pixel values. You can assume a grayscale value of 0 for the pixel values not present in the file.
- Implement the k-means (k = 4) clustering algorithm until convergence to discover the clusters in the data. Start from an initial random assignment of the cluster means. You can stop at 30 iterations if you find that the algorithm has still not converged.
- One of the ways to characterize the “goodness” of the clusters obtained is to calculate the sum of squares of distance of each of the data points x(i) from the mean of the cluster it is assigned to cluster that x(i) belongs to. Plot this quantity as we vary the number of iterations from 1 to 20. 
- For each cluster obtained at a given step of k-means, assign to the cluster the label which occurs most frequently in the examples in the cluster. The remaining examples are treated as misclassified. Plot the error (ratio of the number of mis-classified examples to the total number of examples) as we vary the number of iterations from 1 to 20.

Contribute
----------
- Issue Tracker: https://github.com/rishirdua/machine-learning/
- Source Code: https://github.com/rishirdua/machine-learning/
- Project page: http://rishirdua.github.io/machine-learning/


License
-------
This project is licensed under the terms of the MIT license. See LICENCE.txt for details
