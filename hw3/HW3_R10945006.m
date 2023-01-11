%% Convert a numbered musical noration into a music file

% Student name: Chieh-Hsun, Wen
% Student Id:   R10945006

% ADSP HW3 (1), convert a numbered musical noration into a music file
% Beside basic function, four additional function
% 1. Volume adjustment 
% 2. Tempo adjustment 
% 3. Decay level adjustment (seperation)
% 4. Do frequency adjustment: Bass, Alto, Treble
% 5. Plus pause function for notation is 0
% 6. Check score and beat are resonable and matchable or not

clear;clc;

volume = 1;  % volume
tempo = 180; % per min
decay = -5; % seperate more clear, not too much
Do_basement = 'Alto'; % Bass, Alto, Treble
score = [1, 1, 5, 5, 6, 6, 5, 0, 4, 4, 3, 3, 2, 2, 1]; % 1~7:Do~Si, 0:Pause
beat  = [1, 1, 1, 1, 1, 1, 2, 0.5, 1, 1, 1, 1, 1, 1, 2];
name = 'twinkle'; 

getmusic(volume, tempo, decay, Do_basement, score, beat, name);

function getmusic(volume, tempo, decay, Do_basement, score, beat, name)
    sL = length(score);
    bL = length(beat);
    % Sample frequency
    fs = 10000;
    time_interval = 60/tempo; % Between two sound
    % Check reasonable
    if(sL ~= bL)
        disp('Score and beat are not matchable!');
        return;
    end
    if(find(score<0|score>7))
        disp('Score should be integers for 0~7!');
        return;
    end
    if(find(beat<0))
        disp('Beat should be integer larger than 0!');
        return;
    end
    if(decay>0)
        decay = -1*decay; % must be minus
    end
    % Set notation
    switch Do_basement
        case 'Bass'
            disp('Bass, Do frequency is 131.32 Hz');
            Do = 131.32;
        case 'Alto'
            disp('Alto, Do frequency is 261.63 Hz');
            Do = 261.63;
        case 'Treble'
            disp('Treble, Do frequency is 523.26 Hz');
            Do = 523.26;
        otherwise
            disp('Default: Alto, Do frequency is 261.63 Hz');
            Do = 261.63;           
    end
    Re = Do*2^(2/12);
    Mi = Do*2^(4/12);
    Fa = Do*2^(5/12); %half
    So = Do*2^(7/12);
    La = Do*2^(9/12);
    Si = Do*2^(11/12);
    notation = [0, Do, Re, Mi, Fa, So, La, Si];
    % Melody combination
    melody = [];
    for i = 1 : sL
        t = 1/fs:1/fs:time_interval*beat(i);
        melody = [melody, (volume*sin(2*pi*notation(score(i)+1)*t).*exp(decay*t))]; %decay
    end
%     figure;plot(melody);
    % Save for .wav
    sound(melody, fs)
    filename = [name '.wav'];
    audiowrite(filename, melody, fs);
    disp('Finish!')
end