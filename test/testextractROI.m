%����˫��ֵ�ָ����gt���ٻ���

% // ������Ƶ������352*288�ֱ��ʣ�
% #define VIDEO_HEIGHT 288
% #define VIDEO_WIDTH  352
%
% // ����������
% #define DETECTION_START_ROW  50
% #define DETECTION_START_COL  20
% #define DETECTION_WIDTH      310
% #define DETECTION_HEIGHT     170
% #define HORIZON_LINE         120
%
%
% // ��ѡ��ͼ��ֱ������� *************************
% //// ������Ƶ������720*576�ֱ��ʣ�
% //#define VIDEO_HEIGHT 576
% //#define VIDEO_WIDTH  720
% //
% //// ����������
% //#define DETECTION_START_ROW  90
% //#define DETECTION_START_COL  40
% //#define DETECTION_WIDTH      640
% //#define DETECTION_HEIGHT     330
% //#define HORIZON_LINE         240
% // ******************************************
path = 'G:/data/IR_PD';

opts = {'imRng',[40,90,639,329],...[c,r,w,h] %����w��h�����涨�嶼����1
    'chnConnec',8,...
    'hRng',[20 inf],...
    'ratioRng',[1.5 4],...
    };
opts = getPrmDflt(opts,opts,1);
opts.posGtDir=[path '/export/annotations'];
opts.posImgDir=[path '/export/images'];
opts.pLoad={'lbls',{'walk_person','ride_person'},'hRng',[20 Inf],'vRng',[1 1]};
% path = '../data/20131203-193829_I00389.jpg';
% cd(fileparts(which('testextractROI.m')))
fs={opts.posImgDir,opts.posGtDir};
fs=xbbGt('getFiles',fs); nImg=size(fs,2); assert(nImg>0);
Is=cell(nImg,1);% nImg��֡�����ȼ���ÿ֡�ı�ע�򲻻ᳬ��1000��
roi=cell(nImg,1);
gt =cell(nImg,1);
tid=ticStatus('Sampling windows',1,1);
k=0; i=0; batch=64; %������ȡ i��֡����n��������
stage = -1;
while( i<nImg)
    batch=min(batch,nImg-i);
    for j=1:batch, ij=i+j;%ԭ����parfor
        Is{ij} = feval('imread',fs{1,ij});
        [~,gt{ij}]=xbbGt('bbLoad',fs{2,ij},opts.pLoad);
        roi{ij} = extractROI(Is{ij},opts);
    end
    k=k+j;
    i=i+batch;
    tocStatus(tid,max(i/nImg));
end

dfs={
    'pModify',[], 'thr',.5,'mul',0, 'reapply',0, 'ref',10.^(-2:.25:0), ...
    'lims',[3.1e-3 1e1 .05 1], 'show',0 };
% thr = .5;
mul = 1;
ref = 10.^(-2:.25:0);
show = 1;
lims=[3.1e-3 1e1 .05 1];
thr = 0.1:0.05:0.9;
n = numel(thr);
recall = zeros(n,1);
numgt = zeros(n,1);
ratio = zeros(n,1);



for i = 1:n
    mgt = [];
    [gtt,dt] = xbbGt('evalRes',gt,roi,thr(i),mul);
    mgt = cat(1,gtt{:});
    mgt = mgt(mgt(:,1)>40,:);
    mgt = mgt(mgt(:,2)>90,:);
    mgt = mgt((mgt(:,1)+mgt(:,3))<640,:);
    mgt = mgt((mgt(:,2)+mgt(:,4))<329,:);
    recall(i) = sum(mgt(:,5)==1);
    numgt(i) = sum(mgt(:,5)==0)+recall(i);
    ratio(i) = recall(i)/numgt(i);
    fprintf('Recall %d Num %d Ratio %f.\n',recall(i),numgt(i),ratio(i));
end
figure;
plot(thr,ratio);
xlabel('Area Cover');
ylabel('Recall Rate');
% 
% [fp,tp,score,miss] = xbbGt('compRoc',gt,dt,1,ref);
% miss=exp(mean(log(max(1e-10,1-miss))));
% roc=[score fp tp];
% 
% % optionally plot roc
% if( ~show ), return; end
% figure(show); plotRoc([fp tp],'logx',1,'logy',1,'xLbl','fppi',...
%     'lims',lims,'color','g','smooth',1,'fpTarget',ref);
% title(sprintf('log-average miss rate = %.2f%%',miss*100));















