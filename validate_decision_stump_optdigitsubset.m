% read dataset and create the labels vector
dataset = dlmread('optdigitsubset.txt');
labels = nan(size(dataset,1),1);
for i=1:554
    labels(i) = 0;
end
for i=555:1125
    labels(i) = 1;
end

% split data and labels into training and tests sets 
training = [dataset(1:50,:) ; dataset(555:604,:)];
labels_training = [labels(1:50,:) ; labels(555:604,:)];
test = [dataset(51:554,:) ; dataset(605:1125,:)];
labels_test = [labels(51:554,:) ; labels(605:1125,:)];

% train the decision stump
[f_opt, theta_opt, y_opt] = decision_stump_train(training,labels_training);

% get the error on the training set
err = nan(10,1);
[~,err(1)] = decision_stump_test(f_opt, theta_opt, y_opt,test, labels_test);

for i=1:9
    % get random indices for the both classes
    rand_zero_ind = randperm(554,50);
    rand_ones_ind = randperm(571,50) + 554;

    % create random training and test set based on the indices
    rand_training = [dataset(rand_zero_ind,:) ; dataset(rand_ones_ind,:)];
    rand_labels_training = [labels(rand_zero_ind,:) ; labels(rand_ones_ind,:)]; 
    % make sure no training samples end up on the test set
    temp = zeros(size(dataset));
    temp(rand_zero_ind,:) = dataset(rand_zero_ind,:);
    temp(rand_ones_ind,:) = dataset(rand_ones_ind,:);
    temp2 = dataset - temp;
    test_ind = find(sum(temp2,2) > 0);
    rand_test = dataset(test_ind,:);
    rand_labels_test = labels(test_ind,:);
    
    % train the decision stump using the random training test
    [rand_f_opt,rand_theta_opt,rand_y_opt] = decision_stump_train(rand_training,rand_labels_training);
    
    % evaluate the training
    [~,err(i+1)] = decision_stump_test(rand_f_opt, rand_theta_opt, rand_y_opt,rand_test,rand_labels_test);
end

% plot the errors along with their mean and standard deviation
means(1:10)= mean(err);
stds(1:10) = mean(err) + std(err);
stds2(1:10) = mean(err) - std(err);
figure
plot(err)
title('Classification Error for various training and test sets')
xlabel('Run number')
ylabel('Error')
hold on;
plot(means)
plot(stds)
plot(stds2)
legend('test error','mean','mean+std','mean-std')