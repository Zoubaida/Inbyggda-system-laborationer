function test_prog(a)
pause on
a.pinMode(2,'INPUT');
a.pinMode(5,'INPUT');
a.pinMode(4,'INPUT');
a.pinMode(10,'INPUT');
a.pinMode(6,'OUTPUT');
a.pinMode(7,'OUTPUT');
a.pinMode(8,'OUTPUT');
a.pinMode(9,'OUTPUT');

state = 'locked';
index = 0;
indexarray = zeros(4,1);% skapa en array  med 4 rader och 1 kolumn
indexarray(1,1) = 2; % s�tta varje position till ett v�rde 
indexarray(2,1) = 3;
indexarray(3,1) = 1;
indexarray(4,1) = 2;
knapp = 0;
while(1)
    k3= a.digitalRead(2); %gula knappen
    k1= a.digitalRead(5); % vita knappen
    k2= a.digitalRead(4); % r�da knappen
    k4 = a.digitalRead(10);%2r�da knapp
    pause(0.1);
    if (k1)
        knapp = 1;% knapp 1 f�r ett v�rde p� 1 n�r man trycker p� den 
        pause(0.1);
    end
    if(k2)
        knapp = 2;% knapp 1 f�r ett v�rde p� 2 n�r man trycker p� den 
        pause(0.1);
    end
    if(k3)
        knapp = 3;% knapp 1 f�r ett v�rde p� 3 n�r man trycker p� den 
        pause(0.1);
    end
    if(k4)
        state = 'bytKod';% om man trycker p� knapp 4 d� g�r den till case som byter kod
    end
    if(index >2) % if sats f�r 3 felf�rs�k som g�r till case locked
        state = 'locked'; 
        disp('Mer �n tre felf�rs�k');
    end
    
    switch state
        case 'locked'
            
            a.digitalWrite(6,0);
            a.digitalWrite(7,0);
            a.digitalWrite(8,0);
            a.digitalWrite(9,0);
            
            if(knapp==indexarray(1,1)) % om knapp har det f�rsta plats i arrayen g�r vidare till pushfirst
                state = 'pushFirst';
            end
            
        case 'pushFirst'
            a.digitalWrite(6,0);
            if (~k2) %om man sl�ppar knapp2 d� g�r den till releasefirst
                state = 'releaseFirst';
                disp('im in pushfirst');
            end
            
        case 'releaseFirst'
            a.digitalWrite(6,1); % lampan t�nds
            disp('im in case releasefirst');
            if(knapp==indexarray(2,1)) % om knapp har andra platsen i array d� g�r den till push Second
                state = 'pushSecond';
                disp('me in if');
            end
            if(k2||k1) %om mna trycker p� k2 eller k1 d� g�r det till locked och d� r�knas det som felf�rs�k 
                state = 'locked';
                index = index +1;
                disp('lockedhere');
            end
        case 'pushSecond'
            a.digitalWrite(7,0);
            disp('im in case pushSecond');
            if (~k3) %om man sl�ppar knapp3 d� g�r den till releaseSecond
                state = 'releaseSecond';
                disp('here im ');
            end
            
        case 'releaseSecond'
            a.digitalWrite(7,1);
            disp('im in case releaseSecond');
            if(knapp==indexarray(3,1))
                state = 'pushThird';
            end
            if(k3||k2)
                state = 'locked';
                index = index +1;
                disp('lockedhere2');
            end
        case 'pushThird'
            a.digitalWrite(8,0);
            disp('im in case pushThird');
            if (~k3)
                state = 'releaseThird';                
            end
        case 'releaseThird'
            a.digitalWrite(8,1);
            disp('im in case releaseThird');
            if(knapp==indexarray(4,1))
                state = 'pushFourth';
            end
            if(k3||k1)
                state = 'locked';
                index = index +1;
                disp('lockedhere3');
            end
        case 'pushFourth'
            if (~k2)
                state = 'open';
            end
            
        case 'open'
            a.digitalWrite(6,0);
            a.digitalWrite(7,0);
            a.digitalWrite(8,0);
            a.digitalWrite(9,1);
            disp('opened');
            if(k1||k2||k3)
                state = 'locked';
            end
        case 'bytKod'
            disp('me in state kod');
            i = 1;
            while(i<=4) % f�r den nya kombination
                k3= a.digitalRead(2); %gula knappen
                k1= a.digitalRead(5); % vita knappen
                k2= a.digitalRead(4); % r�da knappen
                if(k1)
                    indexarray(i,1)= 1; % knappen l�ggs i array som �r f�rsta plats i arrayen
                    i = i+1; 
                    disp('k1');
                    pause(0.1);
                end
                if(k2)
                    indexarray(i,1)= 2;
                    i = i+1;
                    disp('k2');
                    pause(0.1);
                end
                if(k3)
                    indexarray(i,1)= 3;
                    i = i+1;
                    disp('k3');
                    pause(0.1);
                end
            end
            disp('kod �r �ndrad');
            knapp = 0;
            state = 'locked';% den g�r till kod och alla vilkor f�r den nya l�skombination utf�rst
    end
end


