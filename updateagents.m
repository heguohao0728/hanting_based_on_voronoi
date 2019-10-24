function [agents]=updateagents(agents,pursuers_num,agents_sum,t_step)
    %画出移动路径
        for i=1:pursuers_num
            hold on
            plot([agents(i).pos(1,1);agents(i).target(1,1)], [agents(i).pos(1,2);agents(i).target(1,2)],'g-')
        end
        %只更新active的pursuers位置
        for i=1:pursuers_num
            if agents(i).active
                agents(i).pos =agents(i).pos + t_step * agents(i).up;
            end
        end
        
        %只更新active的evader的位置
        for i=pursuers_num+1:agents_sum
            if agents(i).active
                agents(i).pos = agents(i).pos + t_step * agents(i).ue;
            end
        end
end