close all; clear all; clc;

rng(1);                         % fix the random seed
samplingrate = 500;   % 1000 downsample to 500
lead_Num = [13,14,15];            % standard 12 lead ECG --> 1~12, 3 Frank lead --> 13~15
windowsize = 400;      % each heartbeat sample to 400 points

%-----Output File Name-----%
filename = 'Splines_VCG_12type.mat';
SavePathName = '.\Extract_feature\';
% check if folder exists
if ~exist(SavePathName, 'dir')
    mkdir(SavePathName)
end
OutputName = [SavePathName filename];

%----------Anterior----------%
Data_Ant = [    's0015lrem';    's0026lrem';    's0031lrem';    's0034_rem';    's0061lrem';...
                         's0062lrem';    's0064lrem';    's0071lrem';    's0090lrem';    's0112lrem';...
                         's0142lrem';    's0182_rem';    's0196lrem';    's0202arem';    's0264lrem';...
                         's0290lrem';    's0335lrem';    's0380lrem';    's0428_rem';    's0394lrem';...
                         's0433_rem';    's0511_rem';    's0539_rem';    's0542_rem';  ];  % 24 people
            
%----------Anterio-lateral----------%
Data_AntLat = [    's0089lrem';    's0128lrem';    's0171lrem';    's0175_rem';    's0212lrem';...
                               's0214lrem';    's0228lrem';    's0232lrem';    's0249lrem';    's0250lrem';...
                               's0332lrem';    's0368lrem';    's0385lrem';    's0397lrem';    's0501_rem';...
                               's0507_rem';    's0556_rem';    's0558_rem'; ];  % 18 people
            
%----------Anterio-Septal----------%
Data_AntSep = [  's0019_rem';    's0020arem';    's0045lrem';    's0083lrem';    's0102lrem';...
                             's0105lrem';    's0111lrem';    's0122lrem';    's0129lrem';    's0135lrem';...
                             's0150lrem';    's0153lrem';    's0158lrem';    's0160lrem';    's0161lrem';...
                             's0179lrem';    's0191lrem';    's0209lrem';    's0210lrem';    's0216lrem';...  
                             's0267lrem';    's0281lrem';    's0331lrem';    's0350lrem';    's0361lrem';...    
                             's0400lrem';    's0445_rem';    's0553_rem'; ]; % 28 people
            
%----------Anterio-Septo-lateral----------%
Data_AntSepLat = ['s0294lrem'; ];  % 1 people

%----------Inferio----------%
Data_Inf = [ 's0005_rem';    's0008_rem';    's0028lrem';    's0039lrem';    's0043lrem';...
                    's0065lrem';    's0081lrem';    's0088lrem';    's0110lrem';    's0114lrem';...
                    's0174lrem';    's0178lrem';    's0198lrem';    's0219lrem';    's0222_rem';...
                    's0223_rem';    's0231lrem';    's0235lrem';    's0242lrem';    's0254lrem';...
                    's0262lrem';    's0309lrem';    's0356lrem';    's0362lrem';    's0369lrem';...
                    's0378lrem';    's0398lrem';    's0399lrem';    's0413lrem';    's0416lrem';...
                    's0426_rem';    's0495_rem';    's0497_rem';    's0554_rem';    's0559_rem';];  % 35 people

%----------Inferio-Lateral----------%
Data_InfLat = [   's0052lrem';    's0053lrem';    's0077lrem';    's0138lrem';    's0148lrem';...
                            's0149lrem';    's0152lrem';    's0190lrem';    's0192lrem';    's0194lrem';...
                            's0208lrem';    's0227lrem';    's0236lrem';    's0244lrem';    's0316lrem';...
                            's0372lrem';    's0406lrem';    's0449_rem';    's0455_rem';   's0505_rem';...
                            's0512_rem';    's0535_rem'; ];  % 22 people
            
%----------Inferio-Posterio----------%
Data_InfPost = [    's0013_rem';    's0334lrem';    's0351lrem';];  % 3 people

%----------Inferio-Posterio-Lateral----------%
Data_InfPostLat = [     's0004_rem';    's0017lrem';    's0059lrem';    's0201_rem';    's0221lrem';...
                                     's0260lrem';    's0321lrem';    's0454_rem';    's0547_rem';];  % 9 people
                
%----------Lateral----------%
Data_Lat = ['s0141lrem';];  % 1 people

%----------Posterio----------%
Data_Post = ['s0296lrem'; ];  % 1 people

%----------Posterior-Lateral----------%
Data_PostLat = ['s0220lrem';    's0269lrem';];  % 2 people

