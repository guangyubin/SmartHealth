fid = fopen('1520309088000.dat','rb');
d = fread(fid,inf,'short');
fclose(fid);
% subplot(211);plot(d);
 % subplot(211);plot(d(1000:4000));