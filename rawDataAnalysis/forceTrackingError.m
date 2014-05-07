% Close plots
clc
close all

% Left Leg
time     =  v_ATCSlipWalking__ascLegForceL__log___time - v_ATCSlipWalking__ascLegForceL__log___time(1);
computeF = hypot(v_ATCSlipWalking__ascLegForceL__log_compute__fx,v_ATCSlipWalking__ascLegForceL__log_compute__fz);
controlF = hypot(v_ATCSlipWalking__ascLegForceL__log_control__fx,v_ATCSlipWalking__ascLegForceL__log_control__fz);

plot(time,controlF-computeF,'.b')
hold on

% Right Leg
time     =  v_ATCSlipWalking__ascLegForceR__log___time - v_ATCSlipWalking__ascLegForceR__log___time(1);
computeF = hypot(v_ATCSlipWalking__ascLegForceR__log_compute__fx,v_ATCSlipWalking__ascLegForceR__log_compute__fz);
controlF = hypot(v_ATCSlipWalking__ascLegForceR__log_control__fx,v_ATCSlipWalking__ascLegForceR__log_control__fz);

plot(time,controlF-computeF,'.r')

% Plot labels
title('Force Tracking Error')
xlabel('Time (s)')
ylabel('Force (N)')
ylim([-500 500])
legend('Left Leg','Right Leg','Location','Best')
