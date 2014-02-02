clc
close all

% Shorten names
LmA_cP = v_ATCSlipWalking__ascPDLmA__log_currentPos;
LmA_tP = v_ATCSlipWalking__ascPDLmA__log_targetPos;
LmB_cP = v_ATCSlipWalking__ascPDLmB__log_currentPos;
LmB_tP = v_ATCSlipWalking__ascPDLmB__log_targetPos;

RmA_cP = v_ATCSlipWalking__ascPDRmA__log_currentPos;
RmA_tP = v_ATCSlipWalking__ascPDRmA__log_targetPos;
RmB_cP = v_ATCSlipWalking__ascPDRmB__log_currentPos;
RmB_tP = v_ATCSlipWalking__ascPDRmB__log_targetPos;

% Plot error
figure
plot(LmA_cP-LmA_tP,'b')
hold on
plot(LmB_cP-LmB_tP,'b')
plot(RmA_cP-RmA_tP,'r')
plot(RmB_cP-RmB_tP,'r')
