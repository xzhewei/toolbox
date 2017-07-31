path = 'G:/data/FS';
dlist = dir([path '/annotations']);
dlist = struct2cell(dlist);
dlist = dlist(1,:);
list = dlist(3:end);

diary([path '/export/log-' datestr(datetime, 'yyyy-mm-dd-HH-MM-ss') '.txt']);
diary on;

tDir = path;
flatten = 1; %全部输出在一个文件夹下，0按文件分文件夹输出
skip = 25; %隔几帧输出
dbExport( list, tDir, flatten, skip );

% 人群尺度划分
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
opts.pLoad = [pLoad 'hRng',[0,inf],'vRng',[1 1] ]; %hRng是高度范围 vRng 是可见范围
opts.winsSave = 1;%保存
opts.imRng = [40,90,639,329]; %我们的红外数据集除去黑边后的左上角和右下角
opts.xWinSave.tDir=[path '/export/wins'];
stage = 0;



%正样本
%远距离行人
opts.xWinSave.tDir = [path '/export/wins/pos/far'];
opts.pLoad{4}=[hmin midh];
detector.opts = opts;
diary on;
fprintf(['Extract Far Positive Sample To:' opts.xWinSave.tDir '\n']);
Isf = winExport( detector, stage, 1 );
%中距离行人
opts.xWinSave.tDir = [path '/export/wins/pos/mid'];
opts.pLoad{4}=[midh farh];
detector.opts = opts;
diary on;
fprintf(['Extract Middle Positive Sample To:' opts.xWinSave.tDir '\n']);
Ism = winExport( detector, stage, 1 );
%近距离行人
opts.xWinSave.tDir = [path '/export/wins/pos/ner'];
opts.pLoad{4}=[farh Inf];
detector.opts = opts;
diary on;
fprintf(['Extract Near Positive Sample To:' opts.xWinSave.tDir '\n']);
Isn = winExport( detector, stage, 1 );
% 
% %负样本
% %基于随机网络提负样本
% opts.pLoad{4} = [0 Inf];
% opts.xWinSave.tDir = [path '/export/wins/neg_rand'];
% detector.opts = opts;
% diary on;
% fprintf(['Extract Random Negative Sample To:' opts.xWinSave.tDir '\n']);
% Is0 = winExport( detector, stage, 0 ); %根据设置的目标窗口大小，图片中画网格随机提取
% 
% 
% stage = -1;
% %基于ROI方法提负样本
% roiOpts = {'imRng',[40,90,639,329],...[c,r,w,h] %这里w和h与上面定义都少了1
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


