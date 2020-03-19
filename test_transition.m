function test_transition
clear all,close all, clc

sA = State('A');
sB = State('B');

trAB = Transition('A', 'B');
trAB.onEnter();


end

function A_B_OnEnter()
    disp('OnEnter_A_B')
end

function A_B_OnExit()
    disp('OnEnter_A_B')
end

function OnStateB()
     disp('OnState')
end

function OnStateA()
     disp('OnState')
end
