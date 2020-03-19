function test_motor
clear all, close all,clc
motor = Motor;

%% test Halt event in state
expect_current_state('ST_Idle');
motor.Halt();
expect_current_state('ST_Idle');

% Fisrt set speed switchs to ST_Start 
motor.SetSpeed(MotorSpeed(10));
expect_current_state('ST_Start');

motor.SetSpeed(MotorSpeed(20));
expect_current_state('ST_ChangeSpeed');
motor.SetSpeed(MotorSpeed(30));
expect_current_state('ST_ChangeSpeed');
motor.Halt();
expect_current_state('ST_Idle');
motor.SetSpeed(MotorSpeed(10));
expect_current_state('ST_Start');
motor.Halt();
expect_current_state('ST_Idle');

    function expect_current_state (state)
        assert (strcmp(motor.CurrentState(),state));
    end
end
