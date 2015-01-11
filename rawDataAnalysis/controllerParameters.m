% Determine control parameters for the atcSlipWalking controller

% SLIP parameters
% Rest leg length
r0 = v_ATCSlipWalking__input_leg__length;
% Leg trigger angles
q1 = v_ATCSlipWalking__input_q1;
q2 = v_ATCSlipWalking__input_q2;
q3 = v_ATCSlipWalking__input_q3;
q4 = v_ATCSlipWalking__input_q4;

% Flight parameters
legRet = v_ATCSlipWalking__input_swing__leg__retraction;

% VPP parameters
qvpp = v_ATCSlipWalking__input_qvpp;
rvpp = v_ATCSlipWalking__input_rvpp;

% Figure out if any input variables changed
if ~all(r0(1) == r0)
    display('Input leg length changed')
end
if ~all(q1(1) == q1)
    display('q1 changed')
end
if ~all(q2(1) == q2)
    display('q2 changed')
end
if ~all(q3(1) == q3)
    display('q3 changed')
end
if ~all(q4(1) == q4)
    display('q4 changed')
end
if ~all(qvpp(1) == qvpp)
    display('qvpp changed')
end
if ~all(rvpp(1) == rvpp)
    display('rvpp changed')
end
if ~all(legRet(1) == legRet)
    display('legRet changed')
end

% Control parameters
display(['r0: ' num2str(r0(1))])
display(['q1: ' num2str(q1(1))])
display(['q2: ' num2str(q2(1))])
display(['q3: ' num2str(q3(1))])
display(['q4: ' num2str(q4(1))])
display(['qvpp: ' num2str(qvpp(1))])
display(['rvpp: ' num2str(rvpp(1))])
display(['legRet: ' num2str(legRet(1))])
