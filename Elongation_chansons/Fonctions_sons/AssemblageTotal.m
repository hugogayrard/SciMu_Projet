function s = AssemblageTotal(y, tab, DT, Fe)
    % Fonction qui r�alise l'assemblage des segments de chansons de y
    % rang�s � priori dans l'ordre voulu dans un tableau tab (n ligne * 2
    % colonne), avec les temps de d�but et de fin des segments dans la
    % chanson initiale � assembler.
    % DT est la dur�e de transition entre chaque mor�eau.
    addpath(strcat(char(cd),'\Fonctions_sons'))
    clear i;
    
    % Nombre de segments
    nbM = size(tab, 1);
    
    % segment initial - pas besoin de transition avant
    s = y(round(tab(1, 1)*Fe+1):round((tab(1,2) + DT)*Fe+1));
    
    for i = 2:(nbM-1)
        y2 = y(round((tab(i, 1) - DT)*Fe+1):round((tab(i,2) + DT)*Fe+1));
        s = Assemblage(s, y2, DT, Fe);
        
        clear y2; % Au cas o� le segment d'apr�s est plus court et �viter ainsi de rajouter des valeurs du segment pr�c�dent
    end
    
    % Segment final - pas besoin de transition apr�s
    y2 = y(round((tab(end, 1) - DT)*Fe+1):round(tab(end,2)*Fe+1));
    s = Assemblage(s, y2, DT, Fe);
end