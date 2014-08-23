function growntree = growtree(SX, SY, criteria)
	m = size(SY,1);
	n = size(SX,2);
	%empty
	if (m==0)
		growntree = [];
	%completely classified
	elseif (sum(SY,1)==0)
		growntree = [-2 0 0 0 0 0 0 0];
	elseif (sum(SY,1)==m)
		growntree = [-1 0 0 0 0 0 0 0];
	%only one feature left
	elseif (n==1)
		if (mode(SY)==0)
			growntree = [-2 0 0 0 0 0 0 0];
		else
			growntree = [-1 0 0 0 0 0 0 0];
		end
	else
		if (strcmp(criteria, 'minerror'))
			xj = getbest_minerror(SX, SY);
		elseif (strcmp(criteria, 'infogain'))
			xj = getbest_infogain(SX, SY);
		end
		% get index of xj
		jindex = 0;
		for j=1:size(SX,2),
			if (SX(1,j)==xj)
				jindex = j;
			end
		end
		
		% remove that collumn
		if (jindex==1)
			newSX = SX(:,2:n);
		elseif (jindex==n)
			newSX = SX(:,1:n-1);
		else
			newSX = [SX(:,1:jindex-1),SX(:,jindex+1:n)];
		end
		
		S0X = newSX(1,:);
		S0Y = [];
		S1X = newSX(1,:);
		S1Y = [];
		S2X = newSX(1,:);
		S2Y = [];
		
		m = size(SY,1);
		for i=1:m,
			if (SX(i+1,jindex)==0)
				S0X  = [S0X;newSX(i+1,:)];
				S0Y  = [S0Y;SY(i,:)];
			end
			
			if (SX(i+1,jindex)==1)
				S1X  = [S1X;newSX(i+1,:)];
				S1Y  = [S1Y;SY(i,:)];
			end
			
			if (SX(i+1,jindex)==2)
				S2X  = [S2X;newSX(i+1,:)];
				S2Y  = [S2Y;SY(i,:)];
			end
		end
		
		growntree = newnode (xj, growtree(S0X, S0Y, criteria), growtree(S1X, S1Y, criteria), growtree(S2X, S2Y, criteria), mode(SY));
	end
end

function tree = newnode(x, tree0, tree1, tree2, mode_y)
	m0 = size(tree0,1);
	m1 = size(tree1,1);
	m2 = size(tree2,1);
	
	tree = zeros(1,8);
	tree(1,1) = x;
	if(m0~=0)
		for i=1:m0,
			if (tree0(i,1)>0)
				tree0(i,5)=tree0(i,5)+1;			
				tree0(i,6)=tree0(i,6)+1;
				tree0(i,7)=tree0(i,7)+1;
			end
		end
		tree(1,2) = tree0(1,1);
		tree(1,5) = 2;
		tree = [tree; tree0];
	else
		tree(1,2) = mode_y-2;
		tree(1,5) = 0;
	end
	
	if(m1~=0)
		for i=1:m1,
			if (tree1(i,1)>0)
				tree1(i,5)=tree1(i,5)+1+m0;
				tree1(i,6)=tree1(i,6)+1+m0;
				tree1(i,7)=tree1(i,7)+1+m0;
			end
		end
		tree(1,3) = tree1(1,1);
		tree(1,6) = 2+m0;
		tree = [tree; tree1];
	else
		tree(1,3) = mode_y-2;
		tree(1,6) = 0;
	end
	
	if(m2~=0)
		for i=1:m2,
			if (tree2(i,1)>0)
				tree2(i,5)=tree2(i,5)+1+m0+m1;
				tree2(i,6)=tree2(i,6)+1+m0+m1;
				tree2(i,7)=tree2(i,7)+1+m0+m1;
			end
		end
		tree(1,4) = tree2(1,1);
		tree(1,7) = 2+m0+m1;
		tree = [tree; tree2];
	else
		tree(1,4) = mode_y-2;
		tree(1,7) = 0;
	end
	tree(1,8) = mode_y-2;
end
		

