close all;
clear all;
P_a=101325;
P_in= 2.7e5;
eff=zeros(50);
G = zeros(50);
W = zeros(50);
L=2.75 ;
D=0.025 ;
Area=3.14*(D^2)/4;
e= 0.004e-3;
rho=1000;
mu=0.85e-3;
H= 1.331;
i = 1;
for N=.1:0.1:5
    F_g=0.00055555*N;
for M=1:1:1200
F_w=M/(3600);

V_w=F_w/(rho*Area);
Re=rho*V_w*D/mu;

if(Re<2300)
    f=64/Re;
else
    F=@colebrook;
    f=F(Re,(e/D));
end


Q_w=F_w/1000;
Q_g=F_g/1.2;
s=1.2+0.2*(Q_g/Q_w)+0.35*sqrt(9.8*D)/V_w;
K=4*f*L/D;
LHS=H/L-(1/(1+(Q_g/(Q_w*s))));
RHS=(V_w^2/(2*9.8*L))*((K+1)+((K+2)*(Q_g/Q_w)));
% Mat(M)=(LHS-RHS);
if (abs(LHS-RHS)<0.001)
    break
end
end
G(i) = F_g*3600;
W(i) = M;
eff(i)=(rho*9.8*Q_w*(L-H))/(P_a*Q_g*log(P_in/P_a));
i = i+1;
end
plot(G,W);
%plot(G,eff);