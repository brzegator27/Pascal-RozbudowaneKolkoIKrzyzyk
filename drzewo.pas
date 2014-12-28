unit Drzewo;


//Sekcja publiczna:
interface

uses ListaPodwojnieWiazana;

type WezelP = ^Wezel;
type DaneGP = ^DaneG;


//Deklaracje funkcji:
function inicjalizujDG(wezel : WezelP; stopien : integer; wartosc : integer; ruch : array of integer; kogoRuch : integer) : integer;
function dodajW() : WezelP;
function dodajPW(wezel : WezelP; Nr : integer) : WezelP;
function usunW(wezel : WezelP) : integer;
function szukajW(od : WezelP; Nr : integer) : WezelP;
function wypiszW(od : WezelP; stopien : integer) : integer; overload;
function wypiszW(od : WezelP) : integer; overload;

//Sekcja prywatna
implementation

//Funkcja inicjalizujaca dane typu 'DaneG' dla danego wezla
function inicjalizujDG(wezel : WezelP; stopien : integer; wartosc : integer; ruch : array of integer; kogoRuch : integer) : integer;
begin
  wezel^.DaneP^.Stopien := stopien;
  wezel^.DaneP^.Wartosc := wartosc;
  wezel^.DaneP^.Ruch := ruch;
  wezel^.DaneP^.KogoRuch := kogoRuch;
end;

//Funkcja inicjalizujaca nowy wezel
function dodajW() : WezelP;
var danePW : DaneGP;
begin
  //Tworzymy nowy obiekt typu Wezel
  new(dodajW);
  dodajW^.Podwezly := NIL;

  //Tworzymy obiekt z danymi potrzebnymi do zarzadzania grafem z poziomu programu
  //W tym celu tworzy obiekt typu 'DaneG'
  new(danePW);
  //Wskaznik ten, po zakonczeniu wykonywania tej funkcji bedzie przechowywany bezposrednio w wezle
  dodajW^.DaneP := danePW;
end;

//Funkcja dodajaca podwezel:
function dodajPW(wezel : WezelP; Nr : integer) : WezelP;
var nowyElement : ElementP; pomocniczy : ElementP; danePW : DaneGP;
begin
  //Gdy wezel nie ma jeszcze zadnego podwezla:
  if wezel^.Podwezly = NIL then
  begin
    //Tworzymy nowy element do listy podwojnie wiazanej zawierajace wskazniki do podwezlow:
    new(nowyElement);
    nowyElement^.Nast := NIL;
    nowyElement^.Pop := NIL;
    //Podwezly numerujemy od zera:
    nowyElement^.Nr := 0;
    wezel^.Podwezly := nowyElement;
    //Gdy mamy juz ten element mozemy do niego przypisac jakis wezel:
    new(dodajPW);
    dodajPW^.Rodzic := wezel;
    dodajPW^.Nr := Nr;
    dodajPW^.Podwezly := NIL;
    dodajPW^.Dowiazanie := nowyElement;

    //Tworzymy obiekt z danymi potrzebnymi do zarzadzania grafem z poziomu programu
    //W tym celu tworzy obiekt typu 'DaneG'
    new(danePW);
    //Wskaznik ten, po zakonczeniu wykonywania tej funkcji bedzie przechowywany bezposrednio w wezle
    dodajPW^.DaneP := danePW;

    wezel^.Podwezly^.Wezel := dodajPW;
    //Writeln('Podwezel dodany');
  end else
  //Gdy wezel ma juz jakies podwezly
    begin
      //Korzystamy ze wskaxnika pomocniczego, by ten z obiektu 'wezel' wskazywal zawsze na pierwszy element listy
      pomocniczy := wezel^.Podwezly;
      //Szukamy ostatniego podwezla:
      while pomocniczy^.Nast <> NIL do
      begin
        pomocniczy := pomocniczy^.Nast;
      end;

      //Tworzymy nowy element do listy podwojnie wiazanej zawierajace wskazniki do podwezlow:
      new(nowyElement);
      nowyElement^.Nast := NIL;
      nowyElement^.Pop := pomocniczy;
      pomocniczy^.Nast := nowyElement;
      //Numer podwezla jest o 1 wiekszy od numeru ostatniego podwezla z tych istniejacych:
      nowyElement^.Nr := pomocniczy^.Nr + 1;
      //Gdy mamy juz ten element mozemy do niego przypisac jakis wezel:
      new(dodajPW);
      dodajPW^.Rodzic := wezel;
      dodajPW^.Nr := Nr;
      dodajPW^.Podwezly := NIL;
      dodajPW^.Dowiazanie := nowyElement;

      //Tworzymy obiekt z danymi potrzebnymi do zarzadzania grafem z poziomu programu
      //W tym celu tworzy obiekt typu 'DaneG'
      new(danePW);
      //Wskaznik ten, po zakonczeniu wykonywania tej funkcji bedzie przechowywany bezposrednio w wezle...
      dodajPW^.DaneP := danePW;
      //...przypisanie konkretnych wartosci pozostawiamy klientowi

      nowyElement^.Wezel := dodajPW;
      //Raczej zle - u gory dobrze
      //wezel^.Podwezly^.Wezel := dodajPW;
    end;
