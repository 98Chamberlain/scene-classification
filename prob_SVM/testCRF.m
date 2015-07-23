% clear all;  close all;

addpath(genpath('../../../CRF Toolkit/UGM/'));

load ../statistic/feature_data.mat
% 205 * 128 * 205

% Make rain labels y, and binary month features X
y = int32(X+1);
[nInstances,nNodes] = size(y);