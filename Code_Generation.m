% Script to Automatically Open MATLAB, Simulink, and Configure Code
% Generation for 280049C Launchpad from Texas intrumentss 


% Create or Open a New Model
modelName = 'Code_Generation';
if ~bdIsLoaded(modelName)
    new_system(modelName, 'Model');
end
open_system(modelName);

% Configure the Model for Embedded Real-Time (ERT) Code Generation
set_param(modelName, 'Solver', 'ode4');
set_param(modelName, 'SystemTargetFile', 'ert.tlc');
set_param(modelName, 'TemplateMakefile', 'ert_default_tmf');
set_param(modelName, 'GenerateReport', 'on');
set_param(modelName, 'GenCodeOnly', 'off');
set_param(modelName, 'MakeCommand', 'make_rtw');
set_param(modelName, 'ERTCustomFileTemplate', 'example_file_process.tlc');
set_param(modelName, 'ConfigurationSetName', 'ERTDefaultConfig');

% Set Code Generation Options
cs = getActiveConfigSet(modelName);
set_param(cs, 'GenerateComments', 'on');
set_param(cs, 'RetainRTWFile', 'off');
set_param(cs, 'InlineInvariantSignals', 'on');
set_param(cs, 'OptimizeBlockIOStorage', 'on');
set_param(cs, 'CombineOutputUpdateFcns', 'on');
set_param(cs, 'InlineParameters', 'on');

% Specify Hardware Implementation Options
set_param(cs, 'HardwareBoard', 'TI Piccolo F280049C LaunchPad'); % Adjusted for TI Piccolo F280049C LaunchPad
set_param(cs, 'ProdHWDeviceType', 'TI->C2000'); % Example target hardware

% Additional Peripheral and Clock Settings
set_param(cs, 'HardwareBoardClockRate', '100MHz'); % Adjust to the specific clock rate
set_param(cs, 'EnablePeripheralClocks', 'on'); % Enable required peripheral clocks
set_param(cs, 'EnablePWM', 'on'); % Enable PWM peripheral
set_param(cs, 'EnableADC', 'on'); % Enable ADC peripheral

% Add Blocks Programmatically
% Add a PWM block
add_block('c2000lib/PWM', [modelName, '/PWM1']);
set_param([modelName, '/PWM1'], 'PWMModule', 'ePWM1', 'DutyCycle', '50');

% Add an ADC block
add_block('c2000lib/ADC', [modelName, '/ADC1']);
set_param([modelName, '/ADC1'], 'ADCModule', 'ADC_A', 'SampleRate', '500kHz');

% Configure Pin Mapping
% Example: Configure GPIO for UART
set_param(cs, 'UART_TX_Pin', 'GPIO42');
set_param(cs, 'UART_RX_Pin', 'GPIO43');

% Enable Real-Time Parameter Tuning
set_param(cs, 'ExtMode', 'on');
set_param(cs, 'ExtModeTransport', 'serial');
set_param(cs, 'SerialBaudRate', '115200');




% Build the Model to Verify Code Generation Settings
slbuild(modelName);

% Display Completion Message
disp('Simulink model prepared for ERT code generation and built successfully.');