%-----Normal-----%
Data_Norm = [       's0273lrem';    's0274lrem';    's0275lrem';    's0287lrem';    's0291lrem';...
                                's0299lrem';    's0300lrem';    's0301lrem';    's0302lrem';    's0303lrem';...
                                's0304lrem';    's0305lrem';    's0306lrem';    's0308lrem';    's0311lrem';...
                                's0312lrem';    's0322lrem';    's0329lrem';    's0336lrem';    's0363lrem';...
                                's0374lrem';    's0402lrem';    's0436_rem';    's0452_rem';    's0457_rem';...
                                's0460_rem';    's0461_rem';    's0462_rem';    's0465_rem';    's0466_rem';...
                                's0467_rem';    's0468_rem';    's0469_rem';    's0471_rem';    's0472_rem';...
                                's0473_rem';    's0474_rem';    's0478_rem';    's0479_rem';    's0481_rem';...
                                's0486_rem';    's0487_rem';    's0491_rem';    's0496_rem';    's0499_rem';...
                                's0500_rem';    's0502_rem';    's0504_rem';    's0526_rem';    's0527_rem';...
                                's0531_rem';    's0543_rem';];  % 52 people
                            
%-----All Data-----%
DataBase = [    Data_Ant; Data_AntLat; Data_AntSep; Data_AntSepLat; ...
                        Data_Inf; Data_InfLat; Data_InfPost; Data_InfPostLat;...
                        Data_Lat;...
                        Data_Post; Data_PostLat;...
                        Data_Norm];
        
inputType = ['Anterior\                ';'Anterio-lateral\         '; 'Anterio-Septal\          '; 'Anterio-Septo-lateral\   ';...
                      'Inferio\                 '; 'Inferio-Lateral\         '; 'Inferio-Posterio\        '; 'Inferio-Posterio-Lateral\';...
                      'Lateral\                 '; 
                      'Posterio\                '; 'Posterior-Lateral\       '; 
                      'Normal\                  '];
         
         

%----------initialize----------%
[W,L] = size(DataBase);
TypeLen = [length(Data_Ant(:,1)), length(Data_AntLat(:,1)), length(Data_AntSep(:,1)), length(Data_AntSepLat(:,1)),...
           length(Data_Inf(:,1)), length(Data_InfLat(:,1)), length(Data_InfPost(:,1)),  length(Data_InfPostLat(:,1)),...
           length(Data_Lat(:,1)), length(Data_Post(:,1)), length(Data_PostLat(:,1)), length(Data_Norm(:,1)) ];

for iType = 2:length(TypeLen(1,:))
    TypeLen(iType) = TypeLen(iType)+TypeLen(iType-1); %typeBound
end

input = []; input_spline = []; label = [];
type = 1;
for DataNumber = 1 : W
    %-----type decision-----%
    if DataNumber > TypeLen(type)
        type = type + 1;
    end
    
    %-----load PTB database-----%  
    % e.g. 'C:\Users\ED812A\Desktop\New folder\Eeconstructe ECG\s0001_rem_multivcg_hidd30_150.mat'
    ECG_data = deblank(DataBase(DataNumber,:));
    leads = [];
    ECG_Path = ['.\ECG Data\', ECG_data];
    
    % check File exist or not
    if isfile([ECG_Path, '.mat'])
        
        % File exists.
        [leads]= plotATM(ECG_Path);
        lead_I = leads(1, :);  % load lead I to detect R peak in each cycle
        lead_classify = leads(lead_Num, :);  % load the lead used to calssification
        
        % denoise and resample the signal
        d1 = designfilt('bandpassiir','FilterOrder',4, ...
        'HalfPowerFrequency1',0.5,'HalfPowerFrequency2',150,'SampleRate',1000,'DesignMethod','butter');
        lead_I = filtfilt(d1,lead_I);
        lead_I = resample(lead_I,samplingrate,1000);  % downsample to 500 Hz
        
        lead_classify2 = [];
        for k = 1:length(lead_Num)
            lead_classify(k,:) = filtfilt(d1,lead_classify(k,:));  % 
            lead_classify2(k,:) = resample(lead_classify(k,:),samplingrate,1000);  % downsample to 500 Hz
        end
    
    else
        % File does not exist.
        display('No such file exust!');
        continue; % ignore the rest code
    end
    
    signal = lead_classify2;
    
    %-----Spline fitting-----%
    typeString = inputType(type,:);
    %[feature, ~] = SplineFit_1lead_ECG(signal, samplingrate, windowsize, DataNumber, typeString, ECG_data, lead_I);
    %[feature, ~] = SplineFit_2lead_ECG(signal, samplingrate, windowsize, DataNumber, typeString, ECG_data, lead_I);
    [feature, ~] = SplineFit_3lead_ECG(signal, samplingrate, windowsize, DataNumber, typeString, ECG_data, lead_I);
    
    %-----Record Target Type-----%
    [dim_input,width] = size(feature');
    labelCol = [];
    labelCol = zeros(length(TypeLen(1,:)),width);
    labelCol(type,:) = 1;
    input = [input feature'];
    label = [label labelCol];
   
end

save(OutputName,'input','label','dim_input');