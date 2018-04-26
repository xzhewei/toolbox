function det2dir(detfile, imgDir, tDir)
  res_boxes = load(detfile,'-ascii');
  imgNms = bbGt('getFiles',{imgDir});
  [cache_dir, detName] = fileparts(detfile);
  if exist('tDir','var'), cache_dir = tDir; end
  cache_dir = fullfile(cache_dir,detName);
  mkdir_if_missing(cache_dir)
  for i = 1:numel(imgNms)
    [~,imgName] = fileparts(imgNms{i});
    sstr = strsplit(imgName, '_');
    mkdir_if_missing(fullfile(cache_dir,sstr{1}));
    fid = fopen(fullfile(cache_dir, sstr{1}, [sstr{2} '.txt']), 'a');
    boxes = res_boxes(res_boxes(:,1)==i,2:end);
    for j = 1:size(boxes, 1)
        fprintf(fid, '%d,%f,%f,%f,%f,%f\n', ...
            str2double(sstr{3}(2:end))+1, boxes(j, :));
    end
    fclose(fid);
  end
end