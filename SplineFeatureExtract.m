close all; clear all; clc;

rng(1); % fix randon seed

%-----Initialization-----%
samplingrate = 500;
windowsize = 400;
ReconFlag = 0; % 1 => Reconstruc | 0 => Original 
lead_I_Flag = 0;

%-----Output File Name-----%
filename = 'Org_TCN_XYZ_Splines.mat';
SavePathName = '.\Extract_feature_TCN\';
if ~exist(SavePathName, 'dir')
    mkdir(SavePathName)
end
OutputName = [SavePathName filename];

%----------Anterior----------%
Data_Ant = [    's0015lrem'; 's0021arem'; 's0021brem'; 's0022lrem'; 's0025lrem'; 
                            's0026lrem'; 's0027lrem'; 's0029lrem'; 's0031lrem'; 's0034_rem'; 
                            's0036lrem'; 's0038lrem'; 's0042lrem'; 's0046lrem'; 's0056lrem'; 
                            's0061lrem'; 's0062lrem'; 's0064lrem'; 's0069lrem'; 's0071lrem'; 
                            's0078lrem'; 's0079lrem'; 's0090lrem'; 's0093lrem'; 's0101lrem'; 
                            's0108lrem'; 's0112lrem'; 's0120lrem'; 's0142lrem'; 's0143lrem'; 
                            's0146lrem'; 's0159lrem'; 's0182_rem'; 's0196lrem'; 's0202arem'; 
                            's0202brem'; 's0264lrem'; 's0266lrem'; 's0268lrem'; 's0270lrem'; 
                            's0272lrem'; 's0286lrem'; 's0290lrem'; 's0335lrem'; 's0346lrem'; 
                            's0380lrem'; 's0382lrem'; 's0384lrem'; 's0428_rem'; 's0394lrem';
                            's0433_rem'; 's0511_rem'; 's0539_rem'; 's0542_rem';  ];
%----------Anterio-lateral----------%
Data_AntLat = [ 's0089lrem'; 's0096lrem'; 's0125lrem'; 's0128lrem'; 's0151lrem'; 
                                's0162lrem'; 's0171lrem'; 's0172lrem'; 's0175_rem'; 's0180lrem'; 
                                's0212lrem'; 's0214lrem'; 's0228lrem'; 's0232lrem'; 's0233lrem'; 
                                's0234lrem'; 's0238lrem'; 's0243lrem'; 's0247lrem'; 's0249lrem'; 
                                's0250lrem'; 's0252lrem'; 's0253lrem'; 's0277lrem'; 's0284lrem'; 
                                's0319lrem'; 's0332lrem'; 's0368lrem'; 's0370lrem'; 's0376lrem'; 
                                's0379lrem'; 's0381lrem'; 's0385lrem'; 's0387lrem'; 's0388lrem'; 
                                's0395lrem'; 's0397lrem'; 's0412lrem'; 's0419lrem'; 's0501_rem'; 
                                's0507_rem'; 's0555_rem'; 's0556_rem'; 's0557_rem'; 's0558_rem';  ];
