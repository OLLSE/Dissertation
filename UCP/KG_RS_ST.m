%Stanard Knowledge Gradient for Independent Beliefs

function v = KG_RS_ST(theta_est, sigma_est, sigma_w)

M=length(theta_est);
sec_max=zeros(1,M);
sigma_tilde=zeros(1,M);
zeta=zeros(1,M);
f=zeros(1,M);
v=zeros(1,M);

for x=1:M
    sec_max(x)=0 ;
    for y=1:M
        if (theta_est(y) >= sec_max(x)) && (x~=y)
          sec_max(x)=theta_est(y);
        end
    end
end

for x=1:M
    sigma_tilde(x) = sqrt(sigma_est(x)^2/(1+sigma_w^2/sigma_est(x)^2));
    zeta(x)        = -abs((theta_est(x)-sec_max(x))/sigma_tilde(x));
    f(x)           = zeta(x)*normcdf(zeta(x))+normpdf(zeta(x));
    v(x)           = sigma_tilde(x)*f(x);
end

end