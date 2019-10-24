%计算Up
% function [agents]=calup(agents,pursuers_num,agents_sum)
%     for i=1:pursuers_num
%             if sum(agents(i).neightbor.id>pursuers_num) % 如果pursuer周围有evader则走中点
%                 near_id=find(agents(i).neightbor.id>pursuers_num); % 找neighbor是evader的id
%                 temp_err=agents(i).pos-agents(i).neightbor.mid_point(near_id,:);
%                 temp_dis=sum(abs(temp_err).^2,2).^(1/2);
%                 min_index = find(temp_dis==min(min(temp_dis))) + sum(agents(i).neightbor.id<=pursuers_num); % 加上pursuer的ID,很重要，因为temp_dis舍去了前面id
%                 agents(i).target=agents(i).neightbor.mid_point(min_index,:); % 找到最近的evader
%                 agents(i).up=(agents(i).target-agents(i).pos)/norm((agents(i).target-agents(i).pos));
%             else % 如果pursuer周围没有evader则朝最近的evader走过去
%                 for j=(pursuers_num+1):agents_sum
%                     if agents(j).active
%                         dis=norm(agents(i).pos - agents(j).pos);
%                         if dis < agents(i).min_dis
%                             agents(i).min_dis=dis; %计算每个evader到所有的pursuer的最小距离
%                             agents(i).target=agents(j).pos;
%                             agents(i).up=(agents(i).target-agents(i).pos)/norm((agents(i).target-agents(i).pos));
%                         end
%                     end
%                 end
%             end
%         end
% end
function [agents]=calup(agents,pursuers_num,agents_sum,square_x,square_y)
    for i=1:agents_sum
    agents(i).up=0;
    end
    for i=1:pursuers_num
        agents(i).target=[];
    end
    for i=1:pursuers_num
        newagents(i)=agents(i);
    end
    for i=1:pursuers_num
        newagents(pursuers_num+1)=agents(agents(i).targetid);
        [V,C,vx,vy,index_active,temp_pos]=generate(newagents,pursuers_num);
        % 更新有限区域内的元胞顶点
        [V,C]=boundlimit(V,C,square_x,square_y);
        % 把正方形与维诺图的交点以及正方形顶点加入维诺图索引
        [V,C]=pointonpoly(V,C,vx,vy,square_x,square_y,temp_pos);
        newagents=calneighbor(V,C,newagents,pursuers_num+1);
        if sum(newagents(i).neightbor.id>pursuers_num) % 如果pursuer周围有evader则走中点
                near_id=find(newagents(i).neightbor.id>pursuers_num); % 找neighbor是evader的id
                temp_err=newagents(i).pos-newagents(i).neightbor.mid_point(near_id,:);
                temp_dis=sum(abs(temp_err).^2,2).^(1/2);
                min_index = find(temp_dis==min(min(temp_dis))) + sum(newagents(i).neightbor.id<=pursuers_num); % 加上pursuer的ID,很重要，因为temp_dis舍去了前面id
                newagents(i).target=newagents(i).neightbor.mid_point(min_index,:); % 找到最近的evader
                newagents(i).up=(newagents(i).target-newagents(i).pos)/norm((newagents(i).target-newagents(i).pos));
        else % 如果pursuer周围没有evader则朝最近的evader走过去
                dis=norm(newagents(i).pos - newagents(pursuers_num+1).pos);
                if dis < newagents(i).min_dis
                    newagents(i).min_dis=dis; %计算每个evader到所有的pursuer的最小距离
                    newagents(i).target=newagents(pursuers_num+1).pos;
                    newagents(i).up=(newagents(i).target-newagents(i).pos)/norm((newagents(i).target-newagents(i).pos));
                end
        end
    end
    for i=1:pursuers_num
        agents(i).target=newagents(i).target
        agents(i).up=newagents(i).up;
    end
end