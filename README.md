# Disease-classification-Using-Spline-Representation-VCG  
  
**Myocardial infarction (MI)**-induced changes in the morphological and temporal wave features are extracted from the derived **VCG** using **spline approximation**.  

After the feature extraction, a classifier based on **multilayer perceptron network (MLP)** is used for MI classification.  

Experiments on **PTB diagnostic database** demonstrate that the proposed system achieved satisfactory performance to differentiating MI patients from healthy subjects and to localizing the infarcted area.  

Details of this study please refer to -> https://doi.org/10.3390/s20247246
  
To automatic download the records from PTD database,
  please refer to -> https://github.com/yuhung1206/Auto_download_PTB  
  
## Execution  
 1. Preprocessing and Feature Extraction :  
    -->
 3. CNN for Classification : training the model with **Torch** package    
    ```
    python3 CNN.py
    ```
  
