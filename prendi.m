function [h]=prendi(cosa)

switch cosa

case 'scarica'
   h=str2num(get(gcbo,'string'));

case 'canali'
   h=str2num(get(gcbo,'string'));
      
end
