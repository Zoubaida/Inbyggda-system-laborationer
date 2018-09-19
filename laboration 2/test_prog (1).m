function test_prog(a)
pause on
a.pinMode(3,'INPUT'); %button player A
a.pinMode(4,'INPUT'); %button player B
a.pinMode(2,'OUTPUT'); % Stora LED
a.pinMode(5,'OUTPUT'); % LED A
a.pinMode(6,'OUTPUT'); % LED B

scoreArray = zeros(7,2); % 7 by 2 array, 2 columns, 7 road for store points for every set
reacTidA=zeros(1,7); % array 1 by 7 Matrix of zeros storing reactionTid for player A
reacTidB=zeros(1,7); % array 1 by 7 Matrix of zeors storing reactionTid for player B
while(1)
    a.digitalWrite(2,0); %big LED off
    for i=1:7 % loop 7 sets for K1
        tic % timer on
        slump = randi([2,7],1,1); %slump tid for big LED between 2-7 seconds
        disp(slump) % in command window
        tidspelareB=toc; %calculate reactiontid for player B
        tidspelareA=0;
        while((tidspelareB-tidspelareA)<slump) %if reactiontid >2 sec
            tidspelareB = toc;  %calculate reactiontid for player B
            a.digitalWrite(5,0); %LED A off
            a.digitalWrite(6,0); %LED B off
            spelareA = a.digitalRead(3); %read from Button A
            spelareB = a.digitalRead(4); %read from Button B
            if(a.digitalRead(3) && a.digitalRead(4)) %if one of players or both press the button in the random time
                tidspelareA=toc; % calculate reactiontid for player A
                disp('Fusk!!')
            end
        end
        a.digitalWrite(2,1); %big led on
        tidC=toc;
               firstPressbtnA=1;
        firstPressbtnB=1;
        while( firstPressbtnA || firstPressbtnB ) % if one of the players pressed first press
            if(a.digitalRead(3) && firstPressbtnA) %compare spelareA button press with control button press, if they are same
                tidspelareA=toc; %the time spelare A took for press the first press.
                firstPressbtnA=0; %controlbuttonApress ==0
            end
            if(a.digitalRead(4) && firstPressbtnB) %compare spelareB button press with control button press, if they are same
                tidspelareB=toc;% the time spelare B took for press the first press.
                firstPressbtnB=0; %controlbuttonBpress ==0
            end
        end
        a.digitalWrite(2,0); %big LED off
        if(tidspelareA <tidspelareB) %spelare A press the button faster than spelare B, we compare this with timer
            winner= 1; % if-sats 1
            reacTidA(1,i)=tidC-tidspelareA; %save reaction time in the array for player A
        elseif(tidspelareB < tidspelareA) %player B press the button faster than playerA
            winner=2; %if-sats 2
            reacTidB(1,i)=tidC-tidspelareB; %save reaction time in the array for player B
        else
            winner=3; %if sats 3
        end
        
        if(winner ==1) %spelare A
            a.digitalWrite(6,0); %LED B off
            a.digitalWrite(5,1); %LED A on
            pause(0.7); %LED A on >1
            disp('PlayerA is the winner');
            scoreArray(i,1)=1; %put the result to the array
        elseif(winner ==2) %spelare B
            a.digitalWrite(5,0); %LED A off
            a.digitalWrite(6,1); %LED B on
            pause(0.7); %LED B on >1
            disp('PlayerB is the winner');
            scoreArray(i,2)=1; %put the result to the array
        else(winner ==3)
            a.digitalWrite(5,1); %LED A on
            a.digitalWrite(6,1); %LED B on
            pause(1);
            disp('Both are winners');
            scoreArray(i,2)=1; %put the result to the array
            scoreArray(i,1)=1; %put the result to the array
        end
    end 
    Points=mean(scoreArray);
    if(Points(1,1)<Points(1,2))
        disp('Congrats Player B')
    end
    if(Points(1,1)>Points(1,2))
        disp('Congrats Player A')
    end
    if(Points(1,1)==Points(1,2))
        disp('tie!')
    end
    disp('Average time for spelare A')
    mean(reacTidA)
    disp('Average time for spelare B')
    mean(reacTidB)
    Points=0;
    scoreArray=0;
end
