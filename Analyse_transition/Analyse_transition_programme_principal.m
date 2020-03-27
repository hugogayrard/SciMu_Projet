clear all
Groupe = 'Carole King';
listalbum = dir(strcat('C:\Users\Pierre\Desktop\COURS SCIENCE ET MUSIQUE\Projet élongation musicale\seglab\', Groupe));
l=1;
listseg = {'silence', 'intro', 'verse', 'bridge', 'break', 'refrain', 'outro'};
M = zeros(length(listseg));

for j=1:length(listalbum)
    k=0;
    list = dir(strcat('C:\Users\Pierre\Desktop\COURS SCIENCE ET MUSIQUE\Projet élongation musicale\seglab\', Groupe, '\',listalbum(j).name,'\*')); % Sélection d'un album des Beatles 
    for i=1:length(list)
        [filepath,name,ext] = fileparts(strcat(listalbum(j).name,'\',list(i).name));
        if strcmp(ext,'.lab') % On ne sélectionne que les fichiers .lab
            k=k+1;
            filid=fopen(strcat('C:\Users\Pierre\Desktop\COURS SCIENCE ET MUSIQUE\Projet élongation musicale\seglab\', Groupe, '\',listalbum(j).name,'\',list(i).name));
            C = textscan(filid, '%f64%f64%s');
            s(k, j).song=list(i).name;  % s est une structure contenant le nom de la chanson, la durée de chaque segment et son attribut pour chaque chanson de l'album
            s(k, j).deb=C{1,1}
            s(k, j).fin=C{1,2};
            s(k, j).seg=C{1,3};;
            
            
            precedent = rang(listseg,s(k, j).seg{1});
            for n = 2:length(s(k, j).seg)
                actuel=rang(listseg,s(k, j).seg{n});
                if and(precedent~=-1,actuel~=-1)
                    M(precedent,actuel)=M(precedent,actuel)+1;
                end
                precedent = actuel;
            end
                
                    
        end
    end
end

for i = 1:7
    SLi = 0;
    for j = 1:7
        SLi = SLi + M(i,j); 
    end
    if SLi ~= 0
        M(i,:) = M(i,:)/SLi;
    end
end
save('matriceCaroleKing.mat','M')