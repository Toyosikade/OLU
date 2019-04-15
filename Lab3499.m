fc = 915e6; fs = 1e6;
ns = 4096; tf =ns/fs; %Time per frame=#samples/sampling freq
hsdr = comm.SDRRTLReceiver('0','centerFrequency',fc,...
    'EnableTunerAGC',true,'SampleRate',fs, ...
    'SamplesPerFrame',ns,OutputDataType','double',...
    'FrequencyCorrection',fo);
hacor = dsp.Autocorrelator('MaximumLagSource','Property',...
    'MaximumLag',16,'Scaling','Biased','Method','Time Domain');
%dltsb = [1;1;0;0;1;1;0;1;0;1;1;1;1
dltsc(1:53,1) = complex(2*dltsb-1, eps+zeros(53,1));
dltsf(1:64,1) = [dltsc(27:53,1);eps+complex(zeros(11,1)); ...
    dltsc(1:26,1)];
dltso(1:64,1) = ifft(dltsf,64); %OFDM-Modulate Long Training Symbol
dltsx = (dltso(64:-1:1,1))'; %Xcorr Arg:Rev, conj Transpose
i = 0;
for tc = 0:tf:te
    dsdr = hsdr();
    if (i>0), dsdra((i-1)*ns+1:i*ns,1) = dsdr; end
    i = i+1;
end
release(hsdr)
last31 = complex(eps,eps)+zeros(31,1);
last64 = complex(eps,eps)+zeros(31,1);
acor = complex(eps,eps)+zeros(ns*(nf-1),1); xcor = acor;
thrcmp = 0.45; ifal = []; fsts = false;
vltspk = []; iltspk = [];
for i = 1:nf-1
    dsdr = dsdra((i-1)*ns+1:i*ns,1);
    dsdr31(1:31,1) = last31;
    dsdr63(1:63,1) = last63;
    dsdr31(32:31+ns) = dsdr;
    dsdr63(64:63+ns) = dsdr;
    for j = 1:ns
        acor = hacor(dsdr31(j:j+31,1));
        k = (i-1)*ns+j;
        dace(k,1) = acor(17); %autocorrelation estimate lag 16
        dvar(k,1) = acor(1); %variance estimate at lag 0
        dcmp(k,1) = abs(acor(17))/acor(1); %Comparison Ratio
        fdet(k,1) = dcmp(k,1)>thrcmp;
        if (k>1 && fdet(k) && fdet(k-1))
            fsts = true; ifal = [ifal; k];
            vltspk = [vltspk; 0]; iltspk = [iltspk;0];
        end
        if fsts && (k>ifal(end)+54) && (k<ifal(end)+118)
            xcor = dltsx*dsdr63(j:j+63,1); %Dot/ inner product
            if (abs(xcor(k))>vltspk(end)) %Find new peaks
                vltspk(end) = abs(xcor(k));
                iltspk(end) = k;
            end
        elseif fsts && (k>ifal(end)+117)
            fsts = false;
        end
        
    end
    last31(1:31,1) = dsdr(end-30:end, 1);
    last63(1:63,1) = dsdr(end-62:end, 1);
end
release(hacor);
clear hsdr hacor
figure;
plot(abs(dsdra));
hold on; 
plot(ifal, abs(dsdra(ifal)), 'r*');
plot(iltspk, abs(dsdra(iltspk)), 'r*');

           