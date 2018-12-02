close all;
clear all;

% air_flow_rate = zeros(200,1);
% water_flow_rate = zeros(200,1);
% Qg = 0;
% Qf = 0;
% L = 12.3;
% D = 0.082;
% rho_air = 0.07;
% rho_water = 62.2;
% mu_water = 6e-4;
% g = 32.176;
% Area=3.14*(D^2)/4;
% alpha = 0.4;
% 
% i = 1;
% temp = 0;
% for j = 0.01 : 0.01 : 20
%     Qg = j;
%     for k = 0.001 : 0.001 : 200
%         Qf = k;
%         
%         vf = Qf/(rho_water*Area);
%         Re = vf*rho_water*D/mu_water;
%         
%         f = 64/Re;
%         
%         s=1.2+0.2*(Qg/Qf)+0.35*sqrt(g*D)/vf;
%         
%         k_factor = 4*f*L/D;
%         
%         LHS = alpha-(1/(1+(Qg/(Qf*s))));
%         RHS = (vf^2/(2*g*L))*((k_factor+1)+((k_factor+2)*(Qg/Qf)));
%         
%         if (abs(LHS-RHS) < 0.0005)
%             temp = Qf;
%             break;
%         end
%     end
%     water_flow_rate(i) = temp;
%     air_flow_rate(i) = Qg;
%     
%     i = i + 1;
% end
% plot(air_flow_rate, water_flow_rate);
% dlmwrite('stenning_water_s0_4.txt', water_flow_rate, 'delimiter', '\n');
%--------------------------------------------------------------------------

air_flow_rate = zeros(24,1);
water_flow_rate = zeros(24,1);

rho_water_SI = 1000; % SI
rho_air_SI = 1.225; % SI
CUBIC_METER_TO_CUBIC_FEET = 35.31; % conversion factor
air_flow_kph = dlmread('air_standard.txt', '\n'); % in kgph
disp(size(air_flow_kph))
amfr = air_flow_kph / 3600 ; % in kgps
avfr_SI = amfr / rho_air_SI ; % vfr in SI
avfr = avfr_SI * CUBIC_METER_TO_CUBIC_FEET ; % Imperial units

% Following are in Imperial Units
Qg = 0;
Qf = 0; 
L = 12.3;
D = 0.083;
alpha = 0.67; % dimensionless
mu_water = 1.423e-5;
g = 32.176;
Area=3.14*(D^2)/4;
rho_air = 0.07;
rho_water = 62.2;

i = 1;
temp = 0;
for j = 1 : 24
    Qg = avfr(j);
    for k = 0.01 : 0.0001 : 100
        Qf = k;
%         ------------------------        
%         vf = Qf./(rho_water.*Area);
%         Re = vf.*rho_water.*D./mu_water;
%         
%         f = 64./Re;
%         
%         s = 1.2+0.2.*(Qg./Qf)+0.35.*sqrt(g.*D)./vf;
%         k_factor = 4.*f.*L./D;
%         LHS = alpha-(1./(1+(Qg./(Qf.*s))));
%         RHS = (vf.^2/(2.*g.*L)).*((k_factor+1)+((k_factor+2).*(Qg./Qf)));
%         ------------------------

%         vf = Qf/(rho_water*Area);
        vf = Qf/Area;
        Re = vf*rho_water*D/mu_water;
        
        f = 64/Re;
        
        s = 1.2+0.2*(Qg/Qf)+0.35*sqrt(g*D)/vf;
        
        k_factor = 4*f*L/D;
        
        LHS = alpha-(1/(1+(Qg/(Qf*s))));
        RHS = (vf^2/(2*g*L))*((k_factor+1)+((k_factor+2)*(Qg/Qf)));

        
        if (abs(LHS-RHS) < 0.001)
            temp = Qf;
            break;
        end
    end
    
     water_flow_rate(i) = temp;
     air_flow_rate(i) = Qg;
     i = i + 1;
end
% plot(avfr, water_flow_rate);
% plot(avfr);

% -------- Convert water flow rate to mass flow rate in kgps ----------

wvfr_SI = water_flow_rate * 0.028; % cubic feet/s to cubic meter/s
wmfr = wvfr_SI * rho_water_SI;
water_standard = wmfr * 3600; % in kgps

plot(air_flow_kph, water_standard);
dlmwrite('stenning_water_standard.txt', water_standard, 'delimiter', '\n');