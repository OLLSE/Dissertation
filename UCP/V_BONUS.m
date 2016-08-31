function bonus = V_BONUS(theta_0, beta_0, sigma_w_d, B_d , p_d)

% REALITY

    mu        = theta_0; % <- assume it is reality!
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
    
    % Return if Budget is insufficient
    if B<p_min
        bonus=0;
        return
    end
        

    % PRIOR KNOWLEDGE

    theta_est = theta_0;
    beta_est  = beta_0;

    % FIRST CHOICE: HIGHEST KG WITHIN BUDGET

    v=KG_RS_ST(theta_est,1./beta_est,1./beta_w);
    
    v_max=0;
    choice(1)=1;
    for i=1:M
        if v(i)>=v_max && B-p(i)>=0
            v_max=v(i);
            choice(1)=i;
        end
    end
    
    % Return to policy if no saving anyways
    if p(choice(1))==p_max
        bonus=0;
        return
    end
        
% ITERATIONS n>1       
    
    n=2;
     
    while B-p_min >=0
        
       % OBSERVE
       
       w(choice(n-1),n)       = mu(choice(n-1));
       
       % UPDATE KNOWLEDGE
       
       theta_est(choice(n-1)) = (beta_est(choice(n-1))*theta_est(choice(n-1))+beta_w*w(choice(n-1),n))/(beta_est(choice(n-1))+beta_w);
       beta_est(choice(n-1))  = (beta_est(choice(n-1))+beta_w);

       % UPDATE BUDGET
       
       B            = B-p(choice(n-1));
       
       % NEXT CHOICE: HIGHEST KG WITHIN BUDGET

       v=KG_RS_ST(theta_est,1./beta_est,1./beta_w);

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
    
% BONUS CALCULATION

    v=KG_RS_ST(theta_est,1./beta_est,1./beta_w);
    bonus=max(v./p);

end