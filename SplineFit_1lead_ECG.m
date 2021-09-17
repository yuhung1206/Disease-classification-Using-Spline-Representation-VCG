function [feature_spline] = SplineFit_1lead_ECG(signal, samplingrate, windowsize, DataNumber, typeString, ECG_data, lead_I, dir_Info)

TF = []; VF_Vx = [];
R_peak = [];  lead = [];

lead = signal;

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
Lead_Vx = []; 
for i = 1:(length(R_peak)-1)
    temp = lead(:,R_peak(i):R_peak(i+1)-1);
    peak_period(i) = length(temp);
    y = 1:peak_period(i);
    z = 1:((peak_period(i)-1)/(windowsize-1)):peak_period(i);              
    target = temp(1,:);

    Lead_Vx(i,:) = interp1(y, target, z, 'spline');% cycles*sample pnt 
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

%---------------------------------------%

% Each beat to fit spline
x1 = linspace(1/windowsize,1,windowsize);
Spline_Vx = []; 
Vxfit = []; 


% sample some examples to generate pictures
% e.g. dir_Info = 'InfPostLat';
%{
if ~exist( ['.\Fitting Picture\', dir_Info], 'dir')
    mkdir( ['.\Fitting Picture\', dir_Info])
end
%}


for i = 1 : length(peak_period) 
    %----Spline fitting-----%
    spX = spap2(5, 12, x1, Lead_Vx(i,:)) %spline fit
    Spline_Vx(i,:) = spX.coefs;

    %{
    Vxfit(i,:) = fnval(spX, x1); %reconstructed signal by spline fitting
    close all;
    %----Draw-----%
    figure(); plot(x1, Vxfit(i,:), '--', 'linewidth',1.5);
    hold on; plot(x1, Lead_Vx(i,:));
    png_name = ['.\Fitting Picture\', dir_Info, '\', ECG_data, ' ', int2str(i), '.png']; 
    title(png_name);
    legend('B-spline fitting','Vx');
    %-----------------------%
    saveas(gcf, png_name);
    %}
end

feature_spline = [Spline_Vx TF' VF_Vx'];

end