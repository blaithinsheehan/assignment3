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


%this is the max altitude
maxAltitude = -999999999999; 
lastTimeTick = 0;


%positions must be integers so divide by dt and multiply at at the end 

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
lastTimeTick = t;



%current position
pos = position(t);

%skip initial timestep due to error in computing the initial space integral
if t > 100 pos < 0
    break %terminate the Simulation, we have finished here
  end
  
   if pos > maxAltitude
    maxAltitude = pos; 
   end
   
end


disp('This is the maximum altitude reached')
maxAltitude


%velocity at impact(position 0)
disp('Speed before the impact')
disp(velocity(lastTimeTick)) 


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