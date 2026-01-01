# IMPERATIVT VS FUNKTIONELLT SPRÅK
- Imperativt: "Gör så här, sen gör du så här, och sen ändrar du det här värdet."

- Funktionellt: "Här är data $x$, applicera dessa transformationer så att det blir resultatet $y$."

Eller med ett tydligare exempel:
 * Imperativt (Hur): "Gå till köket. Öppna skåpet. Ta fram en kopp. Starta kaffebryggaren. Vänta. Häll upp kaffet i koppen." 
 * (Du styr varje rörelse och ändrar tillståndet på koppen från tom till full).

 * Funktionellt (Vad): "Jag vill ha resultatet av Kaffebryggare(Vatten, Bönor)."
 * (Du fokuserar på transformationen av ingredienser till en färdig produkt, utan att bryta ner varje mekanisk rörelse).

# IMMUTABILITY
Funktionellt språk använder sig av icke muterbara variabler. Detta gör att du alltid måste jobba med kopior av originalet.
Man gör detta för att minska risken av buggar när man gör om data hela tiden. Det tillåter även koden att köras i parallella
processer.

# PURE FUNCTIONS
Du kan minska komplexiteten hos större aplikationer genom att skriva funktioner som har dessa tre egenskaper.

1. Värdena är immutable
2. funktionens resultat är endast påverkat av funktionens argument
3. funktionen skapar ej effekter utöver det värde det returnerar

Funktionen tar alltså in ett värde, processar det och returnerar ett nytt värde. Uppfyller en funktion alla dessa krav kallas 
den för en pure function.

## IMPURE FUNCTIONS
Vissa funktioner kommer inte vara så enkla att de kan vara pure functions. Det kommer vara svårare att förutspå deras output. 
Dessa funktioner kallas för impure functions.

# Objekt vs funktioner
I imperativa språk brukar datan generellt sparas i ett objekt av en klass eller liknande. Därför går det objektets data att 
manipulera genom att kalla på objektet. Men i funktionell programmering genereras en ny datastruktur, du behöver alltså ge 
funktionen datan du vill manipulera varje gång. Detta för att datan är immutable och inte kan skrivas över, kopior måste 
alltid göras. 

# Att använda funktioner som argument
I funktionell programmering går det att använda funktioner i princip överallt. I ett exempel tar vi en funtkion och tilldelar
den en lista och en annan funktion. Den första funktionen vet hur man använder den andra funktionen för att konvertera alla 
element i listan till uppercase. Detta gör att den första funktionen kan returnera en ny lista med alla värden i uppercase. 

# Chapter 2 s.24
Funktioner kommer jobba i samma turordning som i matte. T.ex: 
- 2 + 2 * 3 = 8 -> pga * har högre prioritering än +. 

Vill du ändra detta så att + operationen skall göras först får du använda dig av parenteser, precis som i matte. Alltså: 
- (2 + 2) * 3 = 12 -> eftersom det inom parentesen görs först får du 4 * 3 = 12

# Operatorer
De flesta vanliga finns, string, int, float etc. Men här finns även 2 nya.
    ++ 
    <>
Där ++ konkatenerar två listor medans <> konkatenerar två strängar eller binaries.

# Logial expressions
Den vänstra sidan måste vara en bool, den högre kan vara vad du vill. T.ex har du: True and 1 kommer output True. Men gör du
istället 1 and True kommer du få ett error.

Vill du göra kunna acceptera truthy och falsy på båda sidorna får du använda dig av && respektive || operatorerna. De godkänner
båda värdena på vilken sida som helst. Det som är grejen dock är att om du skickar ett värde på vänster sida av operatorn och
en bool på höger kommer den returnera värdet på din bool. Men om du skickar din bool på vänster sida, kommer den returnera det
andra värdet beroende på om din bool är true eller false. Alltså om din bool är false kommer den ge en return som är false.
Men om du har en bool som är true kommer du få en return av värdet på andra sidan om din operator. Se exemplet nedan!

    EX:
        iex(4)> "hello" && false
        false
        iex(5)> "hello" && true
        true
        iex(6)> true && "hello"
        "hello"
        iex(7)> false && "hello"
        false

