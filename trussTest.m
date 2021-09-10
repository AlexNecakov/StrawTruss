function trussTest()
    load('TrussDesign1_AlexAvaniWillie_A2.mat', 'C');
    load('TrussDesign1_AlexAvaniWillie_A2.mat', 'Sx');
    load('TrussDesign1_AlexAvaniWillie_A2.mat', 'Sy');
    load('TrussDesign1_AlexAvaniWillie_A2.mat', 'X');
    load('TrussDesign1_AlexAvaniWillie_A2.mat', 'Y');
    load('TrussDesign1_AlexAvaniWillie_A2.mat', 'L');
    
    [j, m] = size(C);
    A = zeros(2*j, m+3);%construct empty a array
    memLengths = zeros(m,1);
    memBuckles = zeros(m,1);
    SR = zeros(m,1);
    
    for startPoint=1:j
        for endPoint = 1:j
            r = sqrt(power(X(endPoint)-X(startPoint), 2) + power(Y(endPoint)-Y(startPoint), 2));
            
            member = 0;
            for mem = 1:m
                if(C(startPoint,mem) == 1 && C(endPoint,mem) == 1 && startPoint ~= endPoint)
                    member = mem;
                end
            end
            if(member ~= 0)
                A(startPoint,member) = (X(endPoint)-X(startPoint))/r;
                A(startPoint+j,member) = (Y(endPoint)-Y(startPoint))/r;
                memLengths(member) = r;
            end
        end
    end
    A(:,[m+1,m+2,m+3]) = [Sx; Sy];%insert sx and sy
    T = round(A\L, 3);%round here or we could get lin alg errors
    cost = (10*j + sum(memLengths));
    
    fprintf('\\%%EK301, Section A2, Sandal Squad: Alex N, Avani S, Willie S, 11/15/2019.\n');
    fprintf('Load: %.3f\n', sum(L));
    fprintf('Members of forces in Newtons\n');
    
    for curr = 1:m
        fprintf('m%d: %.3f ', curr, abs(T(curr)));
        if(T(curr) > 0)
            fprintf('(T)');
        elseif(T(curr) < 0)
            fprintf('(C)');
        end
        fprintf('\n');
        
        memBuckles(curr) = 1334.822/ power(memLengths(curr),2);%equation from blackboard, converted to meters
        
        if(abs(T(curr)) ~= 0)
            SR(curr) = abs(T(curr)/memBuckles(curr));%convert to SR
        else
            memLengths(curr) = 0;
        end
    end
    
    memLengths
    memBuckles
    SR
    SRmax = max(SR);
    Ffail = sum(L)/SRmax
    
    fprintf('Reaction force in Newtons:\n');
    fprintf('Sx1: %.3f\nSy1: %.3f\nSy2: %.3f\n', T(m+1), T(m+2), T(m+3));
    fprintf('Cost of truss: %.3f\n', cost);
    fprintf('Theoretical max load/cost ratio in N/$: %.3f\n', (Ffail/cost));

end