function bestfeature = getbest_minerror(X,Y)
	error = zeros(1,size(X,2));
	for  j=1:size(X,2),
		S0X = X(1,:);
		S0Y = [];
		S1X = X(1,:);
		S1Y = [];
		S2X = X(1,:);
		S2Y = [];
		for i=1:size(Y,1),
			if (X(i+1,j)==0)
				S0X  = [S0X;X(i+1,:)];
				S0Y  = [S0Y;Y(i,:)];
			end
			
			if (X(i,j)==1)
				S1X  = [S1X;X(i+1,:)];
				S1Y  = [S1Y;Y(i,:)];
			end
			
			if (X(i,j)==2)
				S2X  = [S2X;X(i+1,:)];
				S2Y  = [S2Y;Y(i,:)];
			end
		end
		
		
		J0=0;
		J1=0;
		J2=0;
		
		if (size(S0Y,1)>0)
			y0 = mode(S0Y);
			for i=1:size(S0Y,1),
				if (S0Y(i,1)~=y0)
					J0 = J0 + 1;
				end
			end
		end
		
		if(size(S1Y,1)>0)
			y1 = mode(S1Y);
			for i=1:size(S1Y,1),
				if (S1Y(i,1)~=y1)
					J1 = J1 + 1;
				end
			end
		end
		
		if (size(S2Y,1)>0)
			y2 = mode(S2Y);
			for i=1:size(S2Y,1),
				if (S2Y(i,1)~=y2)
					J2 = J2 + 1;
				end
			end
		end
		
		error (j) = J0 + J1 + J2;
	end
	bestfeature = 1;
	minerror = 100000;
	for k=1:size(X,2),
		if error(k)<minerror
			minerror = error(k);
			bestfeature = X(1,k);
		end
	end
end


% py = probability y
% px0 = probability x=0
% px1 = probability x=1
% px2 = probability x=2
% pyx0 = probability y|x=0
% pyx1 = probability y|x=1
% pyx2 = probability y|x=2
function bestfeature = getbest_infogain(X,Y)
	for  j=1:size(X,2),
		py = sum(Y,1)/size(Y,1);
		S0X = X(1,:);
		S0Y = [];
		S1X = X(1,:);
		S1Y = [];
		S2X = X(1,:);
		S2Y = [];
		nx0=0; nx1=0; nx2=0;
		for i=1:size(Y,1),
			if (X(i+1,j)==0)
				nx0 = nx0 + 1;
				S0X  = [S0X;X(i+1,:)];
				S0Y  = [S0Y;Y(i,:)];
			end
			
			if (X(i,j)==1)
				nx1 = nx1 + 1;
				S1X  = [S1X;X(i+1,:)];
				S1Y  = [S1Y;Y(i,:)];
			end
			
			if (X(i,j)==2)
				nx2 = nx2 + 1;
				S2X  = [S2X;X(i+1,:)];
				S2Y  = [S2Y;Y(i,:)];
			end
		end
		
		px0 = nx0 / size(Y,1);
		px1 = nx1 / size(Y,1);
		px2 = nx2 / size(Y,1);
		
		pyx0 = sum(S0Y,1)/size(S0Y,1);
		pyx1 = sum(S1Y,1)/size(S1Y,1);
		pyx2 = sum(S2Y,1)/size(S2Y,1);
		
		IG(j) = myentropy(py);
		if (px0>0)
			IG(j) = IG(j) - px0*myentropy(pyx0);
		end
		if (px1>0)
			IG(j) = IG(j) - px1*myentropy(pyx1);
		end
		if (px2>0)
			IG(j) = IG(j) - px2*myentropy(pyx2);
		end
	end
	bestfeature = 1;
	maxgain = 0;
	for k=1:size(X,2),
		if (IG(k)>maxgain)
			maxgain = IG(k);
			bestfeature = X(1,k);
		end
	end
end

function val = myentropy(p)
	if (p==0)
		val = 0;
	elseif (p==1)
		val = 0;
	else
		val = -( p * log(p) + (1-p) * log(1-p) );
	end
end