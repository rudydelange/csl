This file explains how to run the different Matlab scripts

## The scripts can be devided into the following sections:
* Experiment
* White-box identification
* Black-box identification
* Observer validation
* Controller validation
* Running the TCLab for reference tracking



## Experiment
Heater inputs are given to the TCLab obtain the sensor data for white-box and black-box identification. The file used for this is named *experiment.m*.
#### To run the experiment script run: 
```
$ experiment.m
```



## White-box identification
blabla



## Black-box identification
blabla



## Controller validation
The validation of the controller is done using the whitebox model. blablabla



## Observer validation
The observer validation exists out of a Matlab script and a Simulink model, named *observer_matlab.m* and *observer_model.slx*. The *observer_matlab.m* file needs the linearized discrete state space matrices from *Linearize_whitebox.m* and the poles of the Pole Placement controller from *pole_placement.m*. Therefore, two other scripts need to be ran at first.
#### To do the observer validation run: 
```
$ Linearize_whitebox.m
$ pole_placement.m
$ observer_matlab.m
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
