This file explains how to run the different Matlab scripts

## The scripts can be devided into the following sections:
* Experiment
* White-box identification
* Black-box identification
* Observer validation
* Controller validation
* Running the white-box model for reference tracking
* Running the TCLab for reference tracking



## Experiment
Heater inputs are given to the TCLab obtain the sensor data for white-box and black-box identification. The file used for this is named *experiment.m*.
#### To run the experiment script run: 
```
$ experiment.m
```



## White-box identification
The White-box parameter estimation exists out of two Matlab scripts, a Simulink model and two excel files, named respectively *nonlinid.m*, *costfun.m*, *nlmodel.slx*, *exceldata20.xlsx* and *exceldata21.xlsx*. The *nonlinid.m* file contains the non-linear optimization script and *costfun.m* the cost function to be minimized. The *nlmodel.slx* file contains the White-box model and *exceldata20.xlsx*, *exceldata21.xlsx* contain respectively the training data set and validation data set from the experiment. 

#### To run the White-box parameter estimation script run: 
```
$ nonlinid.m
```



## Black-box identification
The black box identification part consists of two files: ```black_box_identification.m``` and ```blackboxidentification.mat```.
```black_box_identification.m``` is used to load in two excel data sheets (```temperature_correct_1_v2.xlsx``` and ```temperature_correct_2_v2.xlsx```) that are used to train and validate the black-box models.
```blackboxidentification.mat``` contains all black-box models as well as the (detrended) data used to create the respective black-box models. In other words, in order to validate the black-box model, the only file that technically has to be checked is the ```blackboxidentification.mat``` file.
 **Note** that the ```systemIdentification``` toolbox was used to train & validate the black-box models.

#### (Re-)creating the Black-Box Models
1. Run ```black_box_identification.m``` to load in the data-sheets & to automatically detrend the data &#8594; The ```systemIdentification``` GUI will open as well.
2. In the ```systemIdentification``` GUI &#8594; ```Import data``` &#8594; ```Time domain data...``` &#8594; fill in ```Input = dat1_h12_detrend``` &#8594; fill in ```Output = dat1_s12_detrend``` &#8594; set ```Sample time``` &#8594; ```Import```;. Now we have imported the detrended data for heater 1
3. for heater 2 &#8594; ```Import data``` &#8594; ```Time domain data...``` &#8594; fill in ```Input = dat2_h12_detrend``` &#8594; fill in ```Output = dat2_s12_detrend``` &#8594; set ```Sample time``` &#8594; ```Import```;
4. To create a model &#8594; set the training data set under ```Working Data``` &#8594; ```Estimate -->``` &#8594; ```Polynomial Models``` &#8594; select model in ```Structure``` &#8594; define ```Orders``` and ```Iteration Options...``` (if possible). 
#### Validating the Black-Box Models
As we most likely do not want to recreate all black-box models, these can be easily loaded into the ```systemIdentification``` GUI using the ```blackboxidentification.mat``` file.
1. Load ```blackboxidentification.mat```.
2. Run ```$ systemIdentification``` in the ```Command Window``` of ```MATLAB```.
3. In the ```systemIdentification``` GUI &#8594; ```Import Data``` &#8594; ```Data Object...``` &#8594; ```h12_training1```. Now we have imported the training data set. **Note** that this step only has to be taken if you want to use the training data set for creating more black-box models.
4. For the validation data set &#8594; ```Import Data``` &#8594; ```Data Object ...``` &#8594; ```h12_validation1```
5. For importing the models &#8594; ```Import models``` &#8594; ```Import ...``` &#8594; choose one of the ```2x2 idpoly``` objects found in your workspace (which are loaded in with ```blackboxidentification.mat```) **Note** that the structure of the black-box model is explained with the following example &#8594; ```bj_7th_lsqnonlin``` means that it is a Box-Jenkins 7th order model using ```lsqnonlin``` (Trust-Region Reflective) as ```Iteration Options...```.
6. Drag the ```h12_validation1``` validation data set to the ```Validation Data``` window &#8594; choose the black-box models that you want to evaluate &#8594; click on ```Model output``` &#8594; now you should see the model output plotted against the validation data and the fit of said black-box model.

## Observer validation
The observer validation exists out of a Matlab script and a Simulink model, named *observer_matlab.m* and *observer_model.slx*. The *observer_matlab.m* file needs the linearized discrete state space matrices from *Linearize_whitebox.m* and the poles of the Pole Placement controller from *pole_placement.m*. Therefore, two other scripts need to be ran at first.


## Observer validation
The observer validation exists out of a Matlab script and a Simulink model, named *observer_matlab.m* and *observer_model.slx*. The *observer_matlab.m* file needs the linearized discrete state space matrices from *Linearize_whitebox.m* and the poles of the Pole Placement controller from *pole_placement.m*. Therefore, two other scripts need to be ran at first.
#### To do the observer validation run: 
```
$ Linearize_whitebox.m
$ pole_placement.m
$ observer_matlab.m
```

## Controller Validation
The controller is initially validated on the white-box model with state observer using reference tracking. This is done in the file ```runmodel_simulated.m```. The script creates a random reference temperature from ```line 23``` to ```line 42```, which is fed into ```Simulink``` and run. ```Simulink```'s output as a response to the inputted reference temperature is saved to the ```MATLAB``` workspace in ```line 48``` to ```line 52``` afterwards . The ```Simulink``` output is then plotted against the reference temperature from ```line 56``` to ```line 57```.

#### To execute the reference tracking with the white-box model run: 
```
$ Linearize_whitebox.m
$ pole_placement.m
$ LQR.m
$ observer_matlab.m
$ runmodel_arduino.m
```


## Running the TCLab for reference tracking
To execute the reference tracking with the TCLab, the *runmodel_arduino.m* file is used. This file is linked to a Simulink file named *full_model_arduino.slx*. The *runmodel_arduino.m* file needs data from several files to be able to run. It needs the state-space matrices from the *Linearize_whitebox.m* file, the observer gain matrix K from the *observer_matlab.m* file, the controller gain matrices L and Lr from the pole placement controller file named *pole_placement.m* and the controller gain matrices L and Lr from the LQR controller file named *LQR.m*. 

The *runmodel_arduino.m* file can either use the pole placement controller or the *LQR controller*. If the LQR controller is used, comment out line 5: *load('L_Lr_Pole_Placement_final.mat') %Pole Placement*. If the pole placement controller is used, comment out line 6: *load('L_Lr_LQR_final.mat') % LQR*. 
#### To execute the reference tracking with the TCLab run: 
```
$ Linearize_whitebox.m
$ pole_placement.m
$ LQR.m
$ observer_matlab.m
$ runmodel_arduino.m
```
