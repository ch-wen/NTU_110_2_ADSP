%% Frequency sampling method Hilbert transform filter

% Student name: Chieh-Hsun, Wen
% Student Id:   R10945006

% ADSP HW2 (1), design a Hilbert transform filter by frequency sampling method
% Shows impulse and frequency response

% Parameter
clear;clc;
k = input('k (Input parameter, can be any integer): ');
N = 2*k+1;
step = 0.0001;
F = 0:step:1;
f = 0:1/N:1-1/N;
L = length(F);
sampling_interval = L/N;

% Hd
Hd = zeros(1,L);
for i = 1:L
    if (F(i)<0.5)
        Hd(i) = -1;
    elseif(F(i)==0.5)
        Hd(i) = 0;
    else
        Hd(i) = 1;
    end
end

% Sampling
Hd_sampling = zeros(1,N);
sample = NaN(1,L);
for i = 1:N
    if(i==1)
        Hd_sampling(i) = Hd(1);
        sample(i) = -1;
    else
        Hd_sampling(i) = Hd(round((i-1)*sampling_interval));
        sample(round((i-1)*sampling_interval)) = Hd_sampling(i);
    end
end

% R
r1 = ifft(Hd_sampling);
r = fftshift(r1);
R = zeros(N,L);
for i = 1:N
    R(i,:) = r(i)*exp(-1i*2*pi*F*((i-1)-(N-1)/2)); %-~0~+
end
R = sum(R);

% Frequency reponse
figure;
plot(f,real(Hd_sampling),F(1:sampling_interval*(N-1)),real(R(1:sampling_interval*(N-1))));hold on;
plot(F,sample,'o');hold off;
title('Frequency Response');
xlabel('F');
xlim([0 1])
legend('Hd(F)','R(F)','Sampling');

% Impulse response
r1 = ifft(Hd_sampling);
r1_tmp = fliplr(r1(2:end));
r1(2:end) = r1_tmp;
r = fftshift(r1);
figure;
subplot(311)
stem(0:N-1,imag(r1));
legend('r1[n]');
title("Impulse Response");
xlim([-N-5 N+5]);
ylim([-1 1]);
subplot(312)
stem(-k:k,imag(r))
legend('r[n]');
xlim([-N-5 N+5]);
ylim([-1 1]);
subplot(313)
stem(0:N-1,imag(r))
legend('h[n]');
xlabel('Samples');
xlim([-N-5 N+5]);
ylim([-1 1]);
