%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SeqProcess.m
%
% ������
% ���ļ�ִ�� seq �ļ��ü����Ӧ�� txt ��ע�ļ�ͬ�������ݼҿ�ʦ���趨�ı�ע��Ƶ���µ���ʼ֡�ͽ���֡��
%
% ����ע�����
% 1.����ǰ��Ҫ��֤��code3.2.1���͡�toolbox�������ļ��е�·��д�� matlab ·���У�
% 2.�����޸ĵ� seq �ļ��� txt ��ע�ļ��ֱ���ڡ�SourceSeq���͡�SourceTxt���ļ����У�
% 3.�򿪡�SourceSeq���ļ��е� crop_file.txt�����ļ����� seq �ļ���Ĭ������˳�򣬼�¼ÿ�� seq �ļ���
%   ����ʼ֡�ͽ���֡�����ݼҿ�ʦ�ֵĻ��֣����ԡ�;����Ϊ�ֶεķָ��������� crop_file.txt ������Ϊ��
%   20131203-173901;1;1535
%   20131218-191257;1;1103
%   20131218-191521;1;822
% 4.�����Ľ�������ڡ�ResultSeq���͡�ResultTxt���ļ��С�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear;
clc;

% ��ȡ SourceSeq �ļ��е����� seq �ļ�
seqNameList = dir('.\SourceSeq\*.seq');          
% ��ȡcrop_file.txt�ļ��������Ϣ
cropInfo = importdata('.\SourceSeq\crop_file.txt');
% ��ȡ SourceTxt �ļ��е����� txt �ļ�
txtNameList = dir('.\SourceTxt\*.txt');

% ��ÿ��seq�ļ��Ͷ�Ӧ��txt��ע�ļ������޸�
for i = 1:length(seqNameList)
    %% ��seq�ļ������޸�
    fNameSeq = strcat('.\SourceSeq\', seqNameList(i).name);   % ԭʼ�� seq �ļ����ڵ�·��+����
    tNameSeq = strrep(fNameSeq, 'SourceSeq', 'ResultSeq');    % �޸ĺ�� seq �ļ����ڵ�·��+����
    startFrame = cropInfo.data(i,1);                          % �µ���ʼ֡
    endFrame = cropInfo.data(i,2);                            % �µĽ���֡
    frameNum = endFrame - startFrame + 1;                     % �޸ĺ��֡��
    
    frames = ones(1,frameNum);                                % �˱�����¼�޸ĺ��֡������ԭʼ seq �ļ���֡�����Ķ�Ӧ��ϵ
    for j = 1:frameNum
        frames(j) = j + startFrame - 2;                       % ��2��ԭ���ǣ����� startFrame �Ǵ�1��ʼ�����j-1������ seqIo ������֡������0��ʼ������ټ�ȥ1
    end
    
    seqIo(fNameSeq, 'crop', tNameSeq, frames);
    
    %% ��Ӧ��txt��ע�ļ��޸�
    fNameTxt = strcat('.\SourceTxt\', txtNameList(i).name);   % ԭʼ�� txt �ļ����ڵ�·��+����
    tNameTxt = strrep(fNameTxt, 'SourceTxt', 'ResultTxt');    % �޸ĺ�� txt �ļ����ڵ�·��+����
    A = vbb('vbbLoadTxt', fNameTxt);                          % ����txt�ļ�
    
    A.nFrame = frameNum;                                      % A.nFrame��seq�ļ�����֡��
    
    A.objLists(1:(startFrame-1)) = [];                        % A.objLists����¼ÿ֡��Ӧ�ı�ע��Ϣ�������ɾ�����µ���ʼ֮֡ǰ����Ϣ
    A.objLists(frameNum+1:end) = [];                          % ɾ�����µĽ���֮֡�����Ϣ

    A.objStr(:) = A.objStr(:) - startFrame + 1;               % �����µ���ʼ֡������ÿ��Ŀ���Ӧ����ʼ֡
    A.objEnd(:) = A.objEnd(:) - startFrame + 1;               % �����µĽ���֡������ÿ��Ŀ���Ӧ�Ľ���֡
    
    vbb('vbbSaveTxt', A, tNameTxt);                           % ����txt�ļ�
end



