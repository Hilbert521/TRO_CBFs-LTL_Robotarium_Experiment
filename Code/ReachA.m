function [hg3, y] = ReachA(X)

    gamma = 1;
    
    H = eye(6);
    
    Pshape = [1/(0.3)^2 0; 0 1/(0.1)^2];
    Pobs = [1/(0.3)^2 0; 0 1/(0.35)^2];
    
    c3 = 0.9; c4 = 0.7; c9 = 0.3; c10 = 0;
    
    zero = [0 0;0 0];
    C2 = [c3; c4];
    Cobs = [c9; c10];

    P_1 = [Pobs zero zero; zero zero zero; zero zero zero];
    P_2 = [zero zero zero; zero Pobs zero; zero zero zero];
    P_3 = [zero zero zero; zero zero zero; zero zero Pobs];
    P_4 = [zero zero zero; zero zero zero; zero zero Pshape];


    hgo1 = (X - [Cobs; 0; 0; 0; 0])'*P_1*(X - [Cobs; 0; 0; 0; 0]) - 1;       %% Obstacle avoidance for robot 1
    hgo2 = (X - [0; 0; Cobs; 0; 0])'*P_2*(X - [0; 0; Cobs; 0; 0]) - 1;       %% Obstacle avoidance for robot 2
    hgo3 = (X - [0; 0; 0; 0; Cobs])'*P_3*(X - [0; 0; 0; 0; Cobs]) - 1;       %% Obstacle avoidance for robot 3

    hg3 = 1 - (X - [0; 0; 0; 0; C2])'*P_4*(X - [0; 0; 0; 0; C2]);
    
    A1 = 2*(X - [0; 0; 0; 0; C2])'*P_4;
    A2 = -2*(X - [Cobs; 0; 0; 0; 0])'*P_1;
    A3 = -2*(X - [0; 0; Cobs; 0; 0])'*P_2;
    A4 = -2*(X - [0; 0; 0; 0; Cobs])'*P_3;
    
    B1 = gamma*sign(hg3)*abs(hg3)^(0.5);
    B2 = gamma*hgo1^5;
    B3 = gamma*hgo2^3;
    B4 = gamma*hgo3^3;

    a = [A1; A2; A3; A4];
    b = [B1; B2; B3; B4];
    
    opts = optimoptions(@quadprog, 'Display', 'off');
    y = quadprog(H, [], a, b, [], [], [], [], [], opts);  
        
end