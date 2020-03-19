function test_transition
clear all,close all, clc

sA = State('A');
sB = State('B');

trAB = Transition('A', 'B', @OnEnter_A_B, @OnExit_A_B);
trAB.onEnter();




end

function OnEnter_A_B()
    disp('OnEnter_A_B')
end

function OnExit_A_B()
    disp('OnEnter_A_B')
end

function OnStateB()
     disp('OnState')
end

function OnStateA()
     disp('OnState')
end
