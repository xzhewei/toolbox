dataPath = 'D:\BaiduYunDownload\';

path1 = 'Dong_Yong\2013.12.3\';
path2 = 'Dong_Yong\2013.12.3\extract\';
path3 = 'Dong_Yong\2013.12.28\';
path4 = 'Hua_Nan_Nong_Ye_Da_Xue\2013.12.18\Night\';
path5 = 'Hua_Nan_Nong_Ye_Da_Xue\2013.12.18\Afternoon\';
path6 = 'Chang_Zhou_Dao\2013.12.3\';
path7 = 'Chang_Zhou_Dao\2013.12.13\';
path8 = 'Da_Xu_Cheng_\Huan_Heng_Lu\2013.12.6\';
path9 = 'Da_Xu_Cheng_\Nei_Huan\2013.12.6\';
path10 = 'Da_Xu_Cheng_\Nei_Huan\2013.12.20\';
path11 = 'Da_Xu_Cheng_\Wai_Huan\2013.12.10\';
path12 = 'Da_Xu_Cheng_\Zhong_Huan\2013.12.6\';
path13 = 'Da_Xu_Cheng_\Zhong_Huan\2013.12.13\';
path14 = 'Da_Xu_Cheng_\Zhong_Huan\2013.12.20\';
path = path14;
path = [dataPath,path];
seqlist = dir([path,'*.seq']);

for (s = seqlist')
   seqPlayer([path,s.name]);
end


