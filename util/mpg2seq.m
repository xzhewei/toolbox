sDir = 'F:\DataSet\SCUT_FIR_102\0.raw\20170511\mpg\';
info.width = 0;
info.height = 0;
info.fps = 0;

info.quality = 80; % 图像压缩质量 100 质量最好 0 最差，一般设为80
info.codec = 'jpg'; % png格式图像较大，可以选择jpg
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
