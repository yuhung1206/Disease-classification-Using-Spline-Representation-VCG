close all, clear all, clc;

for Cur = 1
rng(1);
inputList = ['X_Splines2.mat' ];
inputName = ['.\Extract_feature_TCN\Reconstruct_TCN_', strtrim(inputList(Cur,:)) ];
load(inputName);
%-----Output File Name-----%
filename = ['Table_',strtrim(inputList(Cur,:))];
SavePathName = '.\Extract_feature_TCN\';

OutputName = [SavePathName filename];
%input = [];
%input = input_poly;
% for selection
%input = input(1:40,:);
x = input; % features*total cycles number  (ex. 87*6315)
t = label; % classes*total cycles number* (ex. 5*6315)
[W,L] = size(input'); % W:total length % L:130 poly parameters
W = W - mod(W, 5);
[tW,tL] = size(t');
tW = tW - mod(tW, 5);
total = zeros(tL,tL); %for confusion matrix
origin_input = input;
origin_label = label;
%-----For a list of all training functions type: help nntrain-----%
%trainFcn = 'trainscg';  
trainFcn = 'traingdx';
%Gradient Descent with Momentum & Adaptive Learning Rate Backpropagation

%-----Create a Pattern Recognition Network-----%
hiddenLayerSize = [300 275];
net = patternnet(hiddenLayerSize, trainFcn);
net.layers{1}.transferFcn = 'poslin';
cvIndices = crossvalind('Kfold',W,5); %divide into 5 folds

for k = 1:5
    m=1; n=1; q=1; 
    testInd = []; valInd = []; trainInd = [];
    for j = 1:W
        if cvIndices(j) == 0+k
            testInd(m) =  j;
            m = m + 1;
        elseif cvIndices(j) == mod((1+k),5)
            valInd(n) = j;
            n = n + 1;
        else
            trainInd(q) = j;
            q = q + 1;
        end
    end
    %---SMOTE---
    %-----calculate type Bound-----
    TypeBound = sum(label');
    for i = 2:tL %tl=>type number
        TypeBound(i) = TypeBound(i-1) + TypeBound(i);
    end
    %----------------validation set----------------%
    %-----compute each tyle cycle-----
    ClassNum = sum(label(:,valInd)');

    %-----compute extend rate-----
    ExtendRate = floor(100*(ClassNum/max(ClassNum)).^(-1));
    
    %-----combine data in same type-----%
    startPoint = 1;
    for i = 1:tL
         %-----up sampleing-----%
         SMOTEData = []; ExpandData = [];
         %[input, label, valInd] = PreSMOTE(i, valInd, ClassNum, ExtendRate, W, L, origin_input, origin_label);
         SMOTEData = input(:,valInd(startPoint:startPoint-1+ClassNum(i)))'
         [~, oL] = size(SMOTEData')
         startPoint = startPoint + ClassNum(i);
         ExpandData = mySMOTE(SMOTEData, ExtendRate(i), 5);
         ExpandData = ExpandData'
         ExpandData(:,1:oL) = [];
         %add expand data to
         [Add_L,Add_W] = size(ExpandData);
         pre_W = length(input(1,:));
         input = [input ExpandData];
         %valInd(n:n-1+Add_W) = (pre_W+1):(pre_W+Add_W)
         valInd = [valInd (pre_W+1):(pre_W+Add_W)]
         n = n + Add_W;
         Expandlabel = [];
         Expandlabel = zeros(tL,Add_W);
         Expandlabel(i,:) = 1;
         label = [label Expandlabel];
    end

    %--------------------------------------------%
    %----------------training set----------------%
    ClassNum = [];
    %-----compute each type cycle-----
    ClassNum = sum(label(:,trainInd)');
    
    %-----compute extend rate-----%
    ExtendRate = floor(100*(ClassNum/max(ClassNum)).^(-1));
    
    %-----combine data in same type-----%
    startPoint = 1;
    for i = 1:tL
         SMOTEData = []; ExpandData = [];
         SMOTEData = input(:,trainInd(startPoint:startPoint-1+ClassNum(i)))'
         startPoint = startPoint + ClassNum(i);
         ExpandData = mySMOTE(SMOTEData, ExtendRate(i), 5);
         ExpandData = ExpandData';
         ExpandData(:,1:length(SMOTEData(:,1))) = [];
         %add expand data to
         [Add_L,Add_W] = size(ExpandData);
         pre_W = length(input(1,:));
         input = [input ExpandData];
         %valInd(n:n-1+Add_W) = (pre_W+1):(pre_W+Add_W)
         trainInd = [trainInd (pre_W+1):(pre_W+Add_W)]
         q = q + Add_W;
         Expandlabel = [];
         Expandlabel = zeros(tL,Add_W);
         Expandlabel(i,:) = 1;
         label = [label Expandlabel];
    end
    x = input;
    t = label;
    %--------------------------------------------%
    
    %random index 
    newtrainInd = trainInd(randperm(length(trainInd)));
    newvalInd = valInd(randperm(length(valInd)));
    newtestInd = testInd(randperm(length(testInd)));
    
    net.divideParam.trainInd = newtrainInd;
    net.divideParam.valInd = newvalInd;
    net.divideParam.testInd = newtestInd;
    %test data
    for a = 1:W/5
        testx(:,a) = x(:,newtestInd(a));
        testt(:,a) = t(:,newtestInd(a));
    end
    % Train the Network
    net = init(net);
    [net,tr] = train(net,x,t);
    
    % Test the Network
    y = net(x);
    e = gsubtract(t,y);
    performance = perform(net,t,y)
    tind = vec2ind(t);
    yind = vec2ind(y);
    percentErrors = sum(tind ~= yind)/numel(tind);
    
    testy = net(testx);
    %figure, plotconfusion(testt,testy); %target, outputs
    [c,cm,ind,per] = confusion(testt,testy);% target, outputs
    for row = 1:12
        for column = 1:12
            total(row,column) = cm(row,column) + total(row,column);
            % Row :Predicted // Column: Real
        end
    end
    [NewL,NewW] = size(input);
    input = [];
    input = origin_input;
    label = [];
    label = origin_label;
end
save(OutputName,'total');
%save('./Result/CM_CM_RealVx&Vy&Vz_Discard_0_8_gdx','input','label','dim_input','cm','total','ind');
end

