function [best_arm, theta_max, theta_est, b] = KGB(mu_d, theta_0, beta_0, sigma_w_d, B_d , p_d)

% REALITY

    mu        = mu_d;
    sigma_w   = sigma_w_d;
    beta_w    = 1/sigma_w;
    B         = B_d;
    p         = p_d;
    p_min     = min(p);
    p_max     = max(p);
    M         = length(theta_0);
    max_n     = ceil(B/p_min);
    choice    = zeros(1,max_n);
    w         = zeros(M,max_n);

% ITERATION 1 (0 in literature)
    
    % PRIOR KNOWLEDGE

    theta_est = theta_0;
    beta_est  = beta_0;

    % FIRST CHOICE: HIGHEST KG WITHIN BUDGET

    bonus=V_BONUS(theta_est, beta_est, sigma_w, B, p);
    frac=p_max-p;
    v=KG_RS_ST(theta_est,1./beta_est,1./beta_w)+frac.*bonus;
    b(1)=bonus;
    
    v_max=0;
    choice(1)=1;
    for i=1:M
        if v(i)>=v_max && B-p(i)>=0
            v_max=v(i);
            choice(1)=i;
        end
    end
        
% ITERATIONS n>1       
    n=2;
     
    while B-p_min >=0
        
       % OBSERVE
       
       w(choice(n-1),n)       = normrnd(mu(choice(n-1)),sigma_w);
       
       % UPDATE KNOWLEDGE
       
       theta_est(choice(n-1)) = (beta_est(choice(n-1))*theta_est(choice(n-1))+beta_w*w(choice(n-1),n))/(beta_est(choice(n-1))+beta_w);
       beta_est(choice(n-1))  = (beta_est(choice(n-1))+beta_w);

       % UPDATE BUDGET
       
       B            = B-p(choice(n-1));
       
       % NEXT CHOICE: HIGHEST KG WITHIN BUDGET
       
%        if v==0
%            bonus=0
%            v=KG_RS_ST(theta_est,1./beta_est,1./beta_w);
%        else
           bonus=V_BONUS(theta_est, beta_est, sigma_w, B, p);
           frac=p_max-p;
           v=KG_RS_ST(theta_est,1./beta_est,1./beta_w)+frac.*bonus;
%        end
       b(n)=bonus;

       v_max=0;
       choice(n)=1;
       for i=1:M
           if v(i)>=v_max && B-p(i)>=0
               v_max=v(i);
               choice(n)=i;            
           end
       end

       n=n+1;
    
    end
    
% RECOMMENDATION

[theta_max,best_arm]=max(theta_est);

end