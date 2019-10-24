function [V,C,vx,vy,index_active,temp_pos]=generate(agents,pursuers_num)
        temp_pos=[];
        % 计算active的agents的voronoi图
        index_active=[agents(:).active];
        index_active = find(index_active);
        temp_pos=[agents(index_active).pos];
        temp_pos=reshape(temp_pos,2,length(index_active))'; %需要转置下
        [vx,vy] = voronoi(temp_pos(:,1),temp_pos(:,2));
        [V,C] = voronoin(temp_pos);
end