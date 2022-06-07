classdef GlobalConfig < handle
    % GlobalConfig   Global parameters for simulation
    %
    % Some parameters are needed by almost all calculations, this is the
    % place to put them.
    % All classes that need access to this parameter shoud inherit from 
    % this class.
    % Users should include a copy of this file in the main script folder,
    % which should have all the parameters set to that particular
    % simulation.
    properties(Hidden, SetAccess = public, GetAccess = public)
        fs = 80e6;                  % [Hz]      the sampling frequency
        c = 1540;                   % [m/s]     the speed of sound in the liquid
        P_0 = 101325;               % [Pa]      the ambient pressure
        rho_l = 997;                % [kg/m^3]  the density of the surrounding liquid
        sigma_l = 0.073;            % [N/m]     the surface tension of the surrounding liquid
        mu_l = 0.001;               % [Pa s]    the viscosity of the surrounding liquid
        fs_bub = 1e9;               % [Hz]      the sampling frequency for bubble response calculation
    end
end