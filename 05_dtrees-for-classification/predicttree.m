function Y = predicttree(tree,X)
	m=size(X,1);
	Y = zeros(m,1);
	if (m>0)
		for i=1:m,
			value = tree(1,1);
			nodeindex = 1;
			while (value>0)
				newvalue = tree(nodeindex,X(i,value)+2);
				newnodeindex = tree(nodeindex,X(i,value)+5);
				value = newvalue;
				nodeindex = newnodeindex;
			end
			Y(i,1) = value;
		end
	end
end