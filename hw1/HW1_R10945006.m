%% Mini-max lowpass filter

% Student name: 温皆循
% Student Id:   R10945006

% ADSP HW1 (1), design a mini-max lowpass filter:
% Filter lenth = 17
% Smapling frequency = 6000Hz
% Pass band = 0~1200Hz
% Transition band = 1200~1500Hz
% Weight function = 1 for pass band, 0.6 for stop bandwidth
% delta = 0.0001
clear;clc;

N = 17;                        % Filter length
fs = 6000;                     % Sampling frequency [Hz]
pass_band = [0 1200]/fs;       % ~ [Hz] -> Fn
trans_band = [1200 1500]/fs;   % ~ [Hz] -> Fn
weight = [1 0.6];              % [pass stop] [Hz] -> Fn
step = 0.0001;                 % frequency step
%
k = (N-1)/2;
k_2 = k+2;
F = 0:0.5/k_2:0.5-(0.5/k_2);
fline = 0:step:0.5;
max_error_pre = inf;
%
error_num = 1;
while(1)
    square = zeros(k_2,k_2);
    for i = 1:k_2
        if i==k_2
            for j = 1:k_2
                if F(j) >= trans_band(2)
                    if mod(j,2)==1
                        square(j,i) = 1/weight(2);
                    else
                        square(j,i) = -1/weight(2);
                    end
                end
                if F(j) <= trans_band(1)
                    if mod(j,2)==1
                        square(j,i) = 1/weight(1);
                    else
                        square(j,i) = -1/weight(1);
                    end
                end
            end
        else
        square(:,i) = cos((i-1)*2*pi*F);
        end
    end
    fil = logical(F<=pass_band(2))';
    s = square\fil;
    j = 0;
    R = zeros(length(fline),k_2-1);
    for i = 1:k_2-1
            R(:,i) = s(i)*cos((j)*2*pi*fline);
            j = j+1;
    end
    R_sum = sum(R,2);
    H = logical(fline<=pass_band(2))';
%     figure;
%     plot(fline,R_sum);hold on;
%     plot(fline,H);
    error = R_sum-H;
    for i = 1:length(fline)
        if fline(i)<=trans_band(1)
            error(i) = error(i)*weight(1);
        elseif fline(i)>=trans_band(2)
            error(i) = error(i)*weight(2);
        else
            error(i) = error(i)*0;
        end
    end
    % find extreme
    max_x = islocalmax(error);
    min_x = islocalmin(error);
    extreme = logical(max_x+min_x);
    extreme(1) = true;
    extreme(end) = true;
%     figure;
%     plot(fline,error,fline(extreme),error(extreme),'r*')
    F = fline(extreme);
    max_error(error_num) = max(abs(error(round((F+step)/step))));
    if abs(max_error_pre-max_error(error_num)) <=step
        break;
    else
        max_error_pre = max_error(error_num);
        error_num = error_num+1;
    end
end
% Calculate impulse response
h = zeros(1,N); % impulse response
j = 0;
for i = 1:(N+1)/2
    if i==(N+1)/2
        h(i) = s(k_2-1-j);
    else
        h(i) = s(k_2-1-j)/2;
        h(N+1-i) = s(k_2-1-j)/2;
        j = j+1;
    end
end
% plot answer of HW1 (1)
figure
stem(h,'-d');
title('Impulse response');
xlabel('N');
figure
plot(fline,R_sum);hold on;
plot(fline,H);
title("Frequency response")
xlabel('Normalized frequency');
legend("R(F)","Hd(F)");
disp("The maximal reeor for each iteration:");
disp(max_error);
%% plot error
% figure
% plot(max_error,'-o');
% title('Maximal error for each iteration');
% xlabel('Iteration');
% figure
% plot(fline,error,fline(extreme),error(extreme),'r*')
% title('Error: Final iteration');
% xlabel('F');