function [newtree, finished, newerr] = removebest (Xvalidate, Yvalidate, tree)
nodeindices = find(tree(:,1)>0);
size(nodeindices)
Yinfogain = predicttree(tree,Xvalidate) + 2;
original_error = 0;
for i=1:size(Yvalidate,1)
	if (Yinfogain(i)~=Yvalidate(i))
		original_error = original_error + 1;
	end
end
original_error = original_error/size(Yvalidate,1);
newerror_combined = [];
for k=1:size(nodeindices,1)
	temp_tree  = tree;
	temp_tree(nodeindices(k),1) = temp_tree(nodeindices(k),8);
	temp_tree(nodeindices(k),2) = 0;
	temp_tree(nodeindices(k),3) = 0;
	temp_tree(nodeindices(k),4) = 0;
	temp_tree(nodeindices(k),5) = 0;
	temp_tree(nodeindices(k),6) = 0;
	temp_tree(nodeindices(k),7) = 0;
	temp_tree(nodeindices(k),8) = 0;
	Ytemp = predicttree(temp_tree,Xvalidate) + 2;
	new_error = 0;
	for i=1:size(Yvalidate,1)
		if (Ytemp(i)~=Yvalidate(i))
			new_error = new_error + 1;
		end
	end
	new_error = new_error/size(Yvalidate,1);
	newerror_combined = [newerror_combined, new_error];
end
if(min(newerror_combined)<=original_error)
	[newerr,ind] = min(newerror_combined);
	torem = nodeindices(max(ind))
	newtree = tree;
	newtree(torem,1) = tree(torem,8);
	newtree(torem,2) = 0;
	newtree(torem,3) = 0;
	newtree(torem,4) = 0;
	newtree(torem,5) = 0;
	newtree(torem,6) = 0;
	newtree(torem,7) = 0;
	newtree(torem,8) = 0;
	newerr
	finished = 0;
else
	newtree = tree;
	newerr = original_error
	finished = 1;
end