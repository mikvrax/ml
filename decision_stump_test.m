function [h,err] = decision_stump_test(f,theta,y,dataset,labels)
    % initializations of the error variable, the different classes found
    % in the dataset, the number of objects in the dataset and the weak 
    %learner hypothesis for each object
    err = 0;
    classes = unique(labels);
    N = size(dataset,1);
    h = nan(N,1);
    
    % iterate over all objects
    for i=1:N
        % get the value of the optimal feature for the current training
        % object
        sample = dataset(i,f);
        % use different classifications rules based on the optimal sign of
        % the decision condition
        if y == 1
            % decide on the sample class based on the its value, the
            % optimal threshold and the optimal rule sign
            if sample > theta
               h(i) = classes(1);
            else
               h(i) = classes(2);
            end
        else 
            if sample < theta
               h(i) = classes(1);
            else
               h(i) = classes(2);
            end
        end
        % find out how many objects were misclassified
        if h(i) ~= labels(i)
           err = err + 1;  
        end
    end
    % transform error into the range [0,1]
    err = err / N;
end