%----------Anterio-Septal----------%
Data_AntSep = [ 's0019_rem'; 's0020arem'; 's0020brem'; 's0045lrem'; 's0051lrem'; 
                                's0072lrem'; 's0083lrem'; 's0084lrem'; 's0086lrem'; 's0087lrem'; 
                                's0091lrem'; 's0092lrem'; 's0094lrem'; 's0098lrem'; 's0099lrem'; 
                                's0102lrem'; 's0105lrem'; 's0106lrem'; 's0107lrem'; 's0109lrem'; 
                                's0111lrem'; 's0113lrem'; 's0115lrem'; 's0116lrem'; 's0117lrem'; 
                                's0118lrem'; 's0121lrem'; 's0122lrem'; 's0123lrem'; 's0126lrem'; 
                                's0129lrem'; 's0134lrem'; 's0135lrem'; 's0137lrem'; 's0140lrem'; 
                                's0150lrem'; 's0153lrem'; 's0156lrem'; 's0157lrem'; 's0158lrem'; 
                                's0160lrem'; 's0161lrem'; 's0163lrem'; 's0164lrem'; 's0165lrem'; 
                                's0167lrem'; 's0168lrem'; 's0179lrem'; 's0181lrem'; 's0184lrem'; 
                                's0187lrem'; 's0191lrem'; 's0209lrem'; 's0210lrem'; 's0213lrem'; 
                                's0216lrem'; 's0267lrem'; 's0271lrem'; 's0279lrem'; 's0281lrem'; 
                                's0288lrem'; 's0289lrem'; 's0313lrem'; 's0320lrem'; 's0331lrem'; 
                                's0347lrem'; 's0350lrem'; 's0353lrem'; 's0357lrem'; 's0361lrem'; 
                                's0400lrem'; 's0403lrem'; 's0408lrem'; 's0410lrem'; 's0414lrem'; 
                                's0445_rem'; 's0553_rem'; ];
%----------Anterio-Septo-lateral----------%
Data_AntSepLat = ['s0294lrem'; 's0295lrem'; ];
%----------Inferio----------%
Data_Inf = ['s0005_rem'; 's0008_rem'; 's0028lrem'; 's0037lrem'; 's0039lrem'; 
                        's0043lrem'; 's0044lrem'; 's0049lrem'; 's0050lrem'; 's0065lrem'; 
                        's0067lrem'; 's0068lrem'; 's0073lrem'; 's0080lrem'; 's0081lrem'; 
                        's0085lrem'; 's0088lrem'; 's0095lrem'; 's0097lrem'; 's0100lrem'; 
                        's0103lrem'; 's0104lrem'; 's0110lrem'; 's0114lrem'; 's0119lrem'; 
                        's0124lrem'; 's0127lrem'; 's0130lrem'; 's0131lrem'; 's0133lrem'; 
                        's0145lrem'; 's0173lrem'; 's0174lrem'; 's0177lrem'; 's0178lrem'; 
                        's0185lrem'; 's0186lrem'; 's0198lrem'; 's0215lrem'; 's0219lrem'; 
                        's0222_rem'; 's0223_rem'; 's0225lrem'; 's0231lrem'; 's0235lrem'; 
                        's0242lrem'; 's0246lrem'; 's0248lrem'; 's0251lrem'; 's0254lrem'; 
                        's0255lrem'; 's0258lrem'; 's0259lrem'; 's0262lrem'; 's0280lrem'; 
                        's0285lrem'; 's0309lrem'; 's0314lrem'; 's0317lrem'; 's0327lrem'; 
                        's0339lrem'; 's0343lrem'; 's0348lrem'; 's0352lrem'; 's0354lrem'; 
                        's0356lrem'; 's0358lrem'; 's0360lrem'; 's0362lrem'; 's0367lrem'; 
                        's0369lrem'; 's0371lrem'; 's0373lrem'; 's0375lrem'; 's0377lrem'; 
                        's0378lrem'; 's0386lrem'; 's0389lrem'; 's0396lrem'; 's0398lrem'; 
                        's0399lrem'; 's0401lrem'; 's0407lrem'; 's0409lrem'; 's0411lrem'; 
                        's0413lrem'; 's0416lrem'; 's0417lrem'; 's0418lrem'; 's0426_rem'; 
                        's0495_rem'; 's0497_rem'; 's0554_rem'; 's0559_rem'; ];
