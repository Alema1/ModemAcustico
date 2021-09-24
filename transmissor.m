function y = transmissor(msg, TB, Fp, Fa)

%%%%%%%%%%%%%%%%%%%%%%  Entrada do transmissor   %%%%%%%%%%%%%%%%
%   msg -- Dados a serem transmitidos
%   TB  -- Taxa de bits
%   Fp  -- Frequ�ncia da portadora
%   Fa  -- Frequ�ncia de amostragem da placa de som
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Exemplo de uso        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% msg = "ABC";
% TB = 100;
% Fp = 2000;
% Fa = 8000;
% sinal_gerado = transmissor(msg, TB, Fp, Fa) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transmiss�o do sinal usando a placa de som        %
% soundsc(sinal_gerado,Fa);   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% Pacotes de software
pkg load signal;
pkg load communications;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%% In�cio 
l = length(msg);        % tamanho da mensagem em bits
msg = double(msg);      % converte texto em decimal
% monta mensagem em quadro de bits
% primeiros 8 bits s�o o tamanho do quadro
msg = reshape(de2bi([l msg],8)',1,8*(l+1));  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Preambulo do quadro                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PRE = [ones(1,10) upsample(ones(1,15),2)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Marcador de in�cio do quadro  (SFD)           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SFD = [1 1 0 0 1 1 1 0 0 0 1 1 1 1 0 0 0 0 1 1 1 0 0 0 1 1 0 0 1 0 1 0 1 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Enquadramento                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
msg = [PRE SFD msg PRE];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Codifica��o em banda Base                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = [-1,1];
y = s(msg+1);                        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  N�mero de s�mbolos                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Tamanho do quadro: ' num2str(length(y)) ' s�mbolos'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Filtragem para formata��o de pulso          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r = 0.5;                              % Fator de decaimento (roll-off) 
TB_f = Fa/floor(Fa/TB);               % Ajuste da taxa de bits 
num = rcosine(TB_f,Fa,'default',r);   % Projeto do filtro SRRC (square-root-raised-cosine filter)
y = rcosflt(y,TB_f,Fa,'filter',num)'; % Filtragem SRRC


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Modula��o em Banda Passante                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = (0:length(y) - 1)/Fa;           
y = y.*cos(2*pi*Fp*t);              % Modula��o BPSK

endfunction


              