end;

//Funkcja usuwajaca wezel wraz z jego podgaleziami
//Dobrze bedzie prawdopodobnie skorzystac z rekurencji
function usunW(wezel : WezelP) : integer;
var pomocniczy : ElementP;
begin
  //Poczatkowa inicjalizacja zwracanej wartosci:
  usunW := 0;
  //Sprawdzamy, czy podany wskaznik wskazuje na jakikolwiek wezel
  if wezel <> NIL then
  begin
    //Jesli wezel nie ma podwezlow to go usuwamy
    if wezel^.Podwezly = NIL then
    begin
      //Jesli wezel ma rodzica, to trzeba usunac dowiazania do naszego wezla, ktore sa w jego rodzicu
      //Sprawdzamy, czy rodzic istnieje:
      if wezel^.Rodzic <> NIL then
      begin
        //Sprawdzamy, czy wskaznik z rodzica wskazuje na element listy zawierajacego dowiazanie do naszego wezla
        //Jesli tak, to wskaznik musimy przestawic na inny element
        if wezel^.Rodzic^.Podwezly = wezel^.Dowiazanie then
        begin
          wezel^.Rodzic^.Podwezly := wezel^.Dowiazanie^.Nast;
        end;

        //Po przesuniecia wskaznika w naszym rodzicu mozemy bezpiecznie usunac element z jego listy:
        usun(wezel^.Dowiazanie);
      end;
      //Usuwamy wezel:
      dispose(wezel);
      //Operacja zakonczona powodzeniem:
      usunW := 1;
    end else
    //Jezeli wezel ma podwezly to najpierw usowamy je, a pozniej dopiero wlasciwy wezel
      begin
        //Do wskaznika pomocniczego przypisujemy wskaznik wskazujacy na pierwszy element z listy podwojnie wiazanej:
        pomocniczy := wezel^.Podwezly;
        while pomocniczy <> NIL do
        begin
          usunW(pomocniczy^.Wezel);
          //Przedsowamy wskaznik na kolejny element
          pomocniczy := pomocniczy^.Nast;
        end;
        //Usuwamy wlasciwy wezel:
        dispose(wezel);
        //Operacja zakonczona powodzeniem:
        usunW := 1;
      end;
  end;
end;

//Funkcja poszukujaca jakiegos wezla
function szukajW(od : WezelP; Nr : integer) : WezelP;
var pomocniczy : ElementP;
begin
  //Na poczatku przypisujemy szukanemu wezlowi wartosc NIL, na wypadek, gdyby wezel o zadanym numerze nie istnial
  szukajW := NIL;
  //Sprawdzamy, czy podany wezel jest o szukanym numerze
  if od^.Nr = Nr then
  begin
    szukajW := od;
  end else
  //jesli nie, to sprawdzamy podwezly
    begin
      //Do wskaznika pomocniczego przypisujemy wskaznik wskazujacy na pierwszy element z listy podwojnie wiazanej:
      pomocniczy := od^.Podwezly;
      //Jesli nie ma dalszych podwezlow, lub znalexlismy juz jakis to nie sprawdzamy dalej
      while (pomocniczy <> NIL) and (szukajW = NIL) do
      begin
        //Zakladamy, ze istnieje tylko jeden wezel o podanym numerze
        szukajW := szukajW(pomocniczy^.Wezel, Nr);
        //Wskaznik przesowamy
        pomocniczy := pomocniczy^.Nast;
      end;
    end;
