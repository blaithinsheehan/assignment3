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

gravity = 9.81; %m/s/s

density = 1.225; %kg/m3

dragCoeficient = .05;

drag = 0; % no drag

weight = massTotal * gravity; %Constant for now

dt = .1; % timeStep duration in seconds

endTime = 250; % Seconds

acceleration = zeros(1,endTime/dt); %Create empty vector of zeros for Acceleration Data the length of the simulation

time = zeros(1,endTime/dt);  ; %Create empty vector of zeros for time Data

burnTime = 60; %Time Engines are firing for.



%start a loop to calcualte our equations of motion at each Time Step



%positions must be integers so divide by dt and multiply at at the end 

for t = 1:1:(endTime/dt) %   t is the current TimeStep
%Equation of motion
    if t <= (burnTime/dt) %while the engines are firing
        acceleration(t) =  (engineThrust - drag - weight) /massTotal;
    else %when the engines have stopped firing
        acceleration(t) =  (-drag - weight) /massTotal;
    end
time(t) = t*dt; % update the time vector with the new time step
end



%take out of the for loop to optimize code, no reason to recompute each time 
%(just adding a dt bit), and discard the old result
%Calculate the velocity and Position, by integrating.
velocity = cumtrapz(time,acceleration);
position = cumtrapz(time,velocity);

%this the last useful step of the simulation
endOfUsefulData = 0;

%this is the max altitude
maxAltitude = -999999999999; 

%We now ITERATE the position until it is equal or less than 0
%we start ITERATING not from 0, but from a safe value, to avoid "matching" the initial condition
for t = 50:1:(endTime/dt) 
  pos = position(t);
  if pos <= 0
    endOfUsefulData = t;
    break %terminate the Iteration, we have finished here
  end
  
  if pos > maxAltitude
    maxAltitude = pos; 
   end
end

disp('This is the maximum altitude reached')
maxAltitude

%i have no idea what is the built in function to take a subarray
%do a copy of the original 

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

%velocity at impact(position 0)
disp('Speed before the impact')
disp(velocity(endOfUsefulData)) 


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