
% Generalized program to solve Unit Commitment Problem using 
%Enumeration method
% Power demand should be integer
% Generator limits are not considered
% Start-up costs are not considered
% Security constraints are not considered

clear all;
clc;
%Pd = input('Enter the value of Pd: ')
%cost_function = input('Enter the coefficients of cost function in the form C=a+bPg+cPg^2: ')

% Inputs
% cost matrix of the form C=a+bPg+cPg^2
cost_function = [0 22.9 0.37;
    0 25.9 0.78 ;
    0 29 0.985;
    0 31.2 0.68]
Pd = 8 %demand

% no. of generators
n = size(cost_function,1);

% Individual cost of operation of each generator f(Pgi)
for i1 = 1:n % generator 2 to n-1
    for i2 = 1:Pd+1 %discrete power demands
        ind_cost(i1,i2) = cost_function(i1,1)+ cost_function(i1,2)*(i2-1)+ cost_function(i1,3)*[(i2-1)^2];
    end
end
ind_cost

%.....................................................
UC_ind = zeros(n,Pd+1,n); % fi, (0 to Pd), Gi
for i8 = 1:n
    UC_ind(i8,2:Pd+1,i8)=1;
end            
            
UC_ind(:,1,:)=0; % fi(~=0)=1
%.................................................
%Cumulative generation cost of various generator combinations
cum_cost(1,:) = ind_cost(1,:);

%.................................................
UC_cum = zeros(n,Pd+1,n);
UC_cum(1,:,:) = UC_ind(1,:,:);
%....................................................
for i3 = 2:n % generator 2 to n-1
    for i4 = 1:Pd+1 %discrete power demands
        F=[]; %elements of minimization function for cum_cost
        
        %......................................
        UC_F =[];
        %.....................................
        
        i6 = [1:i4]; % 0 to Pd_currentvalue for fi
        i7 = sort(i6,'descend'); %Pd_current value to 0 for F
        for i5 = 1:i4
            F(i5) = ind_cost(i3,i6(i5))+ cum_cost(i3-1,i7(i5));
            
            %........................................
            UC_F(i5,:) = UC_cum(i3-1,i7(i5),:);
            %...............................
            
        end
        
        F1 = sort(F,'ascend');
        cum_cost(i3,i4) = F1(1);
        
        %...............................................
        position = find(F==F1(1)); %position of minimum value of function
        for i9 = 1:n
            %final_UC = (ind_UC) OR (previous_cum_UC) 
            UC_cum(i3,i4,i9)=UC_ind(i3,position,i9)|UC_F(position,i9);
        end
        %..............................................
    end
end
cum_cost
%UC_ind
%UC_cum

for i10 = 1:Pd+1 % rows corresponding to Pd= 0,1,...,Pd
    for i11 = 1:n % columns corresponding to status of each generator
        UCP(i10,i11) = UC_cum(n,i10,i11);
    end
end
UCP

            
            
        
        
        
        
        
        
        
        


