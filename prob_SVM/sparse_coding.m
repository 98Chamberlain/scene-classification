function [ training_SR , testing_SR , D ] = sparse_coding( training_data , testing_data )

% sparse_coding toolkit
addpath(genpath('../Research_Toolkit/spams-matlab/'));
% addpath('./spams-matlab/test_release');
% addpath('./spams-matlab/src_release');
% addpath('./spams-matlab/build');

% Find testing and training data sparse representations
% Input:    query - m*(d*p) matrix     m: number of query images
%                                      d: feature dimension for each part
%                                      p: number of parts (80 in our case)
%           database - n*(d*p) matrix  n: number of database images
% Output:   querySR - m*(k*p)          k: dictionary size
%           databaseSR - n*(k*p)
%           D - d*k*p
%              dictionaries for every parts.

% defult train_amt = 100
% testing_data = data(:,train_amt+1:data_len,:);
% testing_data = testing_data(:,:);
% training_data = data(:,1:train_amt,:);
% training_data = training_data(:,:);
% data: 205 * (train_amt * 205)

% Some initial values
% qPts = size(query,1);
% nPts = size(database,1);
% nDim = 59;
% nPart = 80;
nTesting = size(testing_data,2);
nTraining = size(training_data,2);
nPart = 1;
nDim = 205; % default = 205
% nPart*nDim = 205
K = 205;

parD.lambda = 0.01;
parD.K = K;
parD.posD = 1;
parD.posAlpha = 1;
parD.iter = 50;
parD.verbose = 0;
parD.numThreads = 2;

parS.lambda = 0.01;
parS.K = K;
parS.pos = 1;
parS.verbose = 0;
parS.numThreads = 2;

D = zeros(nDim, K, nPart);
testing_SR = zeros(nTesting, K*nPart);
training_SR = zeros(nTraining, K*nPart);

% Loop through each part
for i = 1:nPart
	% You code here
    % [D [model]]=mexTrainDL(X,param[,model]);
    % Input  X:  double m x n matrix ( d * n ?)
    %            m is the signal size
    %            n is the number of signals to decompose
    % Output param.D: double m x p matrix  ( d * k ?)
    %                 p is the number of elements in the dictionary
    D(:,:,i) = mexTrainDL( training_data((i-1)*nDim+1:i*nDim,:) , parD); 
    
    dic_sz = size(D,2);
    % Usage:  [A [path]]=mexLasso(X,D,param);
    % Inputs: X:  double m x n matrix   (input signals)
    %               m is the signal size
    %               n is the number of signals to decompose
    %         D:  double m x p matrix   (dictionary)
    %               p is the number of elements in the dictionary
    % Output: A: double sparse p x n matrix (output coefficients) (k * n)
    alpha = mexLasso( training_data((i-1)*nDim+1:i*nDim,:) , D(:,:,i) , parS );
    % databaseSR - n*(k*p)
    training_SR( :,(i-1)*dic_sz+1:i*dic_sz ) = alpha';
    
    alpha = mexLasso( testing_data((i-1)*nDim+1:i*nDim,:) , D(:,:,i) , parS );
    % querySR - m*(k*p)
    testing_SR( :,(i-1)*dic_sz+1:i*dic_sz ) = alpha';
    
    % alpha = mexLasso( query(:,(i-1)*nDim+1:i*nDim)' , D(:,:,i) , parS );

end