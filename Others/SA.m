clear

delta     =5;
sigma_est =1;
sigma_w   =1;
%%
for i=1:100
    n=i;

    sigma_tilde_m(n) = sqrt((sigma_est^2)*n/((sigma_w^2/sigma_est^2)+n));
    zeta(n)          = -abs(delta/sigma_tilde_m(n));
    f(n)             = zeta(n)*normcdf(zeta(n))+normpdf(zeta(n));
    a(n)             = sigma_tilde_m(n)*f(n) ;
end
%%
v(1)=a(1)
for j=2:10
    v(j)=a(j)-a(j-1)
end

