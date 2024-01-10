figure(2)
U=fft(u);DT=t(2)-t(1);N=length(u);T=N*DT;f=[0:1/T:0.5*(N-1)/T];
plot(f,1/N*abs(U(1:N/2)));xlabel('f [Hz]');ylabel('1/N |U(f)|'),grid