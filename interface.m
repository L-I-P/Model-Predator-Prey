function varargout = interface(varargin)
% INTERFACE MATLAB code for interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface

% Last Modified by GUIDE v2.5 14-Jul-2020 19:39:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @interface_OpeningFcn, ...
    'gui_OutputFcn',  @interface_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface (see VARARGIN)

% Choose default command line output for interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
cla reset; %полный перебор и сброс осей
alpha = str2double(get(handles.lambda,'String'));
beta = str2double(get(handles.beta,'String'));
gamma = str2double(get(handles.gamma,'String'));
delta = str2double(get(handles.delta,'String'));
lambda = str2double(get(handles.lambda,'String'));
c = str2double(get(handles.c,'String')); %0.001 <= c <= 0.01
rho = str2double(get(handles.rho,'String'));
prey = 1;      %жертвы
predators = 1; %хищники

t0 = 0.1;                      %шаг
seconds = 30;                  %время
iterations = ceil(seconds/t0); %итерации
time = 0:t0:seconds;

%инициализация массивов
x1 = zeros(1,iterations);
x2 = zeros(1,iterations);
psi = zeros(1,iterations);
xi1 = zeros(1,iterations);

% начальные значения (на 0 шаге. в матлабе с 1)
x1(1,1) = prey;
x2(1,1) = predators;
psi(1,1) = x1(1,1) - rho*x2(1,1); %по заданию разница стремится к нулю
xi1(1,1) = normrnd(0,0.1); %шум только по координате с управлениям (м.о. равно 0, с.к.о. равно 0.1)

%вычисление значений на k = 1 шаге для некоторых формул. это
%связано с использованием значений k - 1 (например, x1)
xi1(1,2) = normrnd(0,0.1);
x1(1,2) = -(lambda + c)*psi(1,1) + rho*(x2(1,1) + t0*(x2(1,1)*(delta*x1(1,1) - gamma))) + t0*(xi1(1,2) + c*xi1(1,1));
x2(1,2) = x2(1,1) + t0*(x2(1,1)*(delta*x1(1,1) - gamma));

for k = 2:iterations
    xi1(1,k + 1) = normrnd(0,0.1); %шум только по координате с управлениям (м.о. равно 0, с.к.о. равно 0.1)
    psi(1,k) = x1(1,k) - rho*x2(1,k); %по заданию разница стремится к нулю
    x1(1,k + 1) = -(lambda + c)*psi(1,k) - c*lambda*psi(1,k - 1) + rho*(x2(1,k) + t0*(x2(1,k)*(delta*x1(1,k) - gamma))) + ...
        t0*(xi1(1,k + 1) + c*xi1(1,k));
    x2(1,k + 1) = x2(1,k) + t0*(x2(1,k)*(delta*x1(1,k) - gamma));
end

%отрисовка
plot(time, x1, 'r', time, x2, 'b')
animal = legend('жертвы','хищники');
xlabel('время')
ylabel('количество особей')
set(animal)
line2 = sprintf('alpha = %.1f, beta=%.1f, gamma=%.1f, delta=%.1f, lambda=%.1f, c=%.3f, rho=%.1f, t0 = %.1f',...
    alpha, beta, gamma, delta, lambda, c, rho, t0);
title(line2)


function delta_Callback(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta as text
%        str2double(get(hObject,'String')) returns contents of delta as a double


% --- Executes during object creation, after setting all properties.
function delta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gamma as text
%        str2double(get(hObject,'String')) returns contents of gamma as a double


% --- Executes during object creation, after setting all properties.
function gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beta_Callback(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beta as text
%        str2double(get(hObject,'String')) returns contents of beta as a double


% --- Executes during object creation, after setting all properties.
function beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double


% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rho_Callback(hObject, eventdata, handles)
% hObject    handle to rho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rho as text
%        str2double(get(hObject,'String')) returns contents of rho as a double


% --- Executes during object creation, after setting all properties.
function rho_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c_Callback(hObject, eventdata, handles)
% hObject    handle to c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c as text
%        str2double(get(hObject,'String')) returns contents of c as a double


% --- Executes during object creation, after setting all properties.
function c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambda_Callback(hObject, eventdata, handles)
% hObject    handle to lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambda as text
%        str2double(get(hObject,'String')) returns contents of lambda as a double


% --- Executes during object creation, after setting all properties.
function lambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
