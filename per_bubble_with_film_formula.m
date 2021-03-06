rho_air = 1.225;
rho_water = 1000;
D = 0.0254;
R = D/2;
A = pi*D^2/4;
g = 9.81;
mu = 8.9e-4;
sigma = 7.28e-2;
alpha = 0.67;
Co = 1.2;
L = 3.75;

Bo = rho_water*g*(D^2)/sigma;
v_ts_dash = 0.352*(1 - 3.18*(Bo^-1) - 14.77*(Bo^-2));
v_ts = v_ts_dash*sqrt(g*D);

air_flow_kph = dlmread('air_standard.txt', '\n'); % in kgph
amfr = air_flow_kph / 3600 ; % in kgps
avfr = amfr / rho_air ; % vfr in SI
    
water_flow_rate = zeros(length(avfr),1);
syms Qf;
temp = 0;
tempo = 0;

for j = 1: length(avfr)
    Qg = avfr(j);
    vm = (Qg + Qf)/A;
    epsilon = Qg/((Co*vm + v_ts)*A);
    sqeq = sqrt(epsilon);
    delta = R*(1-sqeq);
    vg = Co*vm + v_ts;
    %s = 1.2+0.2*(Qg/Qf)+(0.35*sqrt(g*D)/(Qg/A));
    %s = 1.2+0.2*(Qg/Qf);
    
    %u_ltb = vpa(9.916*sqrt(g*D*(1-sqeq)));
    u_ltb = vpa(0.333*g*rho_water*(delta^2)/mu);
    
    eqn = Qf == (pi*(R^2)*(Qf/A)) - (2*pi*R*delta*u_ltb);
    temp = solve(eqn, Qf);
    tempo = vpa(temp);
    water_flow_rate(j) = tempo;
end

water_standard = water_flow_rate*rho_water*3600;
plot(air_flow_kph, water_standard);