function varargout = OAM_Rotational_Antenna_GUI(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OAM_Rotational_Antenna_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OAM_Rotational_Antenna_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function OAM_Rotational_Antenna_GUI_OpeningFcn(hObject, eventdata, handles, varargin)

global t
global regs
global errors
global isopen
global isrenew
global card
global datashownum

regs = spcMCreateRegMap();
errors = spcMCreateErrorMap();
isopen = 0;
isrenew = 0;
card = 0;
datashownum = 5000;

ImPeriod = 5000;  %5000ms

handles.output = hObject;
guidata(hObject, handles);

t = timer('TimerFcn', {@timerCallback, handles}, 'ExecutionMode', 'fixedDelay', 'Period', ImPeriod);
set(handles.figure1, 'DeleteFcn', {@DeleteFcn, t, handles});

function varargout = OAM_Rotational_Antenna_GUI_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function timerCallback(hObject, eventdata, handles)
global card
global regs
global errors
global figureRecDataCh0
global figureRecDataCh1
global figureRecDataCh2
global figureRecDataCh3
global channel0Data
global channel1Data
global channel2Data
global channel3Data
[ndatanum, sampleRate] = getdatanum();
sampleTime = 1 / sampleRate;
time = 0 : sampleTime : (ndatanum - 1) * sampleTime; 
[Dat_Ch0, Dat_Ch1, Dat_Ch2, Dat_Ch3] = ...
    card_read_data(card, regs, errors, sampleRate);
channel0Data = Dat_Ch0;
channel1Data = Dat_Ch1;
channel2Data = Dat_Ch2;
channel3Data = Dat_Ch3;


%% Gui close func
function DeleteFcn(hObject, eventdata, t, handles)
stop(t);
close_card(handles);

%% open card
function open_card(handles)
global card
global isopen
global regs
if isopen == 0
    [ndatanum, ~] = getdatanum();
    card = initcard(regs, ndatanum);
    isopen = 1;
end

%% close card
function close_card(handles)

global card
global isopen
if isopen == 1
    spcMCloseCard (card);
    fprintf('card is closed\r\n');
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

% load A_cd2s5ma.mat;
% load A_cd2s10m.mat; % 10 m, a+b
% load A_cd2s10mb.mat; % 10 m, b
% load A_cd2s10mc.mat; % 10 m, 无目标
% load A_cd2s10ma.mat; % 只有a目标 ,10m，但是放回去后第一个幅值小了很多
%  load cd2s25m.mat; %  20m以上  OAM
% load A_cd2s20ma.mat; % 20m以上 无OAM 
%  load cd2s5ma.mat; % 10 m, b
% fun_gui_1DImage(handles, 'A_cd2s10mc.mat');

global isrenew
global t
global figureRecDataCh0
global figureRecDataCh1
global figureRecDataCh2
global figureRecDataCh3
global card
global regs
global errors
global datashownum

open_card(handles);
axes(handles.axes_signal);
[ndatanum, sampleRate] = getdatanum();
sampleTime = 1 / sampleRate;
time = 0 : sampleTime : (ndatanum - 1) * sampleTime;  
[Dat_Ch0, Dat_Ch1, Dat_Ch2, Dat_Ch3] = ...
    card_read_data(card, regs, errors, sampleRate);

fontsize = 18;
figureRecDataCh0 = plot(time(1:datashownum), Dat_Ch0(1:datashownum), 'b');
hold on;
figureRecDataCh1 = plot(time(1:datashownum), Dat_Ch1(1:datashownum), 'g');
figureRecDataCh2 = plot(time(1:datashownum), Dat_Ch2(1:datashownum), 'r');
figureRecDataCh3 = plot(time(1:datashownum), Dat_Ch3(1:datashownum), 'y');
hold off;
legend('Channel0', 'Channel1', 'Channel2','Channel3');
set(gca, 'FontSize', fontsize);
isrenew = 1;
start(t);

guidata(hObject, handles);

function togglebutton1_Callback(hObject, eventdata, handles)
global isrenew
global t
isrenew = 0;
stop(t);
guidata(hObject, handles);

function togglebutton2_Callback(hObject, eventdata, handles)
close_card(handles);
guidata(hObject, handles);
delete(handles.figure1)

function checkbox1_Callback(hObject, eventdata, handles)

checked = get(hObject,'Value');
if checked
    set(handles.togglebutton_rotate,'Enable','on');
    set(handles.togglebutton_pulse,'Enable','on');
else
    set(handles.togglebutton_rotate,'Enable','off');
    set(handles.togglebutton_pulse,'Enable','off');
end 

% --- Executes on button press in edit1.
function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)

function togglebutton_rotate_Callback(hObject, eventdata, handles)

function togglebutton_pulse_Callback(hObject, eventdata, handles)
