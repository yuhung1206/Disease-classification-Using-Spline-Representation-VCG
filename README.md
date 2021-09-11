# Disease-classification-Using-Spline-Representation-VCG  





**Myocardial infarction (MI)**-induced changes in the morphological and temporal wave features are extracted from the derived **VCG** using **spline approximation**.  

After the feature extraction, a classifier based on **multilayer perceptron network (MLP)** is used for MI classification.  

Experiments on **PTB diagnostic database** demonstrate that the proposed system achieved satisfactory performance to differentiating MI patients from healthy subjects and to localizing the infarcted area.  

Details of this study please refer to :point_right:	 https://doi.org/10.3390/s20247246
  
  
## Daraset    

To automatic download the records from PTD database,
  please refer to :point_right:	 https://github.com/yuhung1206/Auto_download_PTB  
  
## Execution  

1. **Spline-based feature extraction**  
    Note: all input signals(derived,real) must have been **preprocessed**  
      
    - Main program: `SplineFeatureExtract.m`  
    - Sub programs: `SplineFit_1_Lead_Exclude_NoSeg.m`, `SplineFit_2_Lead_Exclude_NoSeg.m`, `SplineFit_3_Lead_Exclude_NoSeg.m`, `pan_tompkin.m`  
    ![](https://i.imgur.com/TJtLpc3.png)   
                
      |Code |function|
      |-----|--------|
      |`SplineFit_k_Lead_Exclude_NoSeg.m`|extract feature from k leads & generate label for learning |
      |`pan_tompkin.m`|R-peak detection      |   
      |`plotATM.m`| Load .mat and .info files
        
    -  Get function "plotATM.m" from physionet website  
      :point_right: https://archive.physionet.org/physiotools/matlab/plotATM.m 
    
    
    - ReconFlag and lead_I_Flag:  
      ![image](https://user-images.githubusercontent.com/78803926/132938811-b585364c-f83e-4b1c-aca9-2d566fe5d6ef.png)
  
  
    - Output Name & directory for features  
      ![](https://i.imgur.com/VNY5v8I.png)
    - Input filename
    make sure that input filename is correct
    ![](https://i.imgur.com/YvygQyJ.png)

    - Choose how many leads to extract:  
      `SplineFit_1_Lead_Exclude_NoSeg` -> 1 lead features(18)  
      `SplineFit_2_Lead_Exclude_NoSeg` -> 2 lead features(35)
      `SplineFit_3_Lead_Exclude_NoSeg` -> 3 lead features(52)
          
        ![](https://i.imgur.com/nUn0MeP.png)
    
        - For `SplineFit_1_Lead_Exclude_NoSeg.m`  
          `singal(1,:)`-->X lead  
          `singal(2,:)`-->Y lead  
          `singal(3,:)`-->Z lead  
          ![](https://i.imgur.com/go6UP8R.png)
        
       - For `SplineFit_2_Lead_Exclude_NoSeg.m`
       The example of X+Y leads is shown below: 
        ![](https://i.imgur.com/gj8059A.png)
        
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
    
    - Get `mySMOTE.m` from :point_right: https://www.mathworks.com/matlabcentral/fileexchange/70315-smote-over-sampling  
       - What is **SMOTE**?  
       - ...coming soon
    
    - make sure InputName is correct:   
      ![](https://i.imgur.com/80m5B9v.png)

    - make sure Output filepath is correct:  
      ![](https://i.imgur.com/K00bPin.png)
    
    - start training  
     ![](https://i.imgur.com/qk6hEZM.png)


### Reference
[1] Abhishek Gupta (2021). SMOTE-over-Sampling (https://github.com/earthat/SMOTE-over-Sampling), GitHub. Retrieved September 11, 2021.

  
