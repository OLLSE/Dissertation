function [B,M,theta_0,beta_0,p] = RD_PROBS_2(maxM)

% min_p=mean_p/spread;
% max_p=mean_p*spread;


% % NUMBER OF ALTERNATIVES
% M = 2+unidrnd(maxM-2);
% 
% % BUDGET
% a=rand;
% if a<1/3
%     B=M;
%     if B<max_p
%         B=max_p;
%     end
% end
% if a>=1/3 && a<2/3
%     B=3*M;
% end
% if a>=2/3
%     B=10*M;
% end



%BUDGET
B=1+unidrnd(maxM-1); %200 in sum

% ALL ALTERNATIVES
a=rand;
if a<1/3
    M=B;
end
if a>=1/3 && a<2/3
    M=1/3*B;
end
if a>=2/3
    M=1/10*B;
end

M=round(M);
if M<3
    M=3;
end

%EACH ALTERNATIVE
theta_0=zeros(1,M);
beta_0=zeros(1,M);
p=zeros(1,M);
for i=1:M
  %PRIOR MEAN
  theta_0(i)=2*rand-1;
  %PRIOR PRECISION
  a=rand;
    if a<0.9
        beta_0(i)=1;
    else
        beta_0(i)=1000;
    end
    
  %PRICES
  a=rand;
    if a<1/3
        p(i)=0.1;
    end
    if a>=1/3 && a<2/3
        p(i)=0.5;
    end
    if a>=2/3
        p(i)=1;
    end
end
end
