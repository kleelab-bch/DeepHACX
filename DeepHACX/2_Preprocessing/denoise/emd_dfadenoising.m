function b = emd_dfadenoising (a)

%Denoising using EMD-DFA
%code published by Aditya Sundar, Texas Instruments/ BITS Pilani K.K. Birla Goa Campus
%Please contact me on aditsundar@gmail.com for any queries
imf= emd(a); %Computes the EMD
imf=imf' ;	  %Store the IMFs as column vectors 
save imf_s1.mat imf;
s = size(imf);
h=zeros(1,s(2));
b=a';
for i=1:s(2)
    h(i)=estimate_hurst_exponent(imf(:,i)');
    %figure
    %plot(imf(:,i)');
    %title(['imf: ' num2str(i) ' from emd (Hurst_exponent value: ' num2str(h(i))]);
    if(h<0.33) %h < 0.33
        b=b-imf(:,i) ;
        %figure(i+10)         %incase you want to see the IMFs
        %plot(imf(:,i)')
    end
end
