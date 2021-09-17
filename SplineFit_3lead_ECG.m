function [feature_spline, R_peak_num] = SplineFit_3lead_ECG(signal, samplingrate, windowsize, DataNumber, typeString, ECG_data, lead_I)

TF = []; VF_Vx = []; VF_Vy = []; VF_Vz = [];
R_peak = []; out = []; lead = [];


lead = signal;
lead_I = lead_I;

%-----finding R peak-----%
M = lead_I;
[~,R_peak,~] = pan_tompkin(M,samplingrate,0);

for j = 1:length(R_peak)
    range = ceil(0.03*samplingrate);
    peakPeriod = R_peak(j)-range:R_peak(j)+range;
    peakPeriod(peakPeriod<=0) = [];
    peakPeriod(peakPeriod>length(M)) = [];
    peakSegment = M(peakPeriod);
    [~,idx] = max(peakSegment-min(M));
    R_peak(j) = peakPeriod(idx);
end
R_peak_num = length(R_peak);
%----------end-----------%


%-----Normalize each cycle to 400 sample points-----%
temp = []; peak_period =[]; 
Lead_Vx = []; Lead_Vy = []; Lead_Vz = [];
for i = 1:(length(R_peak)-1)
    temp = lead(:,R_peak(i):R_peak(i+1)-1);
    peak_period(i) = length(temp);
    y = 1:peak_period(i);
    z = 1:((peak_period(i)-1)/(windowsize-1)):peak_period(i);              
    target = temp(1,:);
    target2 = temp(2,:);
    target3 = temp(3,:);

    Lead_Vx(i,:) = interp1(y,target,z,'spline');% cycles*sample pnt 
    Lead_Vy(i,:) = interp1(y,target2,z,'spline');% cycles*sample pnt 
    Lead_Vz(i,:) = interp1(y,target3,z,'spline');% cycles*sample pnt
end
%-------------------------end-----------------------%

%-----Normalize time factor-----%
scale_time = peak_period./400;
TF = [TF scale_time]; % save time factor
%---------------end-------------%


%-----Normalize voltage for Lead Vx-----% 
temp = []; Max = []; Min = []; scale_vol_Vx = [];
for i = 1:length(peak_period)
    Max(i) = max(Lead_Vx(i,:));
    Min(i) = min(Lead_Vx(i,:));
    for j = 1:windowsize
        temp(i,j) = (Lead_Vx(i,j)-Min(i))/(Max(i)-Min(i));
        Lead_Vx(i,j) = temp(i,j);
    end
    scale_vol_Vx(i) = Max(i)-Min(i);    
end  
VF_Vx = [VF_Vx scale_vol_Vx];

%-----Normalize voltage for Lead Vy-----%
temp = []; Max = []; Min = []; scale_vol_Vy = [];
for i = 1:length(peak_period)
    Max(i) = max(Lead_Vy(i,:));
    Min(i) = min(Lead_Vy(i,:));
    for j = 1:windowsize
        temp(i,j) = (Lead_Vy(i,j)-Min(i))/(Max(i)-Min(i));
        Lead_Vy(i,j) = temp(i,j);
    end
    scale_vol_Vy(i) = Max(i)-Min(i);  
end  
VF_Vy = [VF_Vy scale_vol_Vy];

%-----Normalize voltage for Lead Vz-----%
temp = []; Max = []; Min = []; scale_vol_Vz = [];
for i = 1:length(peak_period)
    Max(i) = max(Lead_Vz(i,:));
    Min(i) = min(Lead_Vz(i,:));
    for j = 1:windowsize
        temp(i,j) = (Lead_Vz(i,j)-Min(i))/(Max(i)-Min(i));
        Lead_Vz(i,j) = temp(i,j);
    end
    scale_vol_Vz(i) = Max(i)-Min(i);  
end  
VF_Vz = [VF_Vz scale_vol_Vz];
%---------------------------------------%


% Each beat to fit spline
x1 = linspace(1/windowsize,1,windowsize);
Spline_Vx = []; Spline_Vy = []; Spline_Vz = [];
Vxfit = []; Vyfit = []; Vzfit = [];

for i = 1:length(peak_period)
    %----Spline fitting-----%
    spX = spap2(5, 12, x1, Lead_Vx(i,:)) %spline fit
    Spline_Vx(i,:) = spX.coefs;
    spY = spap2(5, 12, x1, Lead_Vy(i,:)) %spline fit
    Spline_Vy(i,:) = spY.coefs;
    spZ = spap2(5, 12, x1, Lead_Vz(i,:)) %spline fit
    Spline_Vz(i,:) = spZ.coefs;
    
    Vxfit(i,:) = fnval(spX, x1); %reconstructed signal by spline fitting
    Vyfit(i,:) = fnval(spY, x1); %reconstructed signal by spline fitting
    Vzfit(i,:) = fnval(spZ, x1); %reconstructed signal by spline fitting
    %-----------------------%
    
end    

feature_spline = [Spline_Vx Spline_Vy Spline_Vz TF' VF_Vx' VF_Vy' VF_Vz'];

end