%----------Inferio-Lateral----------%
Data_InfLat = [ 's0010_rem'; 's0016lrem'; 's0035_rem'; 's0047lrem'; %'s0014lrem';
                            's0052lrem'; 's0053lrem'; 's0055lrem'; 's0057lrem'; 's0058lrem'; 
                            's0060lrem'; 's0063lrem'; 's0066lrem'; 's0070lrem'; 's0074lrem'; 
                            's0075lrem'; 's0076lrem'; 's0077lrem'; 's0132lrem'; 's0136lrem'; 
                            's0138lrem'; 's0147lrem'; 's0148lrem'; 's0149lrem'; 's0152lrem'; 
                            's0155lrem'; 's0190lrem'; 's0192lrem'; 's0194lrem'; 's0195lrem'; 
                            's0197lrem'; 's0208lrem'; 's0217lrem'; 's0218lrem'; 's0227lrem'; 
                            's0230lrem'; 's0236lrem'; 's0237lrem'; 's0239lrem'; 's0240lrem'; 
                            's0241lrem'; 's0244lrem'; 's0245lrem'; 's0276lrem'; 's0283lrem'; 
                            's0316lrem'; 's0318lrem'; 's0344lrem'; 's0355lrem'; 's0359lrem'; 
                            's0372lrem'; 's0406lrem'; 's0449_rem'; 's0455_rem'; 's0505_rem'; 
                            's0512_rem'; 's0535_rem';  ]
            
%----------Inferio-Posterio----------%
Data_InfPost = ['s0013_rem'; 's0334lrem'; 's0351lrem'; ];

%----------Inferio-Posterio-Lateral----------%
Data_InfPostLat = [ 's0004_rem'; 's0017lrem'; 's0054lrem'; 's0059lrem'; 's0082lrem'; 
                                    's0201_rem'; 's0221lrem'; 's0226lrem'; 's0229lrem'; 's0260lrem'; 
                                    's0261lrem'; 's0265lrem'; 's0282lrem'; 's0315lrem'; 's0321lrem'; 
                                    's0326lrem'; 's0330lrem'; 's0454_rem'; 's0547_rem'; 's0548_rem'; ];
                
%----------Lateral----------%
Data_Lat = ['s0141lrem'; 's0144lrem'; 's0278lrem';  ];

%----------Posterio----------%
Data_Post = ['s0296lrem'; 's0297lrem'; 's0298lrem'; 's0345lrem'; ];

%----------Posterior-Lateral----------%
Data_PostLat = ['s0220lrem'; 's0256lrem'; 's0257lrem'; 's0263lrem'; 's0269lrem'; ];

%-----Normal-----%
Data_Norm = [ 's0273lrem'; 's0274lrem'; 's0275lrem'; 's0287lrem'; 's0291lrem';...
                             's0292lrem'; 's0299lrem'; 's0300lrem'; 's0301lrem'; 's0302lrem';... 
                             's0303lrem'; 's0304lrem'; 's0305lrem'; 's0306lrem'; 's0308lrem';... 
                             's0311lrem'; 's0312lrem'; 's0322lrem'; 's0323lrem'; 's0324lrem';... 
                             's0325lrem'; 's0328lrem'; 's0329lrem'; 's0336lrem'; 's0363lrem';... 
                             's0374lrem'; 's0402lrem'; 's0415lrem'; 's0436_rem'; 's0452_rem';... 
                             's0453_rem'; 's0457_rem'; 's0458_rem'; 's0459_rem'; 's0460_rem';... 
                             's0461_rem'; 's0462_rem'; 's0463_rem'; 's0464_rem'; 's0465_rem';... 
                             's0466_rem'; 's0467_rem'; 's0468_rem'; 's0469_rem'; 's0470_rem';... 
                             's0471_rem'; 's0472_rem'; 's0473_rem'; 's0474_rem'; 's0475_rem';... 
                             's0476_rem'; 's0477_rem'; 's0478_rem'; 's0479_rem'; 's0480_rem';... 
                             's0481_rem'; 's0482_rem'; 's0483_rem'; 's0486_rem'; 's0487_rem';... 
                             's0490_rem'; 's0491_rem'; 's0496_rem'; 's0499_rem'; 's0500_rem';... 
                             's0502_rem'; 's0503_rem'; 's0504_rem'; 's0506_rem'; 's0526_rem';...
                             's0527_rem'; 's0531_rem'; 's0532_rem'; 's0533_rem'; 's0534_rem';...
                             's0543_rem'; 's0545_rem'; 's0551_rem'; 's0552_rem'; 's0561_rem';];
