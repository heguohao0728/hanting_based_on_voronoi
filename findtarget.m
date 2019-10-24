function [agents]=findtarget(agents,pursuers_num,agents_sum)
    for i=1:pursuers_num
            if sum(agents(i).neightbor.id>pursuers_num) % 如果pursuer周围有evader则走中点
                near_id=find(agents(i).neightbor.id>pursuers_num); % 找neighbor是evader的id
                temp_err=agents(i).pos-agents(i).neightbor.mid_point(near_id,:);
                temp_dis=sum(abs(temp_err).^2,2).^(1/2);
                min_index = find(temp_dis==min(min(temp_dis))) + sum(agents(i).neightbor.id<=pursuers_num); % 加上pursuer的ID,很重要，因为temp_dis舍去了前面id
%                 agents(i).target=agents(i).neightbor.mid_point(min_index,:); % 找到最近的evader
                agents(i).targetid=agents(i).neightbor.id(min_index);
            else % 如果pursuer周围没有evader则朝最近的evader走过去
                for j=(pursuers_num+1):agents_sum
                    if agents(j).active
                        dis=norm(agents(i).pos - agents(j).pos);
                        if dis < agents(i).min_dis
                            agents(i).min_dis=dis; %计算每个evader到所有的pursuer的最小距离
%                             agents(i).target=agents(j).pos;
                            agents(i).targetid=j;
%                             agents(i).up=(agents(i).target-agents(i).pos)/norm((agents(i).target-agents(i).pos));
                        end
                    end
                end
            end
    end
    for i=1:agents_sum
        agents(i).min_dis=100;
    end
end