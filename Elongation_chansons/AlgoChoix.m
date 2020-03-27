function [nouveauxsegments , nouveauxtemps] = AlgoChoix(Tvoulu, Mmarkov, listetemps, listesegments)
% entrée :  - Tvoulu : Temps de chanson voulu (en secondes)
%           - Mmarkov : Matrice de probabilité de l'artiste (dans l'ordre : silence, intro, verse, bridge, break, refrain, outro)
%           - listetemps : liste contenant les temps de chaque segment dans
%           la chanson
%           - listesegments : liste contenant les segments de la chanson

% sortie :  - nouveauxsegments : enchaînement des segments dans la chanson finale 
%           - nouveauxtemps : matrice composée de deux colonnes : les temps de début et de
%           de chaque segment à prendre dans la chanson initiale pour obtenir la
%           chanson modifiée
    
    listseg = {'silence', 'intro', 'verse', 'bridge', 'break', 'refrain', 'outro'}; % Liste des segmentations dans l'ordre dans la matrice
        
    tTot = 0; % Durée de la chanson finale
    iAjout = 0; % Indice du segment à ajouter dans la chanson finale
    
    iIterTot = 0; % Nombre de tour dans la boucle while + nombre d'itération sans ajouts
    iIterEchec = 0; % Nombre d'itérations de segments ne correspondant pas (outro ou silence ou partie non comprise dans la chanson)
    
    iIterEchecMax = 10; % Si on atteint 10 itérations avec un segment qui ne convient pas à la suite, on ajoute au hasard et on avance
    echecConv = 0; % Nombre d'ajout aux hasard
    
    % calcul de la durée de chaque segment
    dureesegments = listetemps(2:end) - listetemps(1:end-1); % durée de chaque segment
    
    % On enlève le temps d'outro = fin du morçeau (elle sera ajoutée à la fin)
    for i = 1:length(listesegments)
        if listesegments(i) == "outro"
            Toutro = [listetemps(i) listetemps(i+1)];
            toutro = dureesegments(i);
            Tvoulu = Tvoulu - toutro;
            break;
        end
    end
    
    % On commence par le premier segment de la chanson initiale
    
    iAjout = iAjout + 1;
    tTot = tTot + dureesegments(1);
    nouveauxsegments(1)=[string(listesegments(1))];
    nouveauxtemps(1,:)=[listetemps(1) listetemps(2)];

    % Boucle jusqu'à obtenir un morçeau de la longueur voulu
    while tTot < Tvoulu % Le temps de l'outro a été soustrait
        
        % Determination des probas de transition en fonction du dernier ajout
        
        p = cumsum(Mmarkov(rang(listseg,string(nouveauxsegments(end))),:));
        
        % Generation d'un nombre aléatoire en utilisant la loi normale
        r = rand(1,1);
        
        % Determination du type à ajouter en fonction des probas
        AAjouter = 0;
        for i = 1:7
            if (r < p(i))
                AAjouter = i;
                break;
            end
        end

        TypeAAjouter = string(listseg(AAjouter)) % Type de segment à ajouter
        
        
        % Test si ok pour ajout
        if (TypeAAjouter == 'silence') || (TypeAAjouter == 'outro') || (sum(contains(listesegments,TypeAAjouter))==0)
            % Si non ok = outro ou silence ou partie non comprise dans la chanson
            
            iIterEchec = iIterEchec + 1;
            
            % Si on a déjà 10 echecs on rajoute au hasard parmi les non echecs
            if iIterEchec == iIterEchecMax
                % Au hasard sauf non compris dans la chanson
                listerangssegment=find(count(listseg,listesegments)); % rangs des segments correspondants
                typeAuHasard = listseg(randi(length(listerangssegment),1,1)); % Choix aléatoire d'un segment
                rangsegment = listerangssegment(randi(length(listerangssegment),1,1)); % rang du segment dans la chanson initiale après sélection aléatoire
                
                % Ajout
                
                iAjout = iAjout + 1;
                tTot = tTot + dureesegments(rangsegment);
                nouveauxsegments(iAjout)=[string(listesegments(rangsegment))];
                nouveauxtemps(iAjout,:)=[listetemps(rangsegment) listetemps(rangsegment+1)]
                
                % Mise à zéro du nombre d'échec et augmentation du décompte du nombre d'échec
                iIterEchec = 0;
                echecConv = echecConv+1;
            end
            
        else
            %Si ok
            
            % Selection d'un des segments correspondant aléatoirement dans
            % la chanson (par exemple pour un verse : sélection aléatoire
            % de verse1 ou verse2 ...)
            
            listerangssegment=find(count(listesegments,TypeAAjouter)); % rangs des segments correspondants dans la liste initiale
            rangsegment = listerangssegment(randi(sum(count(listesegments,TypeAAjouter)), 1, 1)); % rang du segment dans la chanson initiale après sélection aléatoire
            
            % Ajout
            
            iAjout = iAjout + 1;
            tTot = tTot + dureesegments(rangsegment);
            nouveauxsegments(iAjout)=[string(listesegments(rangsegment))];
            nouveauxtemps(iAjout,:)=[listetemps(rangsegment) listetemps(rangsegment+1)];

            end
            
        iIterTot = iIterTot + 1;
    end
    
    % On rajoute l'outro
    
    iAjout = iAjout + 1;
    tTot = tTot + dureesegments(rangsegment);
    nouveauxsegments(iAjout)=['outro'];
    nouveauxtemps(iAjout,:)=Toutro;
end