D = [1010001101}.' ; 
P = [110101].' ;
hCRC = comm.CRCGenerator('polynomial', p);
T = hCRC(D);
[DP, error] =hDet(T);

hCRC(D).'
Trx = T; ix = randi([1,10]); Trx(ix) = ~Trx(ix);