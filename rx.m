%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Codigo do trabalho pratico final ELC 1046
% Aluno Vinicius Hardt Schreiner
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load nos PKG necessários                          %
clear all;
pkg load signal;
pkg load communications;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definição das taxas e frequencias da recepcao     %
TB = 16;  % Taxa de bits
Fp = 2000; % Frequência da portadora
Fa = 48000; % Taxa de amostragem

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Captura do sinal de audio                         %
NS = 0;  
NS_min = 0.1;      % nível de sensibilidade - ajustar conforme necessário
t_captura = 10;     % tempo de captura do sinal
while NS < NS_min
    y = record(t_captura, Fa);
    if ~isempty(y)
      NS = max(y);
    end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcula o tamanho do sinal e define os tempos     %
Lsig=length(y);
td=1/8000; 
t=td:td:1; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcula a Transformada Rapida de Fourier          %
Lfft=2^ceil(log2(Lsig)+1);
Fmax=1/(2*td);
Faxis=linspace(-Fmax,Fmax,Lfft);
Xsig=fftshift(fft(y,Lfft));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Printa o valor de deteccao do sinal               %
disp(['Valor de detecção do sinal: ' num2str(NS)]);

yrx = receptor(y, TB, Fp, Fa);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plota o grafico do sinal recebido                 %
figure(1);
subplot(311); sfig1a=plot(y);
set(sfig1a,'LineWidth',2);
xlabel('');
title('Sinal recebido');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plota o grafico do espectro do sinal recebido     %
subplot(312); sfig1b=stem(Faxis(1:Lfft),abs(Xsig));
set(sfig1b,'LineWidth',1);
xlabel('frequência (Hz)');
title('Espectro do sinal recebido');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plota a saida digital recebida                    %
subplot(313); sfig1b=stem(yrx);
set(sfig1b,'LineWidth',1);
xlabel('bits');
title('saida do receptor');

%x = bi2de(reshape(yrx,8,l)')';
%msg = char(x); 
%disp(["Mensagem recebida: " msg]);