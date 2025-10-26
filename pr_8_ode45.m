% Ejercicio 1: Motor DC con ODE45 - CORREGIDO
% Parámetros del sistema
Ra = 2;        % Resistencia de armadura (Ohm)
La = 0.023;    % Inductancia de armadura (H)
Kt = 0.01;     % Constante de par (N·m/A)
Ke = 0.01;     % Constante de fuerza contraelectromotriz (V·s/rad)
b = 0.0012;    % Coeficiente de fricción viscosa (N·m·s/rad)
J = 0.001;     % Momento de inercia (kg·m²)

% Voltaje de entrada ajustado para obtener θm ≈ 20 rad
va = 5;  % Voltaje aumentado

% Función del sistema de ecuaciones diferenciales
% Variables de estado: x(1) = ia, x(2) = θm, x(3) = ωm
motor_dc = @(t,x) [
    (va - Ra*x(1) - Ke*x(3)) / La;      % dia/dt
    x(3);                                 % dθm/dt = ωm
    (Kt*x(1) - b*x(3)) / J               % dωm/dt
];

% Condiciones iniciales [ia0, θm0, ωm0]
x0 = [0; 0; 0];

% Tiempo de simulación
tspan = [0 10];  % 10 segundos como en tu gráfica

% Solución con ODE45
[t, x] = ode45(motor_dc, tspan, x0);

% Extracción de variables
ia = x(:,1);      % Corriente de armadura
theta_m = x(:,2); % Posición angular
omega_m = x(:,3); % Velocidad angular

% Gráfica - Solo Velocidad Angular
figure('Position', [100 100 800 500]);
plot(t, omega_m, 'LineWidth', 2.5, 'Color', [0.85 0.65 0.13])
grid on
xlabel('Tiempo (s)', 'FontSize', 11)
ylabel('Velocidad \omega_m (rad/s)', 'FontSize', 11)
title('Velocidad Angular del Motor', 'FontSize', 12, 'FontWeight', 'bold')
xlim([0 10])
ylim([0 max(omega_m)*1.1])
set(gca, 'Color', [0.15 0.15 0.15], 'GridColor', [0.3 0.3 0.3])

% Par del motor (calculado pero no graficado)
T_motor = Kt * ia;

% Mostrar valores finales
fprintf('\n=== RESULTADOS FINALES (t = %.1f s) ===\n', t(end))
fprintf('Posición final:   %.4f rad (%.2f revoluciones)\n', theta_m(end), theta_m(end)/(2*pi))
fprintf('Velocidad final:  %.4f rad/s\n', omega_m(end))
fprintf('Corriente final:  %.4f A\n', ia(end))
fprintf('Par final:        %.6f N·m\n', T_motor(end))

% Verificación
fprintf('\nVerificación de estado estacionario:\n')
fprintf('Velocidad teórica: ωm = va/(Ke + Ra*b/Kt) = %.4f rad/s\n', va/(Ke + Ra*b/Kt))
fprintf('Corriente teórica: ia = b*ωm/Kt = %.4f A\n', b*omega_m(end)/Kt)