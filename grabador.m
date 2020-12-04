%grabar a 70% del volumen de la pc
clear; %limpiar variables Workspace
samp=2*4000;%frecuencia de sampling(2* frecuencia maxima deseada) 
rec = audiorecorder(samp,16,1);%muestras c/40000, amplitud 16 bits/1 canal
disp('Comienzo de sampling')
recordblocking(rec, 60*4+11);%Grabando 5 segundos
disp('Fin de sampling')
migrab= getaudiodata(rec);%Obteniendo el arreglo del audio de grabación
migrab=migrab./size(migrab);
Le=length(migrab);%tamaño de la señal
F=fft(migrab); %arreglo de transformada rápida de Fourier, cambia de tiempo a frecuencia
Fou=abs(F); %valores absolutos de los obtenidos por la transformada de Fourier;
locs = samp*(0:(Le/2))/Le;%Convertir el eje x a frecuencia
pks=Fou(1:Le/2+1);%Amplitud de la mitad de los valores en Fou    

 

