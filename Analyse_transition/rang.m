function n=rang(listseg,seg)
k=1;
n=-1;
for k=1:length(listseg)
    if contains(seg, listseg(k))
        n=k;
    end
end
