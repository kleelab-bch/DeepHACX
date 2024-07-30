function [ymean, com_ci, tsq_ci, bon_ci]=cfinterval(y,prob)
% Construct confidence intervals for individual components.
% Input y: data matrix  (n by p matrix)
%       prob: tail probability (two-sided)
%
% output: ci: Simultaneous T^2 confidence intervals
%
[nr,nc] = size(y);
if nr <= 1 
    stop;
end
ymean= nanmean(y);
dev = y-kron(ones(nr,1),ymean);
s=dev'*dev/(nr-1);
%sinv=inv(s);
title='C.I. based on marginal data'
com_ci=zeros(nc,2);
pr = 1-prob/2;
crit = tinv(pr,(nr-1));
for i=1:nc
    com_ci(i,1) = ymean(i)-crit*sqrt(s(i,i)/nr);
    com_ci(i,2) = ymean(i)+crit*sqrt(s(i,i)/nr);
end
%com_ci

title='C.I. based on T**2'
tsq_ci=zeros(nc,2);
pr = 1-prob;
crit = finv(pr,nc,(nr-nc));
crit = nc*(nr-1)*crit/(nr-nc);
for i=1:nc
    wk = sqrt(crit)*sqrt(s(i,i)/nr);
    tsq_ci(i,1)=ymean(i)-wk;
    tsq_ci(i,2)=ymean(i)+wk;
end
%tsq_ci
%ci=tsq_ci;

title='C.I. based on Bonferroni method'
pr = 1 -prob/(2*nc);
crit = tinv(pr,(nr-1));
bon_ci=zeros(nc,2);
for i=1:nc
    wk = crit*sqrt(s(i,i)/nr);
    bon_ci(i,1) = ymean(i) - wk;
    bon_ci(i,2) = ymean(i) + wk;
end
%bon_ci

