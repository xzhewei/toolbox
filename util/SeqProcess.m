%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SeqProcess.m
%
% 描述：
% 此文件执行 seq 文件裁剪与对应的 txt 标注文件同步（根据家俊师兄设定的标注视频的新的起始帧和结束帧）
%
% 运行注意事项：
% 1.运行前需要保证“code3.2.1”和“toolbox”两个文件夹的路径写入 matlab 路径中；
% 2.将待修改的 seq 文件和 txt 标注文件分别放在“SourceSeq”和“SourceTxt”文件夹中；
% 3.打开“SourceSeq”文件夹的 crop_file.txt，按文件夹中 seq 文件的默认排列顺序，记录每个 seq 文件新
%   的起始帧和结束帧（根据家俊师兄的划分），以“;”作为字段的分隔。；例如 crop_file.txt 的内容为：
%   20131203-173901;1;1535
%   20131218-191257;1;1103
%   20131218-191521;1;822
% 4.处理后的结果保存在“ResultSeq”和“ResultTxt”文件夹。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear;
clc;

% 读取 SourceSeq 文件夹的所有 seq 文件
seqNameList = dir('.\SourceSeq\*.seq');          
% 读取crop_file.txt文件保存的信息
cropInfo = importdata('.\SourceSeq\crop_file.txt');
% 读取 SourceTxt 文件夹的所有 txt 文件
txtNameList = dir('.\SourceTxt\*.txt');

% 对每个seq文件和对应的txt标注文件进行修改
for i = 1:length(seqNameList)
    %% 对seq文件进行修改
    fNameSeq = strcat('.\SourceSeq\', seqNameList(i).name);   % 原始的 seq 文件所在的路径+名称
    tNameSeq = strrep(fNameSeq, 'SourceSeq', 'ResultSeq');    % 修改后的 seq 文件所在的路径+名称
    startFrame = cropInfo.data(i,1);                          % 新的起始帧
    endFrame = cropInfo.data(i,2);                            % 新的结束帧
    frameNum = endFrame - startFrame + 1;                     % 修改后的帧数
    
    frames = ones(1,frameNum);                                % 此变量记录修改后的帧索引与原始 seq 文件的帧索引的对应关系
    for j = 1:frameNum
        frames(j) = j + startFrame - 2;                       % 减2的原因是：由于 startFrame 是从1开始，因此j-1；由于 seqIo 函数的帧索引从0开始，因此再减去1
    end
    
    seqIo(fNameSeq, 'crop', tNameSeq, frames);
    
    %% 对应的txt标注文件修改
    fNameTxt = strcat('.\SourceTxt\', txtNameList(i).name);   % 原始的 txt 文件所在的路径+名称
    tNameTxt = strrep(fNameTxt, 'SourceTxt', 'ResultTxt');    % 修改后的 txt 文件所在的路径+名称
    A = vbb('vbbLoadTxt', fNameTxt);                          % 加载txt文件
    
    A.nFrame = frameNum;                                      % A.nFrame：seq文件的总帧数
    
    A.objLists(1:(startFrame-1)) = [];                        % A.objLists：记录每帧对应的标注信息。该语句删除在新的起始帧之前的信息
    A.objLists(frameNum+1:end) = [];                          % 删除在新的结束帧之后的信息

    A.objStr(:) = A.objStr(:) - startFrame + 1;               % 根据新的起始帧，调整每个目标对应的起始帧
    A.objEnd(:) = A.objEnd(:) - startFrame + 1;               % 根据新的结束帧，调整每个目标对应的结束帧
    
    vbb('vbbSaveTxt', A, tNameTxt);                           % 保存txt文件
end



