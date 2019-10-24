%判断抓捕
function [agents]=catchornot(agents,pursuers_num,agents_sum,capture_dis)
    % 判断是否触发被捕获
        for i=(pursuers_num+1):agents_sum
            if agents(i).active
                for j=1:pursuers_num
                    dis=norm(agents(i).pos - agents(j).pos); 
                    if dis < agents(i).min_dis
                        agents(i).min_dis=dis; %计算每个evader到所有的pursuer的最小距离
                    end
                end
                % 判断evader被成功捕获的触发条件
                if agents(i).min_dis < capture_dis
                    agents(i).active=0;
                    for j=1:pursuers_num
                        agents(j).min_dis=100;% evader死掉后，需要更新下pursuer的min_dis距离，否则会朝着死掉的evader继续前进
                    end
                    hold on
                    plot(agents(i).pos(1,1),agents(i).pos(1,2),'g*')
                end
            end
        end
end