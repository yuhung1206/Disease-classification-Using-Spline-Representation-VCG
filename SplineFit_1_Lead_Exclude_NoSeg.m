function [feature, R_peak_num] = SplineFit_1_Lead_Exclude_NoSeg(signal, samplingrate, windowsize, DataNumber, typeString, ECG_data, lead_I)

TF = []; VF_Vx = [];
R_peak = []; out = []; lead = [];

% the signal has already been filtered
%-----setup filter (butterworth 0.5~150Hz)-----%
% d1 = designfilt('bandpassiir','FilterOrder',4, ...
%      'HalfPowerFrequency1',0.5,'HalfPowerFrequency2',150,'SampleRate',500,'DesignMethod','butter');

%-----downsampling (1000Hz-->500Hz)-----%
% for i = 1:3
%     out(i,:) = filtfilt(d1,signal(i,:));
%     %lead(i,:) = resample(out(i,:),samplingrate,1000);       
% end

lead = signal(1,:); % choose X, Y or Z lead
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
% if ~exist('.\Fitting Picture\InfPostLat', 'dir')
%     mkdir('.\Fitting Picture\InfPostLat')
% end

for i = 1 : length(peak_period) 
    %----Spline fitting-----%
    spX = spap2(5, 12, x1, Lead_Vx(i,:)) %spline fit
    Spline_Vx(i,:) = spX.coefs;

    Vxfit(i,:) = fnval(spX, x1); %reconstructed signal by spline fitting
    
%     close all;
%     %----Draw-----%
%     figure(); plot(x1, Vxfit(i,:));
%     hold on; plot(x1, Lead_Vx(i,:));
%     png_name = ['.\Fitting Picture\InfPostLat\', ECG_data, ' ', int2str(i), '.png'];
%     title(png_name)
%     %-----------------------%
%     saveas(gcf, png_name);
end  
feature = [Spline_Vx TF' VF_Vx'];


end