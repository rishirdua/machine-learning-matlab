function errorcombined = steperror(X,Y,fulltree)
	m = size(X,1);
	Ycombined = [];
	errorcombined = [];
	for tillnode=1:size(fulltree)
		Ypredict = zeros(m,1);
		if (fulltree(tillnode,1)<0)
			continue
		else
		tree = fulltree(1:tillnode,:);
		if (m>0)
			for i=1:m,
				value = tree(1,1);
				nodeindex = 1;
				while (value>0)
					newnodeindex = tree(nodeindex,X(i,value)+5);
					if (newnodeindex>size(tree,1))
						newvalue = tree(nodeindex,8);
					else
						newvalue = tree(nodeindex,X(i,value)+2);
					end
					value = newvalue;
					nodeindex = newnodeindex;
				end
				Ypredict(i,1) = value+2;
				predict_error = 0;
				for j=1:size(Ypredict,1)
					if (Ypredict(j,1)~=Y(j,1))
						predict_error = predict_error + 1;
					end
				end
				predict_error = predict_error / size(Y,1);
			end
		end
		Ycombined = [Ycombined Ypredict];
		errorcombined = [errorcombined predict_error];
		end
	end
end