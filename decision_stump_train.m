function [f_opt,theta_opt,y_opt] = decision_stump_train(dataset,labels)
    % get the different classes found in the dataset, the
    % minimum error, the number of features and the number of samples
    classes = unique(labels);
    minimum_error = 1.1;
    N_features = size(dataset,2);
    N = size(dataset,1);
    
    % iterate over all features
    for feature=1:N_features
        % initialize two hypotheses arrays, one for the classes given by
        % each of the two possible decison rule signs
        h = nan(N,1);
        h2 = nan(N,1);
        % use as threshold values only distinct values found in the dataset
        thetas = sort(unique(dataset(:,feature)));
        for k=1:size(thetas,1)
            % initialize the current theta and the errors of each
            % hypothesis array
            theta = thetas(k);
            e = 0;
            e2 = 0;
            % iterate over all objects
            for i=1:N
                % get the object value for the current feature
                sample = dataset(i,feature);
                % apply the first decision rule and assign a class to the
                % object
                if sample > theta
                    h(i) = classes(1);
                else
                    h(i) = classes(2);
                end
                % apply the second decision rule and assign a class to the
                % object
                if sample < theta
                    h2(i) = classes(1);
                else
                    h2(i) = classes(2);
                end
                % compute the classification error for the first decision
                % rule
                if h(i) ~= labels(i)
                    e = e + 1;  
                end
                % compute the classification error for the second decision
                % rule
                if h2(i) ~= labels(i)
                    e2 = e2 + 1;  
                end
            end
            % transform the two error into the range [0,1]
            e = e / N;
            e2 = e2 / N;
            % check if the error of the first decision rule is less than
            % the current minimum
            if (e < minimum_error)
                % if yes, keep track of the best values so far
                f_opt = feature;
                theta_opt = theta;
                y_opt = 1;
                minimum_error = e;
            end
            % same procedure for the error of the second decision rule
            if (e2 < minimum_error)
                f_opt = feature;
                theta_opt = theta;
                y_opt = 2;
                minimum_error = e2;
            end
        end
    end
end
