function [alpha, bias] = smoTrain (K, label, C, tolerance, epsilon)
% smoTrain 
% Function:
%     An numerical optimization method for SVM(finding max margin with slackness)
% Input: 
%     K: kernel matrix
%     label: target value
%     C: trade-off value. (the smaller, margin size become more important)
%     tolerance: terminal criterion
%     epsilon: for checking bound or not. (smo algorithm tell us to have this parameter)
% Output:
%     alpha: Lagrange multipliers (7.22)
%     bias:  bias as in (7.1).
% author: Vincent
% e-mail: vincint810923@gmail.com
    global SMO;
    [N,c] = size(K);
    % initial lagrange multiplier and bias
    alpha = zeros(N,1);
    bias = 0;

    % initial algorithm variable
    numChanged = 0;
    examineAll = 1;
    E = zeros(N,1);
    U = zeros(N,1);
    SMO.K = K;
    SMO.alpha = alpha;
    SMO.label = label;
    SMO.bias = bias;
    SMO.tolerance  = tolerance;
    SMO.epsilon = epsilon;
    SMO.E = E;
    SMO.U = U;
    SMO.N = N;
    SMO.C = C;
    
    % main loop
    while (numChanged > 0) | (examineAll == 1)
        numChanged = 0;
        
        if examineAll == 1
            % go through all training data
            for i2 = 1:N
                numChanged = numChanged + examine(i2);
            end  
        else
            % find non-bound data
            position = find((alpha>epsilon) & (alpha<(C-epsilon)));
            for i = 1:length(position)
                i2 = position(i);
                numChanged = numChanged + examine(i2);
            end
        end
        
        if examineAll ==1
            examineAll = 0 ;
        elseif numChanged == 0 
            examineAll = 1;
        end
    end
    alpha = SMO.alpha;
    bias  = SMO.bias;

end

function examine = examine(i2)
    % algorithm variable init
    global      SMO;
    E       = SMO.E;
    U       = SMO.U;
    K       = SMO.K;  
    label   = SMO.label;
    alpha   = SMO.alpha;
    bias    = SMO.bias;
    N       = SMO.N ;
    C       = SMO.C;
    tolerance = SMO.tolerance;
    epsilon = SMO.epsilon;
    examine = 0 ;                         
    % update E,U
    for j = 1:N
        U(j) = sum((alpha.*label).*K(:,j)) - bias;
        E(j) = U(j) -  label(j);
    end
    SMO.E = E;    
    SMO.U = U;
    % compute alpha2
    alpha2 = alpha(i2);
    y2 = label(i2);
    u2 = U(i2);
    E2 = u2 - y2;
    
    if (E2*y2<(-tolerance) && alpha2<C) || (E2*y2>(tolerance)&&alpha2>0)
        position = ((alpha>epsilon) & (alpha<(C-epsilon)));
        % get the other multiplier and run step
        % first case 
            numOfnonZeroAlpha = sum(alpha~=0);
            numOfnonCAlapha = sum(alpha~=C);
            if numOfnonZeroAlpha >1 && numOfnonCAlapha>1
                [value,i1] = max(abs(E2-E(position))); 
                % take step:
                first = takeStep(i1,i2);
                if first == 1
                    examine = 1;
                    return;
                end
            else
                first = 0;
            end
        % second case
            second = 0 ;
            if first == 0
                for j = 1:N
                    if position(j) == 1
                        i1 = j;
                        second = takeStep(i1,i2);
                        if second == 1
                            examine = 1;
                            return ;
                        end
                    end
                end
            end
        % third case
            if second == 0 
                for i1 = 1:N
                    third = takeStep(i1,i2);
                    if third == 1
                        examine = 1;
                        return;
                    end                                    
                end
            end
    end   
end



function success = takeStep(i1,i2)
    % algorithm variable init
    global      SMO;
    E       = SMO.E;
    U       = SMO.U;
    K       = SMO.K;  
    alpha   = SMO.alpha;
    bias    = SMO.bias;
    epsilon = SMO.epsilon;
    N       = SMO.N ;
    C       = SMO.C;
    label   = SMO.label;
    % alpha 2 init
    alpha2 = alpha(i2);
    y2 = label(i2);
    u2 = U(i2);
    E2 = u2 - y2;
    
    if i2 ~= i1
        alpha1 = alpha(i1);
        y1 = label(i1);
        E1 = E(i1);
        s = y1*y2;
        if y1~=y2   % y1 y2 have different sign
            L = max(0,alpha2-alpha1);            H = min(C,C+alpha2-alpha1);
        else        % y1 y2 have same sign
            L = max(0,alpha2+alpha1-C);            H = min(C,alpha2+alpha1);
        end
        if L~=H
            eta = K(i1,i1)+K(i2,i2)-2*K(i1,i2);
            % get new alpha2
            if(eta>0)
                newAlpha2 = alpha2 +y2*(E1-E2)/eta;
                % clip alpha2
                if newAlpha2 <= L
                    newAlpha2 = L;
                elseif newAlpha2 >= H
                    newAlpha2 = H;
                else
                end
            else
                f1 = y1(E1+bias) - alpha1*K(i1,i1) -s*alpha2*K(i1,i2);                
                f2 = y2(E2+bias) - alpha2*K(i2,i2) -s*alpha1*K(i1,i2);
                L1  = alpha1 + s*(alpha2 - L);                
                H1  = alpha1 + s*(alpha2 - H);
                PsiL = L1*f1 + L*f2 +L1*L1*K(i1,i1)/2 +L*L*K(i2,i2)/2 +s*L*L1*K(i1,i2);                
                PsiH = H1*f1 + H*f2 +H1*H1*K(i1,i1)/2 +H*H*K(i2,i2)/2 +s*H*H1*K(i1,i2);
                if PsiL>PsiH+epsilon
                    newAlpha2 = H;
                elseif PsiL <  PsiH-epsilon
                    newAlpha2 = L;
                else
                    newAlpha2 = alpha2;
                end
            end
            % get new alpha1
            if abs(newAlpha2-alpha2)>=epsilon*(alpha2+newAlpha2+epsilon)
                newAlpha1 = alpha1 + s*(alpha2-newAlpha2);
            else
                success = 0;
                return;
            end
        else
            success = 0;
            return;
        end
    else
        success = 0 ;
        return;
    end
    % update:
    	% bias
        b1 = E1 + y1*(newAlpha1 - alpha1)*K(i1,i1) + y2*(newAlpha2 - alpha2)*K(i1,i2) + bias;
        if (newAlpha1 > epsilon) & (newAlpha1 < (C - epsilon))
            SMO.bias = b1;
        else
            b2 = E2 + y1*(newAlpha1 - alpha1)*K(i1,i2) + y2*(newAlpha2 - alpha2)*K(i2,i2) + bias;
            if (newAlpha2>epsilon) & (newAlpha2<(C - epsilon))
                SMO.bias = b2;
            else
                SMO.bias = (b1+b2)/2;
            end
        end
        % alpha
        SMO.alpha(i1) = newAlpha1;
        SMO.alpha(i2) = newAlpha2;
        success = 1;

end