%% Anaylsis_ERP
clear all; clc; close all;
%% initialization
DATADIR = 'WHERE\IS\DATA';
%% ERP
ERPDATA = 'EEG_ERP.mat';
STRUCTINFO = {'EEG_ERP_train', 'EEG_ERP_test'};
SESSIONS = {'session1', 'session2'};
TOTAL_SUBJECTS = 54;

%% INITIALIZATION
FS = 100;

%% PERFORMANCE PARAMETERS
MATRICES = {'A', 'B', 'C', 'D', 'E', 'F', ...
        'G', 'H', 'I', 'J', 'K', 'L', ...
        'M', 'N', 'O', 'P', 'Q', 'R', ...
        'S', 'T', 'U', 'V', 'W', 'X', ...
        'Y', 'Z', '1', '2', '3', '4', ...
        '5', '6', '7', '8', '9', '_'};
    
params = {'fs',FS; ...
    'task',{'p300_off','p300_on'}; ...
    'channel_index', [1:32]; ...
    'band', [0.5 40]; ...
    'segTime', [-200 800]; ...
    'baseTime', [-200 0]; ...
    'selTime', [0 800]; ...
    'nFeature',10; ...
    'init_speller_length',1; ...
    'Nsequence', 5;...
    'one_seq_time', 2.75; ...
    'speller_text',  MATRICES;...
    'spellerText_on', 'PATTERN_RECOGNITION_MACHINE_LEARNING'
};
%% VALIDATION
for sessNum = 1:length(SESSIONS)
    session = SESSIONS{sessNum};
    fprintf('\n%s validation\n',session);
    for subNum = 1:TOTAL_SUBJECTS
        subject = sprintf('s%d',subNum);
        fprintf('LOAD %s ...\n',subject);
        
        data = importdata(fullfile(DATADIR,session,subject,ERPDATA));
        
        CNT{1} = prep_resample(data.(STRUCTINFO{1}), FS,{'Nr', 0});
        CNT{2} = prep_resample(data.(STRUCTINFO{2}), FS,{'Nr', 0});
        [ACC.P300(subNum,sessNum), ACC.P300_itr(subNum,sessNum)] = erp_performance(CNT, params);
        fprintf('%s = %.2f\n',subject, ACC.P300(subNum,sessNum));
        clear CNT
    end
end

