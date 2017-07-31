path = 'G:/data/FS';
dlist = dir([path '/annotations']);
dlist = struct2cell(dlist);
dlist = dlist(1,:);
list = dlist(3:end);

diary([path '/export/log-' datestr(datetime, 'yyyy-mm-dd-HH-MM-ss') '.txt']);
diary on;

tDir = path;
flatten = 1; %ȫ�������һ���ļ����£�0���ļ����ļ������
skip = 25; %����֡���
dbExport( list, tDir, flatten, skip );

% ��Ⱥ�߶Ȼ���
hmin = 20;
midh = 48;
farh = 90;
rmin = 1.5;
rmax = 4;

% set up opts for training detector (see acfTrain)
opts=train();
opts.modelDs=[midh*rmin midh]; 
opts.nNeg=25000;        
opts.nAccNeg=50000;
opts.posGtDir=[path '/export/annotations'];
opts.posImgDir=[path '/export/images'];
cd(fileparts(which('testdbExport.m')))
opts.name='../models/scut+';
pLoad={'lbls',{'walk_person','ride_person'}};
opts.pLoad = [pLoad 'hRng',[0,inf],'vRng',[1 1] ]; %hRng�Ǹ߶ȷ�Χ vRng �ǿɼ���Χ
opts.winsSave = 1;%����
opts.imRng = [40,90,639,329]; %���ǵĺ������ݼ���ȥ�ڱߺ�����ϽǺ����½�
opts.xWinSave.tDir=[path '/export/wins'];
stage = 0;



%������
%Զ��������
opts.xWinSave.tDir = [path '/export/wins/pos/far'];
opts.pLoad{4}=[hmin midh];
detector.opts = opts;
diary on;
fprintf(['Extract Far Positive Sample To:' opts.xWinSave.tDir '\n']);
Isf = winExport( detector, stage, 1 );
%�о�������
opts.xWinSave.tDir = [path '/export/wins/pos/mid'];
opts.pLoad{4}=[midh farh];
detector.opts = opts;
diary on;
fprintf(['Extract Middle Positive Sample To:' opts.xWinSave.tDir '\n']);
Ism = winExport( detector, stage, 1 );
%����������
opts.xWinSave.tDir = [path '/export/wins/pos/ner'];
opts.pLoad{4}=[farh Inf];
detector.opts = opts;
diary on;
fprintf(['Extract Near Positive Sample To:' opts.xWinSave.tDir '\n']);
Isn = winExport( detector, stage, 1 );
% 
% %������
% %������������Ḻ����
% opts.pLoad{4} = [0 Inf];
% opts.xWinSave.tDir = [path '/export/wins/neg_rand'];
% detector.opts = opts;
% diary on;
% fprintf(['Extract Random Negative Sample To:' opts.xWinSave.tDir '\n']);
% Is0 = winExport( detector, stage, 0 ); %�������õ�Ŀ�괰�ڴ�С��ͼƬ�л����������ȡ
% 
% 
% stage = -1;
% %����ROI�����Ḻ����
% roiOpts = {'imRng',[40,90,639,329],...[c,r,w,h] %����w��h�����涨�嶼����1
%        'chnConnec',4,...
%        'hRng',[20 inf],...
%        'ratioRng',[1.5 4],...
%        };
% opts.xWinSave.tDir = [path '/export/wins/neg_dualseg'];
% opts.pLoad={};
% opts.roiOpts = roiOpts;
% detector.opts = opts;
% diary on;
% fprintf(['Extract DualSegment Negative Sample To:' opts.xWinSave.tDir '\n']);
% Is2 = winExport( detector,stage, 0 );


