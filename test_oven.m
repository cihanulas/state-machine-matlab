function test_oven
clear all, close all,clc
oven = Oven;

%% test Halt event in state
expect_current_state('ST_DoorClose', false);

oven.OpenDoor();
expect_current_state('ST_DoorOpen', true);

oven.CloseDoor();
expect_current_state('ST_DoorClose', false);

    function expect_current_state (state, light)
        assert (strcmp(oven.CurrentState(),state));
        assert (oven.light==light);
    end
end
