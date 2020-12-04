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