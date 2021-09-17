# Disease-classification-Using-Spline-Representation-VCG  





**Myocardial infarction (MI)**-induced changes in the morphological and temporal wave features are extracted from the derived **VCG** using **spline approximation**.  

After the feature extraction, a classifier based on **multilayer perceptron network (MLP)** is used for MI classification.  

Experiments on **PTB diagnostic database** demonstrate that the proposed system achieved satisfactory performance to differentiating MI patients from healthy subjects and to localizing the infarcted area.  

Details of this study please refer to :point_right:	 https://doi.org/10.3390/s20247246  

## System structure  
This project implement only the latter part of the proposed system. (The other part will coming soon)
![image](https://user-images.githubusercontent.com/78803926/133741445-52caf121-cc85-43d1-8c57-66cde01d589d.png)  

  
  
## Dataset    

To automatic download the records from PTD database,
  please refer to :point_right:	 https://github.com/yuhung1206/Auto_download_PTB  
    ![image](https://user-images.githubusercontent.com/78803926/133739922-e2106dbe-e32d-4222-84b0-edd1c8c58012.png)

  
## Execution  

1. **Spline-based feature extraction**  `spline`
          
    - Main program: `SplineFeatureExtract.m`  
    - Sub programs: `SplineFit_1lead_ECG.m`, `SplineFit_2lead_ECG.m`, `SplineFit_3lead_ECG.m`, `pan_tompkin.m`  
    
      ![image](https://user-images.githubusercontent.com/78803926/133735227-04999d95-68c6-49a6-8e0e-7b37816b3522.png)  
                
      |Code |function|
      |-----|--------|
      |`SplineFit_klead_ECG.m`|extract feature from k leads & generate label for learning |
      |`pan_tompkin.m` [1][2]|R-peak detection         |   
      |`plotATM.m`          | Load .mat and .info files|
        
    -  Get function **"plotATM.m"** from physionet website  
      :point_right: https://archive.physionet.org/physiotools/matlab/plotATM.m  
      
    -  Get function **"pan_tompkin.m"**  
      :point_right: https://www.mathworks.com/matlabcentral/fileexchange/45840-complete-pan-tompkins-implementation-ecg-qrs-detector  
    
    
    - Set the ```lead_Num``` as [13,14,15] to extract features from VCG (Vx, Vy, Vz)  
      ![image](https://user-images.githubusercontent.com/78803926/133735747-280c3b2a-abe9-481b-98f4-1279ae611f87.png)  
        
  
    - Set Output Name & directory to store features  
      ![image](https://user-images.githubusercontent.com/78803926/133736079-527dc876-e733-4782-a29d-e7720f269696.png)  
      
    - Input filename
    make sure that input filename is correct  
    ![image](https://user-images.githubusercontent.com/78803926/133736563-a2a1b147-2c03-4a16-aa71-923329440d92.png)


    - Choose how many leads to extract:  
      `SplineFit_1lead_ECG.m` -> 1 lead features(18 dimension)  
      `SplineFit_2lead_ECG.m` -> 2 lead features(35 dimension)  
      `SplineFit_3lead_ECG.m` -> 3 lead features(52 dimension)
          
        ![image](https://user-images.githubusercontent.com/78803926/133737025-24811da8-cb92-4e81-ab2a-288be55038d0.png)  
         - The setting to extract features from Vx+Vy leads is shown below: 
              ![image](https://user-images.githubusercontent.com/78803926/133737330-c07367bd-d5b2-4949-ba37-28bb38db1f55.png)  
               and select the function ```SplineFit_2lead_ECG.m```  
               ![image](https://user-images.githubusercontent.com/78803926/133737858-e4c56a56-bdfb-431d-8d96-1cdadfc40c6f.png)
        
        
    - Start extraction  
      ![](https://i.imgur.com/v8Tf9jK.png)
 
 2. **Multi-Layer-Perceptron** `MLP`  
    Note: input are features rather than signals  
    
     - Main program: `Classification_SMOTE.m`
     - Sub programs: `mySMOTE.m`
    
        |Code |function|
        |-----|--------|
        |`Classification_SMOTE.m`|FNN for classification|
        |`mySMOTE.m`|deal with the imbalanced database|  
    
    - Get `mySMOTE.m` from [3] :point_right: https://www.mathworks.com/matlabcentral/fileexchange/70315-smote-over-sampling  
        
       ![image](https://user-images.githubusercontent.com/78803926/133742593-7a10cd5c-86d8-4768-8b40-4cba806fcbd8.png)  
       
    
    - make sure InputName is correct:   
      ![image](https://user-images.githubusercontent.com/78803926/133738485-600aa9a4-1936-4b80-82fc-9b07dc9a39a4.png)

    - the classification performance will be stored in `total` variable:  
      Because it is 12-type classification, the size of `total` is [12,12].
    
    - start training  
     ![](https://i.imgur.com/qk6hEZM.png)


## Reference
  [1] Sedghamiz. H, "Matlab Implementation of Pan Tompkins ECG QRS detector.", March 2014. https://www.researchgate.net/publication/313673153_Matlab_Implementation_of_Pan_Tompkins_ECG_QRS_detect  
  [2] PAN.J, TOMPKINS. W.J,"A Real-Time QRS Detection Algorithm" IEEE TRANSACTIONS ON BIOMEDICAL ENGINEERING, VOL. BME-32, NO. 3, MARCH 1985.  
  [3] Abhishek Gupta (2021). SMOTE-over-Sampling (https://github.com/earthat/SMOTE-over-Sampling), GitHub. Retrieved September 11, 2021.

  