%-----All Data-----%
DataBase = [Data_Ant; Data_AntLat; Data_AntSep; Data_AntSepLat; ...
                        Data_Inf; Data_InfLat; Data_InfPost; Data_InfPostLat;...
                        Data_Lat;...
                        Data_Post; Data_PostLat;...
                        Data_Norm];
inputType = ['Anterior\                ';'Anterio-lateral\         '; 'Anterio-Septal\          '; 'Anterio-Septo-lateral\   ';...
                         'Inferio\                 '; 'Inferio-Lateral\         '; 'Inferio-Posterio\        '; 'Inferio-Posterio-Lateral\';...
                         'Lateral\                 '; 
                         'Posterio\                '; 'Posterior-Lateral\       '; 
                         'Normal\                  '];
% e.g. 'C:\Users\....\PTB_Data\s0001_rem'
% inputpath = '.\Original leadI\'; 

%----------initialize for label----------%
[W,L] = size(DataBase);
TypeLen = [length(Data_Ant(:,1)), length(Data_AntLat(:,1)), length(Data_AntSep(:,1)), length(Data_AntSepLat(:,1)),...
           length(Data_Inf(:,1)), length(Data_InfLat(:,1)), length(Data_InfPost(:,1)),  length(Data_InfPostLat(:,1)),...
           length(Data_Lat(:,1)), length(Data_Post(:,1)), length(Data_PostLat(:,1)), length(Data_Norm(:,1)) ];
for iType = 2:length(TypeLen(1,:))
    TypeLen(iType) = TypeLen(iType)+TypeLen(iType-1); % typeBound
end
input = []; input_poly = []; label = [];
type = 1;  % judge which type
recon_count = 0;

for DataNumber = 1 : W
    %-----type decision-----%
    if DataNumber > TypeLen(type)
        type = type + 1;
    end
    
    %-----load PTB database-----%  
    % e.g. 'C:\Users\....\Reconstructe ECG\s0001_rem_multivcg_hidd30_150.mat'
    ECG_data = deblank(DataBase(DataNumber,:));
    Syn_ECG = [];
    %  e.g. 'F:\MasterPaper\VCG Syn data\All_Result\VMDTCN\ChestSyn_All'
    Syn_Path = ['F:\...\', ECG_data, '_50_synXYZ.mat'];  % alter the path to load synthesize XYZ ECG !!!
    lead_I_Path = ['.\...\', ECG_data, '_I_400.mat']; % alter the path to load orignial lead I ECG !!!
    
    % check File exist or not
    if isfile(Syn_Path) && isfile(lead_I_Path)
        lead_I = load(lead_I_Path).Lead_I;
        % check which signal to extract features
        if ReconFlag == 1
            Syn_ECG = load(Syn_Path).ecg_syn;
        elseif lead_I_Flag == 1
            Syn_ECG = load(lead_I_Path).Lead_I';
        else
            Syn_ECG = load(Syn_Path).ecg_org;
        end
        
    else
        % File does not exist.
        continue; % ignore the rest code
    end
    signal = Syn_ECG';
    
    %-----Spline fitting for 3 leads (XYZ)-----%
    typeString = inputType(type,:);
    [feature, R_peak_len] = SplineFit_3_Lead_Exclude_NoSeg(signal,samplingrate,windowsize,DataNumber,typeString,ECG_data, lead_I);

    
    %-----Record Target Type-----%
    [dim_input,width] = size(feature');
    labelCol = [];
    labelCol = zeros(length(TypeLen(1,:)),width);
    labelCol(type,:) = 1;
    input = [input feature'];
    label = [label labelCol];
   
end 
save(OutputName,'input','label','dim_input');