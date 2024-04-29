function [x,varargout]=minL1lin_rev(C,d,varargin)
% This function is a minor modification to minL1lin by Matt J (2020). 
% Matt J (2020). Constrained minimum L1-norm solutions of linear equations 
% (https://www.mathworks.com/matlabcentral/fileexchange/52795-constrained-minimum-l1-norm-solutions-of-linear-equations), 
% MATLAB Central File Exchange. version 1.1.0.3 (2020/5/9)
% 
% minL1lin_rev finds the  minimum L1-norm solution of the linear equations C*x=d, 
% optionally under linear constraints. It is similar to the Optimization Toolbox's lsqlin except that it minimizes with 
% respect to the L1 norm by reformulating the problem as a linear program. The input/output syntax,
%  
%    [x,resnorm,residual,exitflag,output,lambda] = 
%           minL1lin_rev(C,d,A,b,Aeq,beq,lb,ub,options)
%  
%  is the same as for lsqlin() and all the usual defaults for A,b,.. from
%  lsqlin apply here. However, the "options" are those of linprog() which is used 
%  internally. And, of course, the minimization is instead over norm(C*x-d,1)
%  rather than norm(C*x-d,2).
%
% Modified by Toshiyuki Ohtsuka to omit x0, Nov. 2023
%

if length(varargin)<7
   varargin(end+1:7)={[]}; 
end

[A,b,Aeq,beq,lb,ub,options]=deal(varargin{:});

%disp(varargin);
%disp(options);

[m,n]=size(C);

    
    f=[zeros(1,n), ones(1,m)];
    
   
    Ax=[C,-speye(m);-C,-speye(m)];
    bx=[d;-d];

  [~,nx]=size(Ax);   
 
    LB(1:nx)=-inf; 
       LB(n+1:end)=0;
    UB(1:nx)=inf;

    LB(1:length(lb))=lb;
    UB(1:length(ub))=ub;
    
    if ~isempty(A)
       A(end,nx)=0;
    end
    
    if ~isempty(Aeq)
       Aeq(end,nx)=0;
    end
    
    A=[A;Ax]; b=[b;bx];
    
   
%    [xz,~, varargout{3:nargout-1}]=linprog(f,A,b,Aeq,beq,LB,UB,options);
    [xz,~, varargout{3:nargout-1}]=linprog(f,A,b,Aeq,beq,LB,UB);

    
    if ~isempty(xz)
     x=xz(1:n);
    else
      x=xz;
      varargout(1:2)={[],[]}; 
      return
    end
    
    
    if nargout>=2 %truncate resnorm if requested
       residual=C*x-d;
       resnorm=norm(residual,1);
       varargout(1:2)={resnorm,residual}; 
    end
    
    
