%计算每个元胞的临近元胞（在全局维诺图下）
function [agents]=calneighbor(V,C,agents,agents_sum)
    common_index=[];
    common_id=[];
    comi=0;
    for i=1:agents_sum 
        if agents(i).active==0
           comi=comi+1; 
        end
        if agents(i).active
        comj=0;
        for j=1:agents_sum
            if agents(j).active==0
                comj=comj+1;
            end
            if agents(j).active
            if i~=j
                temp_common=intersect(C{i-comi},C{j-comj});
                if length(temp_common)==2
                    common_index=[common_index;temp_common];
                    common_id=[common_id;j];
                end
            end
            end
        end
        if length(common_id)~=0 % 避免出现某两个common_id为空导致程序不能运行
            agents(i).neightbor.id=common_id;
            agents(i).neightbor.shared_boundary=common_index;
            agents(i).neightbor.mid_point= (V(common_index(:,1),:) + V(common_index(:,2),:))/2;  
            common_index=[]; %清空
            common_id=[];
        end
        end
    end
end