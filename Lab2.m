%1.	The range of center frequencies is from 500 kHz up to 1.75 GHz
%2.	The maximum sample rate that doesn’t drop samples is 2.4 MS/s. 
%3. Radio station: 89.16e, location: Ruston, LA  

%Initialization
te = 10; %This is the end simulation time.
ns = 1024*256;
fs = 256e3;
tf = ns/fs;
tc = 0:tf:te; 
nt = length(tc);
nspsym = 8; 
radio = sdrinfo;
fc = 915;

hsdr = comm.SDRRTLReceiver('CenterFrequency',fc,'EnableTunerAGC',false,'TunerGain',10,'SampleRate',fs,'SamplesPerFrame',ns,'OutputDataType','double',...
    'FrequencyCorrection',70, 'SamplesPerFrame',ns);

hsa = dsp.SpectrumAnalyzer('Name', 'Spectrum FFT', 'Title', 'Spectrum FFT', 'SpectrumType', 'Power density',...
    'FrequencySpan', 'Full', 'SampleRate', fs);
hcfc = comm.CoarseFrequencyCompensator('SampleRate',fs, ...
   'Modulation','QPSK','FrequencyResolution',1);
hffc = comm.CarrierSynchronizer('SamplesPerSymbol',1, ...
   'Modulation','QPSK','DampingFactor',0.4);
hrrc = comm.RaisedCosineReceiveFilter('Shape','Square root','RolloffFactor',0.5,'FilterSpanInSymbols',12,...
'InputSamplesPerSymbol',nspsym,'DecimationFactor',nspsym);
hagc = comm.AGC('AdaptationStepSize',0.05/128,'DesiredOutputPower',1,'AveragingLength',256,'MaxPowerGain',10);
  
hcd = comm.ConstellationDiagram('Name','Constellation Diagram','Title','Constellation Diagram','SamplesPerSymbol',2,'SampleOffset',0,...
'SymbolsToDisplaySource','Property','SymbolsToDisplay',1024,'ShowReferenceConstellation',true);

hpsk = comm.QPSKDemodulator('PhaseOffset',pi/4,'SymbolMapping','Gray','OutputDataType','single','BitOutput',true);

for tc = 0:tf:te
    dsdr = hsdr();
    dcfc = hcfc(dsdr);
    dffc = hffc(dcfc);
    drrc = hrrc(dffc);
    dagc = hagc(drrc);
    dpsk = hpsk(dagc);
    hcd(dagc);
    hsa(dsdr); 
end
release(hcfc); release(hsa);
release(hrrc); release(hagc); release(hsdr); release(hpsk); release(hffc); %Release System Objs
clear  hcfc hffc hsa hrrc hagc
