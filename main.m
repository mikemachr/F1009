close all
clear
diccionario=importfile('files.csv');
nombres=importfile('names.csv');

resultados=[];
[migrab,rec]=grabar();
[picosSample,frecuenciasSample,anchosSample]=scanner(migrab);
sampleAudio=migrab;

for i=1:size(diccionario)
   load(diccionario(i))
   [frecsCompartidas,donde]=comparador(frecuenciasSample,...
        frecuenciasPlantilla);
    resultados(i)=grader(frecsCompartidas,donde,anchosSample,anchosPlantilla,...
    picosSample,picosPlantilla);
end
[score, indice]=max(resultados);
disp('La canción analizada debe ser: '+string(nombres(indice)))
disp('-------------------------------------------------------------------')


function[migrab,rec]=grabar()
    samp=2*4000;
    rec = audiorecorder(samp,24,1);
    disp('Comienzo de sampling')
    recordblocking(rec, 15);
    disp('Fin de sampling')
    migrab= getaudiodata(rec);
    migrab=migrab./size(migrab);
end

function[pks,locs,w]=scanner(migrab)
    samp=2*4000; 
    Le=length(migrab);
    F=fft(migrab); 
    Fou=abs(F); 
    frecuencias = samp*(0:(Le/2))/Le;
    amplitudes=Fou(1:Le/2+1);
     [pks,locs,w]=findpeaks(amplitudes,frecuencias,'minPeakHeight',...
        2*std(amplitudes)+mean(amplitudes));
    locs=round(locs,1);
end


function[frecs,matched]=comparador(fSample,fPlantilla)
    frecs=[];
    k=1;
    matched=[];
    for i=1:size(fSample,2)
        for j=1:size(fPlantilla,2)
            if fSample(i)==fPlantilla(j)
                frecs(k)=fPlantilla(j);
                matched(k)=i;
                k=k+1;
            end
        end
    end
end

function [overall]=grader(frecuenciasMatch,indexMatch,anchosSample,...
    anchosPlantilla,amplitudesSample,amplitudesPlantilla)
    a=size(frecuenciasMatch,2)/size(amplitudesPlantilla,2);
    e=[];
    w=[];
    for i=1:size(amplitudesPlantilla)
        e(i)=abs(amplitudesPlantilla(indexMatch(i))-amplitudesSample(i))...
            /size(amplitudesPlantilla,2);
        w(i)=abs(anchosPlantilla(indexMatch(i))-anchosSample(i))/...
            size(amplitudesPlantilla,2);
    end
%      disp((1-sum(e)*1e7)*5)
%      disp(a*100)
%      disp(5*(1-sum(w)*10000))
     overall=100*a+(1-sum(e)*1e7)*5+5*(1-sum(w)*10000);
end


