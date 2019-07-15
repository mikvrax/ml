% generate a simple 2D two-class problem dataset and store the labels in a
% separate vector
dataset = gendats();
labels = getlab(dataset);
N = size(dataset,1);

% plot the data
figure
scatterd(dataset)

% classify using a weighted_decision_stump with equal weights
weights = ones(N,1);
[feature1, threshold1, y1, hypotheses1] = weighted_decision_stump_train(+dataset,labels,weights);
% determine decision boundary
if feature1==1
       feature2a = min(dataset(:,2)) - 0.5;
       feature2b = max(dataset(:,2)) + 0.5;  
       feature1 = [threshold1;threshold1];
       feature2 = [feature2a;feature2b];
else
       feature1a = min(dataset(:,1)) - 0.5;
       feature1b = max(dataset(:,1)) + 0.5;
       feature2 = [threshold1;threshold1];
       feature1 = [feature1a;feature1b];
end
    
% plot decision boundary
hold on
plot(feature1,feature2)
saveas(gcf,'w1sp','png')

% create a new plot for the results of the classification
classified_data = prdataset(+dataset,hypotheses1');
figure
scatterd(classified_data);
hold on
plot(feature1,feature2)
title('Classification Results')
saveas(gcf,'w1cr','png')

% use random weights to change the decision boundary
weights2 = rand(N,1);

[feature2,threshold2,y2,hypotheses2] = weighted_decision_stump_train(+dataset,labels,weights2);
if feature2==1
       feature2a = min(dataset(:,2)) - 0.5;
       feature2b = max(dataset(:,2)) + 0.5;  
       feature1 = [threshold2;threshold2];
       feature2 = [feature2a;feature2b];
else
       feature1a = min(dataset(:,1)) - 0.5;
       feature1b = max(dataset(:,1)) + 0.5;
       feature2 = [threshold2;threshold2];
       feature1 = [feature1a;feature1b];
end

% plot the new classificiation results
figure
classified_data = prdataset(+dataset,hypotheses2');
scatterd(classified_data);
hold on
plot(feature1,feature2)
title('Weighted Classification Results')
saveas(gcf,'wrcr','png')

% objects of class 1 weight more
weights3 = ones(N,1);
weights3(1:50) = 20; 

[feature3,threshold3,y3,hypotheses3] = weighted_decision_stump_train(+dataset,labels,weights3);
if feature3==1
       feature2a = min(dataset(:,2)) - 0.5;
       feature2b = max(dataset(:,2)) + 0.5;  
       feature1 = [threshold3;threshold3];
       feature2 = [feature2a;feature2b];
else
       feature1a = min(dataset(:,1)) - 0.5;
       feature1b = max(dataset(:,1)) + 0.5;
       feature2 = [threshold3;threshold3];
       feature1 = [feature1a;feature1b];
end

% plot the new classificiation results
figure
classified_data = prdataset(+dataset,hypotheses3');
scatterd(classified_data);
hold on
plot(feature1,feature2)
title('Weighted Classification Results')
saveas(gcf,'wc1cr','png')

% objects of class 2 weight more
weights4 = ones(N,1);
weights4(51:100) = 10; 

[feature4,threshold4,y4,hypotheses4] = weighted_decision_stump_train(+dataset,labels,weights4);
if feature4==1
       feature2a = min(dataset(:,2)) - 0.5;
       feature2b = max(dataset(:,2)) + 0.5;  
       feature1 = [threshold4;threshold4];
       feature2 = [feature2a;feature2b];
else
       feature1a = min(dataset(:,1)) - 0.5;
       feature1b = max(dataset(:,1)) + 0.5;
       feature2 = [threshold4;threshold4];
       feature1 = [feature1a;feature1b];
end

% plot the new classificiation results
figure
classified_data = prdataset(+dataset,hypotheses4');
scatterd(classified_data);
hold on
plot(feature1,feature2)
title('Weighted Classification Results')
saveas(gcf,'wc2cr','png')