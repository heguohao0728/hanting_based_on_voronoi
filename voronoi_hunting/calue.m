%计算Ue，控制策略是往每个evader所在元胞的形心移动
%思路是，需要通过C，构造一个储存evader所在元胞的形心的矩阵（虽然C在每次有evader死掉后都会更新，
%                      其长度会变短，但是总是从C{5}开始到末尾都是储存的evader的索引，所以通过C
%                      能够很好的遍历完所有存活的evader的索引）
%然后再遍历所有evader，找到其中存活的，按顺序从上到下从上述矩阵里取形心坐标当目标

function [agents]=calue(agents,pursuers_num,agents_sum,square_x,square_y)
%evader不应该被其他的evader限制了逃跑的路径，所以算Ue的时候应该只考虑四个pursurer对某个evader的影响。
%意思是要对evader重新画关于四个pursurer的维诺图，找到在这个维诺图下自己元胞的中心。
for i=1:agents_sum
    agents(i).ue=0;
end
j=1;
for i=pursuers_num+1:agents_sum
    if agents(i).active==1
        newevaders(j)=agents(i);
        j=j+1;
    end
end
for j=1:length(newevaders)
    %生成新维诺图
    for k=1:pursuers_num
        newagents(k)=agents(k);
    end
    newagents(5)=newevaders(j);
    [V,C,vx,vy,index_active,temp_pos]=generate(newagents,pursuers_num);
    % 更新有限区域内的元胞顶点
    [V,C]=boundlimit(V,C,square_x,square_y);
    % 把正方形与维诺图的交点以及正方形顶点加入维诺图索引
    [V,C]=pointonpoly(V,C,vx,vy,square_x,square_y,temp_pos);
    %----------------------------------------------------
    
    %计算Ue
    cen=[];%用来储存质心的矩阵
    for i=pursuers_num+1:length(C)
        xe=[];
        ye=[];
        for p=1:length(C{i})
            xe=[xe V(C{i}(p),1)];
            ye=[ye V(C{i}(p),2)];
        end
        polyin = polyshape(xe,ye);
        [xc,yc]=centroid(polyin);
        cen=[cen;[xc yc]];
    end
    newevaders(j).target=cen;
    newevaders(j).ue=(newevaders(j).target-newevaders(j).pos)/norm((newevaders(j).target-newevaders(j).pos));
    newagents(pursuers_num+1)=[];
end
k=1;
for i=pursuers_num+1:agents_sum
    if agents(i).active
        agents(i).ue=newevaders(k).ue;
        k=k+1;
    end
end
end