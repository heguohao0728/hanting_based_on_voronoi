clear all
for roundnum=1:10
close all
tic;
pursuers_num=4;
evaders_num=8;
agents_sum=pursuers_num+evaders_num;
t_step=0.01;
capture_dis=0.03;
counter=0;
L=1; %边长为1的正方形
square_x=[0 0 L L 0]; % 5个顶点的坐标,第一个和最后一个重合才能形成封闭图形
square_y=[0 L L 0 0];
for i=1:agents_sum
    agents(i).pos=rand(1,2);
    agents(i).active=1; % evader 存活flag
    agents(i).min_dis=100;
end
figure()
while 1
    if sum([agents(pursuers_num+1:agents_sum).active])==0 % 所有的evader都被抓到了
        % 输出视频
        v = VideoWriter('wanghuohuo2.avi');
        v.FrameRate=4;
        open(v);
        writeVideo(v, F);
        close(v);
        timearray(roundnum)=toc;
        disp(['程序运行时间',num2str(toc)]);
        break;     %当所有的evader被抓到就退出循环，结束程序，否则继续执行else
    else
        for i=1:agents_sum
            agents(i).min_dis=100;
        end
        % 生成维诺图
        [V,C,vx,vy,index_active,temp_pos]=generate(agents,pursuers_num);
        
        %画图
        plotvoronoi(pursuers_num,index_active,temp_pos,vx,vy);
        
        % 更新有限区域内的元胞顶点，计算up的关键！预处理：遍历所有的元胞，把元胞C在正方形外的顶点和无穷远的顶点ID都删除掉，只保留在正方形内的顶点
        [V,C]=boundlimit(V,C,square_x,square_y);
        
        % 把正方形与维诺图的交点以及正方形顶点加入维诺图索引
        [V,C]=pointonpoly(V,C,vx,vy,square_x,square_y,temp_pos);
        
        % 计算元胞的neighbor，核心！
        agents=calneighbor(V,C,agents,agents_sum);
        
        % 根据要求找到每个pursurer的target
        agents=findtarget(agents,pursuers_num,agents_sum);
        
        % 根据公式计算up
        agents=calup(agents,pursuers_num,agents_sum,square_x,square_y);

        %计算Ue，控制策略是往每个evader所在元胞的形心移动 
        agents=calue(agents,pursuers_num,agents_sum,square_x,square_y);
        
        %更新agents位置并画出pursuers的追踪路径
        agents=updateagents(agents,pursuers_num,agents_sum,t_step);
        
        % 判断是否触发被捕获
        agents=catchornot(agents,pursuers_num,agents_sum,capture_dis);
    end
    hold off
    counter=counter+1;
    F(counter) = getframe(gcf); %gcf并不是提前定义的变量，直接用就行！
    pause(0.01)
end
end
histfit(timearray);

