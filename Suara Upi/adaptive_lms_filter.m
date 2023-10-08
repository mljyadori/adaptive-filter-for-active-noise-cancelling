clc
clear all
close all

% [x,Fs]= audioread("Noise + Signal.m4a");
% x = transpose(x(:,1));

% n = randnoise(x,Fs);

% [n,Fs1]= audioread("Noise Orang.wav");
% [n,Fs1]= audioread("Noise Tukang.wav");
 [n,Fs1]= audioread("Noise Mobil.wav");
Fs = Fs1
n = transpose(n(:,1));

% [d,Fs2]= audioread("Orang_Edit.wav");
% [d,Fs2]= audioread("Tukang_Edit.wav");
 [d,Fs2]= audioread("Kendaraan_Edit.wav");
d = transpose(d(:,1));

if length(d)>length(n)
    d = d(1,1:length(n));
else
    n = n(1,1:length(d));
end

%[d,Fsd]= audioread("Noise + Signal.m4a");
%d = transpose(d(:,1));
% x=d-n;
% d=x+n; % Generate signal plus noise

% this is where filtering happens
mu = 0.01;
lms = dsp.LMSFilter(30,'StepSize',mu);
[y,e,w] = lms(transpose(n),transpose(d));

% writing filter error output to sound file so you could play it~
filename = 'filtered_mobil_upi.wav';
audiowrite(filename,e,Fs1);
filename = 'noise_expected_mobil_upi.wav';
audiowrite(filename,y,Fs1);

% Calculate the single-sided amplitude spectrum for the original signal
Y=fourier_spectrum(y);
% Calculate the single-sided amplitude spectrum for the corrupted signal
D=fourier_spectrum(d);
f=[0:1:length(y)/2]*Fs/length(y);
% Calculate the single-sided amplitude spectrum for the noise-cancelled signal
E=fourier_spectrum(e);
% X=fourier_spectrum(x);
% Plot signals and spectrums
% subplot(4,1,1), plot(x);grid; ylabel('Orig. speech');
subplot(3,1,1),plot(d);grid; ylabel('Corrupted Speech(d)');
title('Signals in Discrete Time Domain');
subplot(3,1,2),plot(y);grid;ylabel('Noise Cancelling(y)');
subplot(3,1,3),plot(e);grid;; ylabel('Clean Speech(e)');
% subplot(4,1,4),plot(x);grid;; ylabel('Clean speech');

xlabel('Number of samples');
figure
% subplot(3,1,1),plot(f,x(1:length(f)));grid
% ylabel('Orig. spectrum')
subplot(3,1,1),plot(f,D(1:length(f )));grid; ylabel('Corrupted Speech(d)');
title('Signals in Frequency Domain');
subplot(3,1,2),plot(f,Y(1:length(f )));grid; ylabel('Noise Cancelling(y)');
subplot(3,1,3),plot(f,E(1:length(f )));grid; ylabel('Clean Speech(e)'); 
% subplot(4,1,4),plot(f,X(1:length(f )));grid; ylabel('Clean spectrum'); 
xlabel('Frequency (Hz)');

% err = abs(abs(e'-d)./d);
% 
[h,wau]=freqz(w,1,length(d));
% 
figure

subplot(2,1,1),plot(wau/pi,db(h));grid;ylabel('Magnitude (dB)');
title('Frequency Response of Adaptive LMS Filter')
subplot(2,1,2),plot(wau/pi,angle(h)/pi);grid;ylabel('Phase Shift (\pi)');
xlabel('Frequency (\pi)')


function n = randnoise(x,fs)
t=0:1:length(x)-1; % Create index array
t=t/fs; % Convert indices to time instant
x=randn(1,length(x)); % Generate random noise
n=filter([ 0 0 0 0 0 0.5 ],1,x); % Generate the corruption noise
end

function y =fourier_spectrum(x)
y = 2*abs(fft(x))/length(x);
y(1)=y(1)/2;
end