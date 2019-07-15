function [f_opt,theta_opt,y_opt,best_h] = weighted_decision_stump_train(dataset,labels,weights)
    % compute the different number of classes found in the dataset, the
    % number of object, the number of features, the minimum error and the
    % final hypotheses
    classes = unique(labels);
    N = size(dataset,1);
    N_features = size(dataset,2);
    minimum_error = max(sum(weights)+1,N+1); 
    best_h = nan(N,1);
    
    % iterate over all features
    for feature=1:N_features
        % initialize the hypotheses arrays for the two different decision
        % rules results
        h = nan(N,1);
        h2 = nan(N,1);
        % use the distinct values found in the dataset as thresholds
        thetas = sort(unique(dataset(:,feature)));
        % iterate over all threshold values
        for k=1:size(thetas,1)
            % initialize the current threshold and the errors of the two
            % decision rules
            theta = thetas(k);
            e = 0;
            e2 = 0;
            % iterate over all objects in the dataset
            for i=1:N
                % get the value of the object for the current feature
                sample = dataset(i,feature);
                % apply the first decision rule and decide on the object 
                % class label 
                if sample > theta
                    h(i) = classes(1);
                else
                    h(i) = classes(2);
                end
                % apply the second decision rule and decide on the object
                % class label
                if sample < theta
                    h2(i) = classes(1);
                else
                    h2(i) = classes(2);
                end
                % compute the weighted classification error of the first
                % rule
                if h(i) ~= labels(i)
                    e = e + weights(i);  
                end
                % compute the weighted classification error of the second
                % rule
                if h2(i) ~= labels(i)
                    e2 = e2 + weights(i);  
                end
            end
            % transform errors into the range [0,1]
            e = e / sum(weights);
            e2 = e2 / sum(weights);
            
            % check if the error of the first decision rule is less than
            % the current minimum
            if (e < minimum_error)
                % keep track of the best values so far
                f_opt = feature;
                theta_opt = theta;
                y_opt = 1;
                minimum_error = e;
                best_h = h';
            end
            % repeat the same procedure for the second decision rule
            if (e2 < minimum_error)
                f_opt = feature;
                theta_opt = theta;
                y_opt = 2;
                minimum_error = e2;
                best_h = h2';
            end
        end
    end
end