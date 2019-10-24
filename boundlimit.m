%限制区域
function [V,C]=boundlimit(V,C,square_x,square_y)
    for i=1:length(C)
            out_index=[];
            inf_index=[];
            if sum(C{i}==1) % 找到元胞中无穷远的点的索引
                inf_index=find(C{i}==1);
            end
            for j=1:length(C{i}) % 找到元胞中正方形外的点的索引
                [in on]= inpolygon(V(C{i}(j),1),V(C{i}(j),2),square_x,square_y);
                if in==0 && on==0 % 在外部
                    out_index=[out_index j];
                end
            end
            out_index=[inf_index out_index]; % 清除无穷远点和外部点的索引，必须一起清除，否则先后顺序会导致删除后元胞顶点数目发生变化
            C{i}(out_index)=[]; % 不能清除V的顶点，否则C{i}中顶点的无法索引
        end
end