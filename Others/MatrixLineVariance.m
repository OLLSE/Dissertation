rec_var_p=zeros(100,1);
for i=1:100
    a=rec_p(i,1:200);
    rec_var_p(i)=var(nonzeros(a));
end