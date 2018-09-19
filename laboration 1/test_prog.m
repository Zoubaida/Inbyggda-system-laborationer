function test_prog(a)
pause on
a.pinMode(4,'INPUT'); %knapp
a.pinMode(2,'OUTPUT'); %direction
a.pinMode(6,'OUTPUT'); %lampa
a.pinMode(5,'OUTPUT'); %brake
analogWrite(a,200); % med hastighet 20
a.digitalWrite(5,0);
a.digitalWrite(6,0);
a.digitalWrite(4,0);
measureValue = 0;
measure = 0;
a.digitalWrite(2,0);
measureArray1 = []; % en array som lagrar de f�rsta 200 m�tv�rde utan last
measureArray2 = []; % en array som lagrar de andra 200 m�tv�rde med last
while(1)
    if(a.digitalRead(4) == 1) %om knappen �r nedtryckt
        measure = measure + 1; % d� �kar measure variabel och g�r in i if-satser
    end
    if(measure == 1) 
        while(measureValue <200)
            a.digitalWrite(2,1);% d� roterar motorn
            a.digitalWrite(6,1); % lampan t�nds
            pause(0.09);
            current = analogRead(a,'A0'); %l�sa av str�m
            currentValue = ((current/1024)*3.3)/1.65; % ber�kning av str�m
            measureArray1 = [measureArray1, currentValue]; % lagra v�rden f�r str�m utan last efter ber�kning
            fprintf('%.3f A\n', currentValue);
            measureValue = measureValue + 1; 
        end
        measure = measure +1; %�kar measure igen
        measureValue= 0;
        pause(4);
    elseif(measure == 2)
        while(measureValue <200)
            a.digitalWrite(6,0); %lampan sl�cks
            pause(0.01);
            current = analogRead(a,'A0'); %l�sa av str�m
            currentValue = ((current/1024)*3.3)/1.65; % ber�kning av str�m
            measureArray2 = [measureArray2, currentValue]; %lagra str�m i arrayen med last
            fprintf('%.3f B\n', currentValue);
            measureValue  = measureValue+1;
            if(currentValue >0.16) % om str�m �r mer �n 0,16
                while(1)
                    a.digitalWrite(5,1); %motor stop
                    disp('Motor stop');
                end
            end
        end
        y = measureArray1; %plott
        x = 1:1:200;
        plot(x, y,'g');
        hold on
        pause(1);
        x = 1:1:200;
        y2 = measureArray2;
        plot(x, y2,'b');
        pause(1);
        legend('Without Weight', 'With Weight')
        title('Current')
        xlabel('Analog values')
        ylabel('Current')
        filename = 'currentValue.xlsx';
        xlswrite(filename, [measureArray1 .', measureArray2.'],1,'A1')
        measure = measure + 1;
    end
    if (measure > 2 && a.digitalRead(4) == 1) % kod f�r direction �ndring
        a.digitalWrite(2,0);
        pause(0.1);
        a.digitalWrite(2,1);
        a.digitalWrite(6,1);
        
        
    end
end
