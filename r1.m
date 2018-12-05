clear variables % clear any old variables in the workspace
close all % closes any plots open from previous runs


%load without using the native method the density of the air file
load('densityVector.mat')

%List all the variables needed

massEmptyRocket = 1500; % kg
startingMassFuel = 7000; % kg
massHorse = 75; %kg
massTotal = massEmptyRocket + startingMassFuel +massHorse; % kg
engineThrust = 	130000; %N
area = 2 * 3.14;
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
maxAltitude = 9999999999;
endOfUsefulData = 0;
pos = 0;
vel = 0;
%start a loop to calcualte our equations of motion at each Time Step

for t = 1:1:(endTime/dt) %   t is the current TimeStep

%Equation of motion
    km = floor(pos / 1000) + 1; %we already compensated for matlab deficiencies
    resto = 1000 + pos - km * 1000; %counter compensate for the matlab quirkness of non zero starting array
    
    density1 = densityVector(km);
    density2 = densityVector(km + 1);
    densityDelta = (density2 - density1) / 1000;
    
    
    
    density = density1;
    density += densityDelta * resto;
    
    %1000 is added because else this drag is irrelevant compared to the trust and weight
    drag = 0.5 * density * (vel * vel) * area * dragCoeficient * 1000;
    if t <= (burnTime/dt) %while the engines are firing
        acceleration(t) =  (engineThrust - drag - weight) / massTotal;
    else %when the engines have stopped firing
      if vel > 0
        drag = drag * -1;
      end
        acceleration(t) =  (drag - weight) /massTotal;
        acc = acceleration(t);
    end

    
time(t) = t*dt; % update the time vector with the new time step

if t == 1350
 cry = 0;
end



if t == 1450
 cry = 0;
end

%Calculate the velocity and Position, by integrating.
velocity = cumtrapz(time,acceleration);
position = cumtrapz(time,velocity);

%Current position (and velocity) are computed BAD, so take two step ago, to be safe
  if t > 15
    pos = position(t - 1);
    vel = velocity(t - 1);
  else
    pos = 0;
    vel = 0;
  end

  if pos < 0
    endOfUsefulData = t - 2;
    break %terminate the Simulation, we have finished here
  end
   
    
end

%the data AFTER the end are plain wrong, we have to remove
velocityOld = velocity;
positionOld = position;
accelerationOld = acceleration;

velocity = zeros(1,endOfUsefulData);
position  = zeros(1,endOfUsefulData);
acceleration  = zeros(1,endOfUsefulData);
time = zeros(1,endOfUsefulData);

for t = 1:1:endOfUsefulData
 velocity(t) = velocityOld(t);
 position(t)  = positionOld(t);
 acceleration(t) = accelerationOld(t);
 time(t) = t*dt;
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



