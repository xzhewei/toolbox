sDir = 'F:\DataSet\SCUT_FIR_102\0.raw\20170511\mpg\';
info.width = 0;
info.height = 0;
info.fps = 0;

info.quality = 80; % ͼ��ѹ������ 100 ������� 0 ��һ����Ϊ80
info.codec = 'jpg'; % png��ʽͼ��ϴ󣬿���ѡ��jpg
list = dir(sDir);
for i = 1:numel(list)
    l = list(i);
   if(l.isdir)
       continue;
   end
   [d,fName,ext] = fileparts(l.name);
   if(strcmp(ext,'.mpg'))
       aviName = [fName '.mpg'];
       seqName = [fName '.seq'];
       seqIo( [sDir seqName], 'frImgs', info, 'aviName', [sDir aviName]);
   end
end

% fName = '20170511-211145';
% aviName = [sDir fName '.mpg'];
% seqName = [sDir fName '.seq'];
% % 
% seqIo( seqName, 'frImgs', info, 'aviName', aviName);
