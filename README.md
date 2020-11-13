# Blockchain

Tema 1

Se doreste o implementare care sa permita adunarea de fonduri de la mai multi contribuitori (faza 1) si distribuirea acestora unor beneficiari (faza 2).

Implementati doua contracte: CrowdFunding si DistributeFunding, care sa functioneze in modul descris mai jos:

Contractul CrowdFunding include un o suma tinta - "fundingGoal" - ce se doreste sa fie adunata de la mai multi contribuitori (se poate utiliza o structura pentru includerea informatiilor ce definesc un contribuitor: nume, adresa, etc.).
Contractul DistributeFunding permite adaugarea unui numar de actionari/beneficiari cu rolul de a distribui acestora o suma. Fiecare actionar are o pondere asociata din procentul de 100% al sumei.

Consideram doua "stari" ale implementarii: 1) inainte de atingerea sumei tinta, si 2) dupa atingerea acesteia. Este posibila interograrea acestei stari (ex., cu un raspuns de tip string) la orice moment de catre oricine pentru a sti daca s-a realizat suma tinta sau nu.
Inainte de atingerea sumei tinta, contractul CrowdFunding trebuie sa ofere posibilitatea de:

Depunere a unei sume de catre un contribuitor.
Retragere a oricarei sume depuse de un contribuitor.
Dupa atingerea sumei tinta:

Nu se mai pot retrage sau depune sume.
Proprietarul contractului CrowdFunding poate vira cand doreste suma adunata catre contractul DistributeFunding.
Contractul DistributeFunding va imparti si vira suma primita catre actionari.