end;

//Wersja zmodyfikowana pod program Roz. K. i K. - wypisuje inne wartosci
//Funkcja przedstawiajaca strukture grafu w sposob tekstowy, poczynajac od wezla podanego przez wskaznik
//Zmienna 'stopien' mowi jak bardzo jestesmy zagniezdzeni z elementem na ktory wskazuje wskaznik 'od'
//wzgledem pierwotnego elementu
function wypiszW(od : WezelP; stopien : integer) : integer; overload;
var pomocniczy : ElementP; i : integer; ktoryRaz : integer;
begin
  //Zmienna 'ktoryRaz' mowi nam czy wypisujemy pierwszy, czy dalszy podwezel
  //- jesli pierwszy to przechodzimy do nowej lini
  ktoryRaz := 1;

  //najpierw wyronujemy wzgledem pierwotnego elementu...
  Write(' ');
  //...a teraz wyrownujemy w zaleznosci od stopnia zagniezdzenia
  for i := 2 to stopien do Write('     ');

  //Sprawdzamy, czy wskaznik wskazuje na cokolwiek
  if od <> NIL then
  begin
    //Jesli stopien jest mniejszy od 1, czyli wypisywany element bedzie na samej gorze, to nie uzywamy strzaleczki
    if stopien < 1 then Write('(', od^.DaneP^.Ruch[0], ', ', od^.DaneP^.Ruch[1], ')')
    else Write(' -> ', '(', od^.DaneP^.Ruch[0], ', ', od^.DaneP^.Ruch[1], ')');

    //Wypisujemy podwezly, korzystamy z pomocniczego wskaznika:
    pomocniczy := od^.Podwezly;
    while pomocniczy <> NIL do
    begin
      //Opis - patrz opis 'ktoryRaz', ktory znajduje sie powyzej
      if ktoryRaz = 1 then
      begin
        Writeln();
        ktoryRaz := ktoryRaz - 1;
      end;

      //Wypisujemy podwezel:
      wypiszW(pomocniczy^.Wezel, stopien + 1);

      //Przesowamy wskaznik na kolejny element
      pomocniczy := pomocniczy^.Nast;
    end;
  end;
  Writeln();
end;

//Funkcja przedstawiajaca strukture grafu w sposob tekstowy, poczynajac od wezla podanego przez wskaznik
function wypiszW(od : WezelP) : integer; overload;
var pomocniczy : ElementP;
begin
  //Sprawdzamy, czy wskaznik wskazuje na cokolwiek
  if od <> NIL then
  begin
    Writeln(od^.Nr);
    //Wypisujemy podwezly:
    pomocniczy := od^.Podwezly;
    while pomocniczy <> NIL do
    begin
      wypiszW(pomocniczy^.Wezel, 1);
      pomocniczy := pomocniczy^.Nast;
    end;
  end;
  Writeln();
end;


begin
{  Writeln('Jakis teskt');

  //Na starcie inicjalizujemy jakis poczatkowy element:
  new(korzen);
  korzen^.Nr := 0;
  korzen^.Podwezly := NIL;
  korzen^.Rodzic := NIL;
  korzen^.Wartosc := 0;


  //poczatek := poczatkowy;

  //Na poczatek przypisujemy 1, by petla glowna wykonala sie choc raz, wartosc nie ma wiekszego znaczenia - ma byc rozna od 0
  coZrobic := 1;

  nr := 1;

  //Glowna petla sterujaca:
    while coZrobic <> 0 do
    begin
      Write('Co chcesz zrobic 1-dodaj podwezel do 0 w.; 2-wypisz strukture; 3-usun wezel; 4-dodaj podwezel; 0-koniec;');
      Readln(coZrobic);

      case (coZrobic) of
      1: begin
           dodajPW(korzen, nr);
           nr := nr + 1;
         end;
      2: wypiszW(korzen);
      3: begin
           Writeln('Podaj numer wezla, ktory chcesz usunac: ');
           Readln(szukanyNr);
           usunW(szukajW(korzen, szukanyNr));
         end;
      4: begin
           Write('Do jakiego wezla chcesz dodac podwezel?: ');
           Readln(szukanyNr);
           dodajPW(szukajW(korzen, szukanyNr), nr);
           nr := nr + 1;
         end;
      end;
    end;
}
end.

