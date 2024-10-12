**Nume:** Manolache Maria-Catalina
**Grupa:** 313CA

**Algoritmi fundamentali in Assembly:**
Proiectul contine cativa algoritmi fundamentali in Assembly care includ verificarea
parantezelor folosind stiva, cautare binara, parcurgerea in adancime a grafurilor si
implementari ale functionalelor map si reduce in assembly x64.

## Task 1: Parantezinator

Se obtine argumentul functiei, adica sirul de verificat.
    Se presupune ca parantezarea este corecta, adica se pune 0 in eax.
Se parcurge sirul de caractere dat si se adauga codul ASCII al fiecarei 
paranteze deschise pe stiva. Cand se intalneste o paranteza inchisa, se
verifica daca ultima paranteza deschisa este de acelasi tip ca cea inchisa.
Daca da, se continua cu urmatorul caracter. Daca nu, se returneaza 1, ceea ce
inseamna ca parantezarea este gresita.

## Task 2: Divide et impera

- `Cautare binara`

    Se obtin argumentele functiei, conform conventiei `fastcall`: ecx va
contine vectorul buff, edx va contine needle, elementul de cautat, iar restul
argumentelor se vor gasi pe stiva.

    La fiecare apel al functiei, se verifica daca marginile intervalului
sunt valide, apoi se calculeaza mijlocul intervalului si se verifica daca
elementul de la acel indice este egal cu elementul cautat. Daca da, se
returneaza indicele mijlociu. Daca nu, se verifica daca elementul cautat este
mai mic sau mai mare decat elementul de la indicele mijlociu si se face un nou
apel recursiv pe jumatatea corespunzatoare a intervalului.

    Daca elementul este mai mic decat indicile mijlociu, se apeleaza functia
cu capetele start si mid - 1, adica pentru prima jumatate a intervalului.

    Daca elementul este mai mare decat indicile mijlociu, se apeleaza functia
cu capetele mid + 1 si end, adica pentru a doua jumatate a intervalului.

    In final, se restaureaza registrii salvati la inceputul functiei.

## Task 3: Depth first search

Se obtin argumentele functiei, adica nodul din care va porni DFS si
pointerul la functia `expand`.

Se verifica daca nodul din care va porni algoritmul a fost vizitat. Daca
da, programul se opreste. In caz contrar, se marcheaza nodul ca fiind vizitat.

Apoi, se apeleaza functia `printf` pentru a-l afisa.
Se apeleaza functia `expand` pentru a obtine vectorul de vecini ai nodului
curent, precum si numarul lor.

Se parcurge fiecare vecin al nodului si se verifica daca acesta a fost
vizitat. Daca da, se sare peste el. Daca nu a fost vizitat, se apeleaza DFS
cu el ca nod sursa. Apoi, se continua cu urmatorul vecin, pana cand toate
nodurile din graf au fost vizitate.

In final, se restaureaza registrii salvati la inceputul functiei.

## Bonus: x64 assembly

- `map`
    
    Se obtin argumentele functiei, stocate in registrii rdi, rsi, rdx si rcx,
conform conventiei x64.

    Se parcurge vectorul source_array si se apeleaza functia data ca parametru
pe fiecare element al sau. Rezultatele vor fi stocate in vectorul
destination_array.

- `reduce`
    
    Se obtin argumentele functiei, stocate in registrii rdi, rsi, rdx, rcx si
r8, conform conventiei x64.

    Se intializeaza acumulatorul cu valoarea sa initiala, data ca parametru.
    Se parcurge vectorul source_array si se apeleaza functia data ca parametru,
avand ca argumente acumulatorul si fiecare element al vectorului. Fiecare apel
al acestei functii va actualiza acumulatorul, iar valoarea sa finala va fi
returnata.