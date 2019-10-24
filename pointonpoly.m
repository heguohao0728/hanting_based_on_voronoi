function [V,C]=pointonpoly(V,C,vx,vy,square_x,square_y,temp_pos)
    cross_point=[];
        for i=1:length(vx)
            [xi,yi] = polyxpoly(vx(:,i),vy(:,i),square_x,square_y,'unique');
            cross_point=[cross_point;[xi yi]];
        end
        
        % 把交点和正方形的顶点按顺序储存到V中（不能清除V的顶点，否则C{i}中顶点的无法索引），打上ID
        old_V=V;
        V=[V;cross_point];
        
        % V中新添加的点找最近的两个元胞（用小于等于），并且为元胞打上ID
        C_pos=temp_pos; % 保存元胞的位置
        for i=length(old_V)+1:length(V)
            V_dist=sum(abs(V(i,:)-C_pos).^2,2).^(1/2);
            V_index=find(V_dist==min(V_dist)); % 距离最近的元胞
            if length(V_index)==2
                C{V_index(1)}=[C{V_index(1)} i];
                C{V_index(2)}=[C{V_index(2)} i];
            else
                C{V_index}=[C{V_index} i]; % 把这个点加入到元胞的顶点列表中
                V_dist(V_index)=max(V_dist); 
                V_index=find(V_dist==min(V_dist)); % 倒数第二小的index，实际两者是相同的
                C{V_index}=[C{V_index} i];
            end
        end
        
        % 把正方形的角点加入到V中，添加到最近的元胞，一般顶点只被一个占有，特殊情况也可能两个都占有
        square=[square_x;square_y]';
        square(end,:)=[]; % 去掉正方形重复的角点
        old_V=V;
        V=[V; square];
        for i=length(old_V)+1:length(V)
            V_dist=sum(abs(V(i,:)-C_pos).^2,2).^(1/2);
            V_index=find(V_dist==min(V_dist)); % 距离最近的元胞
            if length(V_index)==2
                C{V_index(1)}=[C{V_index(1)} i];
                C{V_index(2)}=[C{V_index(2)} i];
            else
                C{V_index}=[C{V_index} i]; % 把这个点加入到元胞的顶点列表中
            end
        end
end