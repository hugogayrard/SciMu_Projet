function [nouveauxsegments , nouveauxtemps] = AlgoChoix(Tvoulu, Mmarkov, listetemps, listesegments)
% entr�e :  - Tvoulu : Temps de chanson voulu (en secondes)
%           - Mmarkov : Matrice de probabilit� de l'artiste (dans l'ordre : silence, intro, verse, bridge, break, refrain, outro)
%           - listetemps : liste contenant les temps de chaque segment dans
%           la chanson
%           - listesegments : liste contenant les segments de la chanson

% sortie :  - nouveauxsegments : encha�nement des segments dans la chanson finale 
%           - nouveauxtemps : matrice compos�e de deux colonnes : les temps de d�but et de
%           de chaque segment � prendre dans la chanson initiale pour obtenir la
%           chanson modifi�e
    
    listseg = {'silence', 'intro', 'verse', 'bridge', 'break', 'refrain', 'outro'}; % Liste des segmentations dans l'ordre dans la matrice
        
    tTot = 0; % Dur�e de la chanson finale
    iAjout = 0; % Indice du segment � ajouter dans la chanson finale
    
    iIterTot = 0; % Nombre de tour dans la boucle while + nombre d'it�ration sans ajouts
    iIterEchec = 0; % Nombre d'it�rations de segments ne correspondant pas (outro ou silence ou partie non comprise dans la chanson)
    
    iIterEchecMax = 10; % Si on atteint 10 it�rations avec un segment qui ne convient pas � la suite, on ajoute au hasard et on avance
    echecConv = 0; % Nombre d'ajout aux hasard
    
    % calcul de la dur�e de chaque segment
    dureesegments = listetemps(2:end) - listetemps(1:end-1); % dur�e de chaque segment
    
    % On enl�ve le temps d'outro = fin du mor�eau (elle sera ajout�e � la fin)
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

    % Boucle jusqu'� obtenir un mor�eau de la longueur voulu
    while tTot < Tvoulu % Le temps de l'outro a �t� soustrait
        
        % Determination des probas de transition en fonction du dernier ajout
        
        p = cumsum(Mmarkov(rang(listseg,string(nouveauxsegments(end))),:));
        
        % Generation d'un nombre al�atoire en utilisant la loi normale
        r = rand(1,1);
        
        % Determination du type � ajouter en fonction des probas
        AAjouter = 0;
        for i = 1:7
            if (r < p(i))
                AAjouter = i;
                break;
            end
        end

        TypeAAjouter = string(listseg(AAjouter)) % Type de segment � ajouter
        
        
        % Test si ok pour ajout
        if (TypeAAjouter == 'silence') || (TypeAAjouter == 'outro') || (sum(contains(listesegments,TypeAAjouter))==0)
            % Si non ok = outro ou silence ou partie non comprise dans la chanson
            
            iIterEchec = iIterEchec + 1;
            
            % Si on a d�j� 10 echecs on rajoute au hasard parmi les non echecs
            if iIterEchec == iIterEchecMax
                % Au hasard sauf non compris dans la chanson
                listerangssegment=find(count(listseg,listesegments)); % rangs des segments correspondants
                typeAuHasard = listseg(randi(length(listerangssegment),1,1)); % Choix al�atoire d'un segment
                rangsegment = listerangssegment(randi(length(listerangssegment),1,1)); % rang du segment dans la chanson initiale apr�s s�lection al�atoire
                
                % Ajout
                
                iAjout = iAjout + 1;
                tTot = tTot + dureesegments(rangsegment);
                nouveauxsegments(iAjout)=[string(listesegments(rangsegment))];
                nouveauxtemps(iAjout,:)=[listetemps(rangsegment) listetemps(rangsegment+1)]
                
                % Mise � z�ro du nombre d'�chec et augmentation du d�compte du nombre d'�chec
                iIterEchec = 0;
                echecConv = echecConv+1;
            end
            
        else
            %Si ok
            
            % Selection d'un des segments correspondant al�atoirement dans
            % la chanson (par exemple pour un verse : s�lection al�atoire
            % de verse1 ou verse2 ...)
            
            listerangssegment=find(count(listesegments,TypeAAjouter)); % rangs des segments correspondants dans la liste initiale
            rangsegment = listerangssegment(randi(sum(count(listesegments,TypeAAjouter)), 1, 1)); % rang du segment dans la chanson initiale apr�s s�lection al�atoire
            
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