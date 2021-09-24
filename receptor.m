function [x,l] = receptor(yrx, TB, Fp, Fa)
%%%%%%%%%%%%%%%%%%%%%%  Entrada do receptor   %%%%%%%%%%%%%%%%
%   yrx -- sinal de a�dio capturado
%   TB  -- Taxa de bits
%   Fp  -- Frequ�ncia da portadora
%   Fa  -- Frequ�ncia de amostragem da placa de som
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Exemplo de uso        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TB = 100;
% Fp = 2000;
% Fa = 8000;
% y = record(10,Fa); % grava 10s de �udio
% sinal_recebido = receptor(y,TB, Fp, Fa) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% Pacotes de software
pkg load signal;
pkg load communications;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Demodula��o                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = yrx;
t = (0:length(y) - 1)/Fa;         % instantes de amostragem
y = y.*cos(2*pi*Fp*t)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Sincroniza��o de s�mbolo                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yf = y;
st = ceil(Fa/TB); 
si=st:st:length(yf);
y = yf(si);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Decodifica��o                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = y > 0; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Sincroniza��o do quadro                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SFD = [1 1 0 0 1 1 1 0 0 0 1 1 1 1 0 0 0 0 1 1 1 0 0 0 1 1 0 0 1 0 1 0 1 0 1];
xc = xcorr(SFD*2 -1,double(x)*2 - 1);
[a,i] = max(abs(xc));               
if a < length(SFD)*0.9                          
  disp('Muitos erros para decodificar os dados');
end
if xc(i) < 0                        
    x = ~x;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Remover cabe�alho SFD                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i = length(x) - i + length(SFD);
x = x(i+1:end);
l = bi2de(x(1:8)'); % primeiro byte � o n�mero de bytes da mensagem 
x = x(9:min(end,(l+1)*8)); % retorna a mensagem recebida

endfunction
