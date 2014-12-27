unit ListaPodwojnieWiazana;

//Sekcja publiczna:
interface

//Typ wskaznikowy do pojedynczego elementu kolejki:
type ElementP = ^Element;

//Pojedynczy element kolejki:
Element = record
  Nr : integer;
  Pop, Nast : ElementP;
  Wezel : ^Wezel;
  end;

/////////////////////////////////////////////////////////////////////////////////////////
//UWAGA Pascal jest taki, jaki jest i deklaracja rekordu Wezel musiala sie znalezc tutaj!!!
/////////////////////////////////////////////////////////////////////////////////////////
Wezel = record
  Nr : Integer;
  //Wskaznik, ktory zawsze wskazuje na pierwszy element listy:
  Podwezly : ElementP;
  //Wskaznik do rodzica
  Rodzic : ^Wezel;
  //Wskaznik do elementu z kolejki z rodzica, ktory zawiera wskaznik wskazujacy na ten wezel...
  //...pomocne przy usuwaniu wezla - w usunieciu powiazan z nim
  Dowiazanie : ElementP;
  //Dane pomocnicze:
  DaneP : ^DaneG;
end;

//Dane potrzebne do ocenu stanu gry na dany wexle
DaneG = record
  //Stopien zagniezdzenia danego wezla
  Stopien : integer;
  //Wartosc mowiaca o istotnosci wezla - wieksza wartosc -> wieksza istotnosc
  Wartosc : integer;
  //Dane o ruchu
  Ruch : array[0..1] of integer;
  //Dane o tym, kto ruszyl
  KogoRuch : integer;
end;

/////////////////////////////////////////////////////////////////////////////////////////
//Deklaracje funkcji
/////////////////////////////////////////////////////////////////////////////////////////
function dodaj(wczesniejszy : ElementP; pozniejszy : ElementP; Nr : integer) : ElementP;
function usun(element : ElementP) : ElementP;
function szukaj(od : ElementP; Nr : integer) : ElementP;
function wypisz(od : ElementP) : integer;


//Sekcja prywatna:
implementation

/////////////////////////////////////////////////////////////////////////////////////////
//Definicje funkcji
/////////////////////////////////////////////////////////////////////////////////////////

//Funkcja dodajaca element do listy, PO elemencie na ktory wsazuje wskaznik 'wczesniejszy':
//lub dodajaca element PRZED elementem na ktory wskazuje wskaznik 'pozniejszy':
function dodaj(wczesniejszy : ElementP; pozniejszy : ElementP; Nr : integer) : ElementP;
//newP - nowy element listy, pomocniczy - wskaznik pomocniczy:
var newP : ElementP;
begin
  new(newP);
  //Prosimy uzytkownika o podanie Nr:
  Write('Podaj numer obiektu ktory ma zostac dodany:');
  Readln(Nr);

  newP^.Nr := Nr;

  dodaj := newP;

  //Sprawdzamy, czy element 'wczesniejszy' istnieje:
  if wczesniejszy <> NIL then
  begin
       newP^.Pop := wczesniejszy;
       newP^.Nast := wczesniejszy^.Nast;
       if wczesniejszy^.Nast <> NIL then wczesniejszy^.Nast^.Pop := newP;
       wczesniejszy^.Nast := newP;
  //Jesli wczesniejszy element nie isnieje to sprawdzamy element 'pozniejszy':
  end else if pozniejszy <> NIL then
      begin
           newP^.Pop := pozniejszy^.Pop;
           newP^.Nast := pozniejszy;
           pozniejszy^.Pop^.Nast := newP;
           pozniejszy^.Pop := newP;
      end else
          begin
               newP^.Nast := NIL;
               newP^.Pop := NIL;
          end;

end;

//Funkcja usuwajaca element z listy, po elemencie na ktory wsazuje wskaznik 'element':
function usun(element : ElementP) : ElementP;
//'pomocniczy' - wskaznik pomocniczy:
var pomocniczy : ElementP;
begin
  if element <> NIL then
  begin
       //UWAGA opisy wzgledem obiektu 'element'!!!
       //Wskaznik z elementu nastepnego zaczyna wskazywac na element poprzedni
       //Warto zauwazyc, ze nie musimy sprawdzac, czy 'element^.Nast jest rozny od NIL
       if element^.Pop <> NIL then element^.Pop^.Nast := element^.Nast;
       //Wskaznik z elementu poprzedniego zaczyna wskazywac na element nastepny
       if element^.Nast <> NIL then element^.Nast^.Pop := element^.Pop;
       dispose(element);
  end else Writeln('Blad, element ktory chcesz usunac nie istnieje!!!');
end;

//Funkcja wyszukujace element z listy o zadanym numerze poczawszy od elementu na ktory wsazuje wskaznik 'od':
function szukaj(od : ElementP; Nr : integer) : ElementP;
//'pomocniczy' - wskaznik pomocniczy:
var pomocniczy : ElementP;
begin
  szukaj := NIL;
  pomocniczy := od;

  //Jesli Nr jest rowny 0, to pytamy uzytwkownika o nowy numer:
  if Nr = 0 then
  begin
       Write('Podaj nr obiektu do wyszukania: ');
       Readln(Nr);
  end;

  while pomocniczy <> NIL do
  begin
      if pomocniczy^.Nr = Nr then
      begin
           szukaj := pomocniczy;
           pomocniczy := NIL;
      end else pomocniczy := pomocniczy^.Nast;
  end;
end;

//Funkcja wypisujaca elementy z listy poczawszy od elementu na ktory wsazuje wskaznik 'od':
function wypisz(od : ElementP) : integer;
//pomocniczy - wskaznik pomocniczy:
var pomocniczy : ElementP;
begin
  pomocniczy := od;
  while pomocniczy <> NIL do
  begin
      Write(pomocniczy^.Nr, ' ');
      pomocniczy := pomocniczy^.Nast;
  end;
  Writeln();

end;

begin
end.


