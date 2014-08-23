function [means, Scombined, errorcombined] = Kmean(X,num_clusters, Y)
	%Choosing any random num_clusters points from the Data to be centres
	tolerance = 0.000001;
	iter_limit = 30;
	m = size(X,1);
	n = size(X,2);
	Jumbled_Data = X(randperm(m),:);
	means = Jumbled_Data(1:num_clusters,:);  %Randomly initialize the centroids of each cluster
	Dist_Mat = zeros(m,num_clusters);
	Scombined=[];
	errorcombined = [];
	for iter=1:iter_limit
	sum_pts_each_cluster = zeros(size(means));
		num_pts_each_cluster = zeros(num_clusters,1);
		S = 0;
		label1 = [];
		label2 = [];
		label3 = [];
		label4 = [];
		for i = 1:m
			for j = 1:num_clusters
				Dist_Mat(i,j) = norm(X(i,:) - means(j,:)); %This matrix computes the distance of each data point from each of the centroids
			end
			cluster_number = find_which_cluster(Dist_Mat(i,:));
			sum_pts_each_cluster(cluster_number,:) = sum_pts_each_cluster(cluster_number,:) + X(i,:);
			num_pts_each_cluster(cluster_number) = num_pts_each_cluster(cluster_number) + 1;
			S = S + Dist_Mat(i,cluster_number);
			if (cluster_number==1)
				label1 = [label1, Y(i)];
			elseif (cluster_number==2)
				label2 = [label2, Y(i)];
			elseif (cluster_number==3)
				label3 = [label3, Y(i)];
			else
				label4 = [label4, Y(i)];
			end
		end
		Ylabels = [mode(label1); mode(label2); mode(label3); mode(label4)];
		errorp = 0;
		for i = 1:m
			for j = 1:num_clusters
				Dist_Mat(i,j) = norm(X(i,:) - means(j,:)); %This matrix computes the distance of each data point from each of the centroids
			end
			cluster_number = find_which_cluster(Dist_Mat(i,:));
			if (Y(i)~=Ylabels(cluster_number))
				errorp = errorp+1;
			end
		end
		errorp = errorp/m;
		means_new = sum_pts_each_cluster./(num_pts_each_cluster*ones(1,n));
		if(sum(isnan(means)))
			break;
		end
		if(norm(means-means_new) < tolerance)
			break;
		end
		means = means_new;
		Scombined = [Scombined, S];
		errorcombined = [errorcombined, errorp];
	end
	
end

function cluster_number = find_which_cluster(Mat)
	cluster_number = 1;
	dist_min = Mat(1);
	for i = 1:length(Mat)
		if(Mat(i) < dist_min)
			dist_min = Mat(i);
			cluster_number = i;
		end
	end
end