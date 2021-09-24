%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Codigo do trabalho pratico final ELC 1046
% Aluno Vinicius Hardt Schreiner
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load nos PKG necessários                          %
clear all;
pkg load signal;
pkg load communications;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definição da mensagem a ser enviada e frequencias %
msg = "Teste";
TB = 24;  % Taxa de bits
Fp = 2000; % Frequência da portadora
Fa = 48000; % Taxa de amostragem

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Geração do sinal a ser transmitido                %
ytx = transmissor(msg, TB, Fp, Fa); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Printa o tamanho o sinal                          %
disp(['Tamanho do sinal: ' num2str(length(ytx)) ' amostras'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transmissão do sinal usando a placa de som        %
soundsc(ytx,Fa);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcula o tamanho do sinal e define os tempos     %
Lsig=length(ytx);
td=1/8000; 
t=td:td:1; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcula a Transformada Rapida de Fourier          %
Lfft=2^ceil(log2(Lsig)+1);
Fmax=1/(2*td);
Faxis=linspace(-Fmax,Fmax,Lfft);
Xsig=fftshift(fft(ytx,Lfft));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plota o grafico do sinal transmitido              %
figure(1);

subplot(311); sfig1a=plot(ytx);
set(sfig1a,'LineWidth',2);
xlabel('');
title('Sinal transmitido');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plota o grafico do espectro do sinal transmitido  %
subplot(312); sfig1b=stem(Faxis(1:Lfft),abs(Xsig));
set(sfig1b,'LineWidth',1);
xlabel('frequência (Hz)');
title('Espectro do sinal transmitido');