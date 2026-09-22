
# Rapport Functioneel Paradigma Opdracht
Auteur: Yasin Geddi <br>
Student nr: 1577820 <br>
Klas: 



## Inleiding 
Functioneel programmeren wordt steeds belangrijker in het softwarelandschap vanwege de voordelen op het gebied van eenvoud, onderhoudbaarheid en parallelliteit. In deze opdracht ga ik me verdiepen in het functionele paradigma door zelf een algoritme of programma te implementeren in een functionele taal naar keuze. Het doel is dat ik functionele concepten leer herkennen, begrijpen en toepassen in een zelfgekozen context.


## Onderzoek 
Voor deze opdracht heb ik gekozen om met de taal Haskell te werken. 

Eigenschappen van Haskell zijn:
 - Puur fuctionlele taal (alleen pure functies)
 - Immutible variablen (kan variabelen niet veranderen)
 - Lazy evaluation (code wordt pas uitgevoerd als het echt nodig is)
 - Type inference (datatype hoef je niet handmatig aan te geven)
 - Pattern matching (herkent patronen)
 - Higher-order functions (functies nemen of returnen andere functies)



## Challenge 
Als challenge heb ik gekozen om een tic-tac-toe algoritme te maken.
De grootste uidaging is door middel van een algoritme ervoor zorgen dat de computer de best mogelijke zet doet. Daarnaast is het ook een behoorlijke uitdaging om dit te doen met alleen maar immutible variablen en zonder for loop. 


### MiniMax
Om een bot te maken voor het "tic-tac-toe" spel, heb ik er voor gekozen om het minimax algoritme te gebruiken.
Dit algoritme probeert elke mogelijke zet uit, en vergelijkt de resultaten met elkaar. 
Dit werkt via een boom constructie, het algroritme doet een zet in het eerstvolgende vrije vakje, vervolgens doet hij dit ook voor de tegenstander. Doormiddel van een recrusive methode blijft hij dit doen tot alle mogelijkheden zijn geweest. Als een branch uitloopt op een win, returned de functie '+10', als het uitloopt op een verlies '-10', en bij gelijkspel '0'. Als het wordt terug gegeven worden de uitkomsten van de kinderen van elke parent met elkaar vergeleken, het hoogste (of laagste voor de tegenstander) word gereturnd naar de volgende parent. Uitijdelijk zou de beste move met de meeste win kans moeten worden returned naar de root.   



## Implementatie 
 - Pure functies
 - Immutability
 - Recursie 
 - First-class functions
 - Higher-order functions
 - Pattern matching 


## Reflectie 
Ik vond dit een leuke opdracht, het was erg uitdagend. Het was lastig om te moeten programeren zonder dat ik variablen van waarde kon veranderen, of een for loop te gebruiken. Dit is normaal de basis van hoe ik programeer, door deze opdracht moest ik echt op een andere manier ga nadenken. De recursie vond ik ook erg lastig, vooral als ik meerdere zetten vooruit moest denken. Heb er aardig wat tijd ingestopt, maar ik heb nu een werkend algoritme dat (als het goed is) onverslaanbaar is. 


## Conclusie 
– Samenvatting van de belangrijkste leerpunten.

## Bronvermelding 
– Vermeldt alle bronnen die je gebruik hebt. Als je gebruik maakt van GenAI (zoals ChatGPT) vermeld dit dan en neem links op naar de volledige conversaties. Geef dan ook in je verslag aan hoe je GenAI hebt gebruikt (waarom heb je welke prompt gebruikt en wat deed je met de output).



[Minimax Algorithm](https://www.youtube.com/watch?v=5y2a0Zhgq0U)
<br>
[Haskell](https://www.haskell.org/)
<br>
[Lesstof](https://aim-cni.github.io/app/docs/Week%204/Les%201/Lesprogramma)





Auteur: Yasin Geddi



