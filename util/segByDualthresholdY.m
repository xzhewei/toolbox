function rois = extractROI(I,varargin)
% 从图像中提取ROI区域
%
% 对图像I提取ROI区域，目前只实现了双阈值分割的方法
%
% USAGE
%  dbExtract( list, tDir, flatten, skip )
%
% INPUTS
%  I        - NxM 输入的全尺寸图像
%  opts     - [] 提取参数
%       imRng       - [] 提取的图像范围
%       chnConnec   - 4  连通取的方式，默认4连通
%       hRng        - [] roi高度范围
%       ratioRng    - [] 宽高比范围
%
% OUTPUTS
%
% EXAMPLE
%  see testdbExport
%
% See also vbb testdbExport dbExtract
%
% Zavier's Computer Vision Matlab Toolbox      Version 0.0.1
% Copyright 2017 Zhewei Xu.         [xzhewei-at-gmail.com]
%
dfs = {'imRng',[0 0 0 0],...[c,r,w,h]
       'chnConnec',4,...
       'hRng',[],...
       'ratioRng',[],...
       };
opts = getPrmDflt(varargin,dfs,-1);
if(ndims(I)>2), I = rgb2gray(I); end
if(~isempty(opts.imRng))
    imRng = opts.imRng;
    Ic = imcrop(I,opts.imRng); 
else
    Ic = I;
end


ro = SegByDualthresholdY(Ic,[],opts.imRng(4)+1,opts.imRng(3)+1);
[lc,m] = bwlabel(ro,opts.chnConnec);
bb=regionprops(lc,'BoundingBox');
rois = struct2cell(bb);
rois = cat(1,rois{:});
n = size(rois,1);
if(n==0), rois=zeros(0,5); return; end


flag = fliter(rois,m,opts);
if(all(flag==0)), rois=zeros(0,5); return; end
rois = [rois,ones(n,1)];
% figure(1);
% imshow(Ic);
% figure(2);
% imshow(lc);hold on;
% for i=1:m
%     if(flag(i))
%         rectangle('position',bb(i).BoundingBox,'edgecolor','r');
%     else
% %         rectangle('position',bb(i).BoundingBox,'edgecolor','g');
%     end
% end
% hold off;
% 
% figure(1);hold on;
% for i=1:m
%     if(flag(i))
%         rectangle('position',rois(i,1:4),'edgecolor','r');
%     else
% %         rectangle('position',bb(i).BoundingBox,'edgecolor','g');
%     end
% end
rois(:,1) = rois(:,1)+imRng(1)-1;
rois(:,2) = rois(:,2)+imRng(2)-1;
rois = rois(logical(flag),:);
end

function flag = fliter(bb,m,opts) %根据尺度约束过滤bb
   flag = ones(m,1);
   for i=1:m
       %过滤高度范围
       if(~isempty(opts.hRng)&&...
           (bb(i,4)<opts.hRng(1)||bb(i,4)>opts.hRng(2)))
           flag(i) = 0;
       end
       %过滤宽高比范围
       if(~isempty(opts.ratioRng)) 
           r = bb(i,4)/bb(i,3);
           if(r<opts.ratioRng(1)||r>opts.ratioRng(2))
               flag(i)=0;
           end
       end
   end
end