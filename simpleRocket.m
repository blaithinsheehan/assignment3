clear variables % clear any old variables in the workspace
close all % closes any plots open from previous runs
%List all the variables needed

massEmptyRocket = 1500; % kg
startingMassFuel = 7000; % kg
massHorse = 75; %kg
massTotal = massEmptyRocket + startingMassFuel +massHorse; % kg
engineThrust = 	130000; %N
gravity = 9.81; %m/s/s
density = 1.225; %kg/m3
dragCoeficient = .05;
drag = 0; % no drag
weight = massTotal * gravity; %Constant for now
dt = .1; % timeStep duration in seconds
endTime = 150; % Seconds
acceleration = zeros(1,endTime/dt); %Create empty vector of zeros for Acceleration Data the length of the simulation
time = zeros(1,endTime/dt);  ; %Create empty vector of zeros for time Data
burnTime = 60; %Time Engines are firing for.

%start a loop to calcualte our equations of motion at each Time Step

for t = 1:1:(endTime/dt) %   t is the current TimeStep

%Calculate the velocity and Position, by integrating.
velocity = cumtrapz(time,acceleration);
position = cumtrapz(time,velocity);

%Equation of motion
    
    if t <= (burnTime/dt) %while the engines are firing
        
        acceleration(t) =  (engineThrust - drag - weight) /massTotal;
        
    else %when the engines have stopped firing
        
        acceleration(t) =  (-drag - weight) /massTotal;
        
    end

    
time(t) = t*dt; % update the time vector with the new time step

    
end

%plot results

figure();
plot(time, acceleration)
title ('Acceleration vs Time - Simple Rocket')
xlabel('Time - (s)')
ylabel('acceleration - (m/s^2)')
grid on

figure();
plot(time, velocity)
title ('Velocity vs Time - Simple Rocket')
xlabel('Time - (s)')
ylabel('velocity - (m/s)')
grid on

figure();
plot(time, position)
title ('Position vs Time - Simple Rocket')
xlabel('Time - (s)')
ylabel('Height - (m)')
grid on



