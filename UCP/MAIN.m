clear

% SETUP
I=100;
J=1000;
p_mean=1;
p_spread=10;
maxM=200;

% PRE
rec_theta_0=zeros(I,maxM);
rec_beta_0=zeros(I,maxM);
rec_B=zeros(I,1);
rec_M=zeros(I,1);
rec_p=zeros(I,maxM);
rec_mu=zeros(I,J,maxM);
o_cost_KG=zeros(I,J);
o_cost_KGP=zeros(I,J);
o_cost_KGPT1=zeros(I,J);
o_cost_KGPT2=zeros(I,J);
o_cost_KGB=zeros(I,J);
rec_bonus=zeros(I,J,maxM);

for i=1:I %PROBLEMS (100)

    [B,M,theta_0,beta_0,p] = RD_PROBS(p_mean,p_spread,maxM);
    
%     B=5
%     M=5
%     theta_0=[-0.3,0.2,0,0.3,0.5]
%     beta_0=[1,1,1,1,1]
%     p=[0.1,1,0.1,1,0.1]
    
    rec_B(i)=B;
    rec_M(i)=M;
    rec_theta_0(i,1:M)=theta_0;
    rec_beta_0(i,1:M)=beta_0;
    rec_p(i,1:M)=p;
    
    fprintf('PROBLEM %d\n', i)

parfor j=1:J %SIMULATIONS PER PROBLEM (1000)
fprintf('PROBLEM %d, SIM %d:', i,j)
    %REALITY PER SIMULATION
    mu=normrnd(theta_0,1./beta_0);
    sigma_w=1;
    %rec_mu(i,j,1:M)=mu;
    
    % Apply KG
    [best_arm_KG, theta_max_KG, theta_est_KG] = KG(mu, theta_0, beta_0, sigma_w, B , p);
    o_cost_KG(i,j)=max(mu)-mu(best_arm_KG);
    fprintf(' KG')
    % Apply KGP
    [best_arm_KGP, theta_max_KGP, theta_est_KGP] = KGP(mu, theta_0, beta_0, sigma_w, B , p);
    o_cost_KGP(i,j)=max(mu)-mu(best_arm_KGP);
    fprintf(' KGP')  
    % Apply KGPT a=b a=100
    a=p_mean*p_spread^2;
    [best_arm_KGPT1, theta_max_KGPT1, theta_est_KGPT1] = KGPT(mu, theta_0, beta_0, sigma_w, B , p, a, a);
    o_cost_KGPT1(i,j)=max(mu)-mu(best_arm_KGPT1);
    fprintf(' KGPT100')      
    % Apply KGPT a=b a=10
    a=p_mean*p_spread;
    [best_arm_KGPT2, theta_max_KGPT2, theta_est_KGPT2] = KGPT(mu, theta_0, beta_0, sigma_w, B , p, a, a);
    o_cost_KGPT2(i,j)=max(mu)-mu(best_arm_KGPT2);
    fprintf(' KGPT10')     
    % Apply KGB
    [best_arm_KGB, theta_max_KGB, theta_est_KGB, bonus] = KGB(mu, theta_0, beta_0, sigma_w, B , p);
    o_cost_KGB(i,j)=max(mu)-mu(best_arm_KGB);
    %rec_bonus(i,j,1:length(bonus))=bonus;
    fprintf(' KGB \n')
end
end
%%
n_o_cost_KG=mean(o_cost_KG,2);
n_o_cost_KGP=mean(o_cost_KGP,2);
n_o_cost_KGPT1=mean(o_cost_KGPT1,2);
n_o_cost_KGPT2=mean(o_cost_KGPT2,2);
n_o_cost_KGB=mean(o_cost_KGB,2);

%%
s_o_cost_KG=sum(sum(o_cost_KG));
s_o_cost_KGP=sum(sum(o_cost_KGP));
s_o_cost_KGPT1=sum(sum(o_cost_KGPT1));
s_o_cost_KGPT2=sum(sum(o_cost_KGPT2));
s_o_cost_KGB=sum(sum(o_cost_KGB));

%%
a_KGP_KG=mean(o_cost_KG-o_cost_KGP,2);
a_KGPT1_KG=mean(o_cost_KG-o_cost_KGPT1,2);
a_KGPT2_KG=mean(o_cost_KG-o_cost_KGPT2,2);
a_KGB_KG=mean(o_cost_KG-o_cost_KGB,2);
a_KGP_0=mean(0-o_cost_KGP,2);
a_KG_0=mean(0-o_cost_KG,2);

%%
aa_KGP_KGB=mean(o_cost_KGB-o_cost_KGP,2);
aa_KGP_KGPT2=mean(o_cost_KGPT2-o_cost_KGP,2);

%%
aavg_KGP_KG=mean(a_KGP_KG);
aavg_KGB_KG=mean(a_KGB_KG);
aavg_KGPT1_KG=mean(a_KGPT1_KG);
aavg_KGPT2_KG=mean(a_KGPT2_KG);

%%
aavg_KGP_KGB=mean(aa_KGP_KGB);

%%
asd_KGP_KG=mean(a_KGP_KG);
asd_KGB_KG=mean(a_KGB_KG);
asd_KGPT1_KG=mean(a_KGPT1_KG);
asd_KGPT2_KG=mean(a_KGPT2_KG);
asd_KGP_KGB=mean(aa_KGP_KGB);

%%
avg_bonus=mean(rec_bonus,1);
avg_bonus=mean(avg_bonus,2);
aavg_bonus(1:200)=avg_bonus(1,1,1:200);

%%
MB=rec_M./rec_B;

%%
imp_KGB=a_KGB_KG./n_o_cost_KG;
imp_KGP=a_KGP_KG./n_o_cost_KG;
