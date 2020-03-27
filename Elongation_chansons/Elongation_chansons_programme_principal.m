clear all

% Avant de lancer le programme, il faut être dans le répertoire contenant ce programme

% 1 - Caractéristiques voulues

Tvoulu=240; % Temps de chanson voulu (en secondes)
DT = 0; % Durée de la transition
Fe=44100; % Fréquence d'échantillonage

% 2 - Importation de la matrice de probabilités correspondant à l'artiste

load('matriceBeatles.mat', 'M')  % La matrice M est la matrice de probabilité de l'artiste
listseg = {'silence', 'intro', 'verse', 'bridge', 'break', 'refrain', 'outro'}; % Liste des segmentations de la matrice

% 3 - Ouverture de la segmentation de la chanson dont l'on souhaite modifier la longueur

album='08_-_Sgt._Peppers_Lonely_Hearts_Club_Band'; % Album
chanson='02_-_With_A_Little_Help_From_My_Friends'; % Chanson

C = textscan(fopen(strcat(char(cd),'\','The_Beatles_segmentation\',album,'\',chanson,'.lab')),'%f64%f64%s');
listetemps=[0; C{1,2}(1:end)]; % Liste contenant le temps de passage entre chaque segment de la chanson
listesegments=C{1,3}; % Liste contenant les segments de la chanson (dans l'ordre)

x0=[];
y0=[];
for k=1:length(listesegments)-1
    listesegments(k)=listseg(rang(listseg,listesegments(k)));  % La liste des segments est modifiée pour remplacer par exemple 'brisgea' par 'bridge'
    plotsegments(k)=rang(listseg,listesegments(k)); % Pour l'affichage en fin de programme
    x0=[x0 linspace(listetemps(k),listetemps(k+1),1000)]; % Pour l'affichage en fin de programme
    y0=[y0 ones(1,1000)*plotsegments(k)]; % Pour l'affichage en fin de programme
end

% 4 - Algorithme renvoyant la nouvelle structure de la chanson

[nouveauxsegments1 , nouveauxtemps1] = AlgoChoix(Tvoulu,M,listetemps,listesegments); % AlgoChoix est une fonction créant la nouvelle structure de la chanson finale
[nouveauxsegments2 , nouveauxtemps2] = AlgoChoix(Tvoulu,M,listetemps,listesegments);
[nouveauxsegments3 , nouveauxtemps3] = AlgoChoix(Tvoulu,M,listetemps,listesegments);




% 3 - Ouverture de la chanson dont l'on veut modifier la durée

[y,Fe] = audioread(uigetfile('*.mp3')); % Selection du fichier mp3 de la chanson initiale
T=length(y)/Fe; % Durée totale de la chanson

% 8 - Assemblage

addpath(strcat(char(cd),'\Fonctions_sons')) % Ajout su chemin vers les fonctions de création du son
s = AssemblageTotal(y, nouveauxtemps1, DT, Fe); % Assemblage des segments pour obtenir le nouveau son

% 9 - Enregistrement du son

audiowrite('chanson.wav',s,Fe); % création du nouveau fichier son

% 10 - Affichage

nouveauxtemps1=cumsum([0; nouveauxtemps1(:,2)-nouveauxtemps1(:,1)]);
nouveauxtemps2=cumsum([0; nouveauxtemps2(:,2)-nouveauxtemps2(:,1)]);
nouveauxtemps3=cumsum([0; nouveauxtemps3(:,2)-nouveauxtemps3(:,1)]);
x1=[];
y1=[];
x2=[];
y2=[];
x3=[];
y3=[];
for k=1:length(nouveauxsegments1)
    plotsegments1(k)=rang(listseg,nouveauxsegments1(k));
    x1=[x1 linspace(nouveauxtemps1(k),nouveauxtemps1(k+1),1000)];
    y1=[y1 ones(1,1000)*plotsegments1(k)];
end
for k=1:length(nouveauxsegments2)
    plotsegments2(k)=rang(listseg,nouveauxsegments2(k));
    x2=[x2 linspace(nouveauxtemps2(k),nouveauxtemps2(k+1),1000)];
    y2=[y2 ones(1,1000)*plotsegments2(k)];
end
for k=1:length(nouveauxsegments3)
    plotsegments3(k)=rang(listseg,nouveauxsegments3(k));
    x3=[x3 linspace(nouveauxtemps3(k),nouveauxtemps3(k+1),1000)];
    y3=[y3 ones(1,1000)*plotsegments3(k)];
end

figure(1)
plot(x0,y0,':bs') % Affichage de la chanson initiale
hold on
plot(x1,y1,'-.r*') % Affichage de la chanson finale
% plot(x2,y2,'--mo')
% plot(x3,y3,'--mo')
plot([Tvoulu,Tvoulu],[0.95 7.05],'-.','LineWidth',2)
axis([0 Tvoulu+40 0.95 7.05]);
set(gca,'yticklabel',[ listseg].')
xlabel('temps (en s)')
ylabel('Segment')
legend('Chanson initiale','Chanson finale')


