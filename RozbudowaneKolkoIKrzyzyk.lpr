program RozbudowaneKolkoIKrzyzyk;

uses CRT, Drzewo, ListaPodwojnieWiazana;

type planszaT = array of array of integer;
//Tablica jednowymiarowa
type tablicaJ = array of integer;

////////////////////////////////////////////////////////////////////////////////
//Oznaczenia w tablicy zawierajacej stan gry:
//0 - pole puste; 1 - kolko; 2 - krzyzyk
////////////////////////////////////////////////////////////////////////////////


//Funckaj sprawdzajaca same przekatne
//i, j - wspolzedne pocztaku przekatnej
//k = 1, (-1) - mowi, czy sprawdzamy na ukos od lewej do prawej, czy odwrotnie
function sprawdzPP(plansza : planszaT; wymiaryP : integer; iloscW : integer; i, j, k : integer) : integer;
var i1, i2 : integer;
begin
  sprawdzPP := 0;

  if k = 1 then
  begin
    //W zaleznosci ile 'iloscW' sie zmiesci w kolumnie
    for i1 := 0 to wymiaryP - iloscW - i - j do
    begin
      //Aby if w kolejnejnej petli for wykonal sie choc raz
      sprawdzPP := 4;

      //Sprawdzamy dwojkami
      for i2 := i1 to iloscW - 2 + i1 do
      begin
        if plansza[i + i2, j + i2] = plansza[i + i2 + 1, j + i2 + 1] then
        begin
          if sprawdzPP <> 0 then sprawdzPP := plansza[i + i1, j + i1];
        end else sprawdzPP := 0;
      end;
      if sprawdzPP <> 0 then Exit;
    end;
  end else
  begin
    //W zaleznosci ile 'iloscW' sie zmiesci w kolumnie
    for i1 := 0 to wymiaryP - iloscW - i - ((wymiaryP - 1) - j) do
    begin
      //Aby if w kolejnejnej petli for wykonal sie choc raz
      sprawdzPP := 4;

      //Sprawdzamy dwojkami
      for i2 := i1 to iloscW - 2 + i1 do
      begin
        //Writeln('[', i + i2, ', ', j - i2, ']  = [', i + i2 + 1, ', ', j - i2 - 1, ']   i2: ', i2);
        if plansza[i + i2, j - i2] = plansza[i + i2 + 1, j - i2 - 1] then
        begin
          if sprawdzPP <> 0 then sprawdzPP := plansza[i + i2, j - i2];
          //Writeln('    sprawdzPP ', sprawdzPP);
        end else sprawdzPP := 0;
      end;
      if sprawdzPP <> 0 then Exit;
    end;
  end;
end;

//Funkcja sprawdzajaca, cyz ktos wygral
//wymiaryP - wymiary planszy(obydwa sa takie same, wiec jedna zmienna);
//iloscW - ilosc wygrywajaca, czyli wymagana dlugosc ciagu takich zamych pol, by byla wygrana, minimalnie wynosi 2(!!!)
//Funkcja zwraca: 3 - gdy wystapi blad; 1,2 - w zaleznosci kto wygral, 0 - gdy sytuacja jest...
//...nierozstrzygnieta
function sprawdzP(plansza : planszaT; wymiaryP : integer; iloscW : integer) : integer;
var i1, i2, i3, flaga1, flaga2 : integer;
begin
  //Zerujemy na wszelki wypadek:
  sprawdzP := 0;

  //Gdy ktorys z parametrow sie nie zgadza, jest absurdalny itp. zwracamy blad
  if (wymiaryP < iloscW) or (iloscW < 2) then
  begin
    sprawdzP := 3; Exit;
  end
  else
  begin
    //Najpierw sprawdzamy POZIOME rozlozenie
    //Przesowamy sie po wierszach:
    for i1 := 0 to wymiaryP - 1 do
    begin
      //W danym wierszu sprawdzamy po iloscW pozycji na raz
      for i2 := 0 to wymiaryP - iloscW do
      begin
        //Tak, by za pierwszym razem warunek w warunku if w petli for ponizej sie wykonal:
        sprawdzP := 4;

        //Calosc rozbijamy jeszcze na dwa sprawdzenia
        for i3 := i2 to i2 + iloscW - 2 do
        begin
          //Writeln('[', i1, ', ', i3, ']  = [', i1, ', ', i3 + 1, ']   i2: ', i2);
          if (plansza[i1, i3] = plansza[i1, i3 + 1]) then
          begin
            if sprawdzP <> 0 then sprawdzP := plansza[i1, i3];
            //Writeln('\nsprawdzP ', sprawdzP);
          end else
            begin
              sprawdzP := 0;
            end;
        end;
        if sprawdzP <> 0 then Exit;
      end;
    end;
  end;

  //Nastepnie sprawdzamy PIONOWE rozlozenie
  for i1 := 0 to wymiaryP - 1 do
  begin
    for i2 := 0 to wymiaryP - iloscW do
    begin
      //Tak, by za pierwszym razem warunek w warunku if w petli for ponizej sie wykonal:
      sprawdzP := 4;

      for i3 := i2 to i2 + iloscW - 2 do
      begin
        if plansza[i3, i1] = plansza[i3 + 1, i1] then
        begin
          if sprawdzP <> 0 then sprawdzP := plansza[i3, i1];
        end else sprawdzP := 0;
      end;
      if sprawdzP <> 0 then Exit;
    end;
  end;

  //A na koncu UKOSNE rozlozenie
  //Najpierw sprawdzamy glowne przekatne
  sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, 0, 0, 1);
  if sprawdzP <> 0 then Exit;
  sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, 0, wymiaryP - 1, -1);
  if sprawdzP <> 0 then Exit;

  //Teraz szukamy takich przekatnych, ze sie w nich zmiesci iloscW kratek:
  //Najpierw te od [0, 1] -> [0, k]...
  //...i te od [1, 0] -> [k, 0]
  //Potem te od [0, n-1] -> [0, k]...
  //...i te od [1, n] -> [k, n]
  for i1 := 0 to wymiaryP - iloscW - 1 do
  begin
    sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, 0, i1 + 1, 1);
    if sprawdzP <> 0 then Exit;

    sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, i1 + 1, 0, 1);
    if sprawdzP <> 0 then Exit;

    sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, 0, wymiaryP - 2 - i1, -1);
    if sprawdzP <> 0 then Exit;

    sprawdzP := sprawdzPP(plansza, wymiaryP, iloscW, i1 + 1, wymiaryP - 1, -1);
    if sprawdzP <> 0 then Exit;
  end;
end;


//Funkcja sprawdzajaca, czy w totczeniu podanego punktu znajduja sie inne punkty
//'punktP' - punkt na planszy
//Zwracane wartosci: 1 - otoczenie istnieje; 0 - otoczenie nie istnieje
function szukajOtoczenia(plansza : planszaT; punktP : array of integer; wymiaryP : integer) : integer;
var i1, i2 : integer; b1, b2, b3, b4 : boolean;
begin
  //Na poczatku inicjalizujemy zwracana wartosc
  szukajOtoczenia := 0;

  //Wartosci te beda sprawdzane wielokrotnie, wiec kosztem narzutu pamieci optymalizujemy kod pod wzgledem czasu wykonania
  //Czy istnieja elementy powyzej danego elementu
  b1 := (punktP[0] <> 0);
  //Czy istnieja elementy ponizej
  b2 := (punktP[0] < wymiaryP - 1);
  //Czy istnieja elementy z lewej strony
  b3 := (punktP[1] <> 0);
  //Czy istnieja elementy z prawej strony
  b4 := (punktP[1] < wymiaryP - 1);

  //Zaczynamy od elementu znajdujacego sie w lewym, gornym rogu - poruszamy sie zgodnie ze wskazowkami zegara
  //Sprawdzamy przylegle punkty powyzej
  if b1 and b3 then if (plansza[punktP[0] - 1, punktP[1] - 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;
  if b1 then if (plansza[punktP[0] - 1, punktP[1]]) <> 0 then begin szukajOtoczenia := 1; exit; end;
  if b1 and b4 then if (plansza[punktP[0] - 1, punktP[1] + 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;

  if b4 then if (plansza[punktP[0], punktP[1] + 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;

  //Sprawdzamy pnkty przylegle ponizej
  if b2 and b4 then if (plansza[punktP[0] + 1, punktP[1] + 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;
  if b2 then if (plansza[punktP[0] + 1, punktP[1]]) <> 0 then begin szukajOtoczenia := 1; exit; end;
  if b2 and b3 then if (plansza[punktP[0] + 1, punktP[1] - 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;

  if b3 then if (plansza[punktP[0], punktP[1] - 1]) <> 0 then begin szukajOtoczenia := 1; exit; end;
end;

//Funkcja sprawdzajaca mozliwe ruchy - podaje jeden wedlug ustalonego schematu
//Schemat:
//W pierwszej kolejnosci sprawdzane sa pola w ktorych najblisze sasiedztwo - tj.
//stykajace sie pola - nie sa puste
function szukajRuchu(plansza : planszaT; ostatni : array of integer; wymiaryP : integer) : tablicaJ;
//tablica 'rezultat' zostala utworzona by funkcja mogla przekazac wynik, a tablica 'pomocnicza' by...
//...moc przekazywac argumenty do funkcji 'szukajOtocznia'
var i1, i2 : integer; rezultat, pomocnicza : array[0..1] of integer;
begin
  //Na poczatek jako zwracany element ustawiamy pierwszy element planszy, na wypadek...
  //...gdybysmy nie znalexli innego, ktoryby spelanial warunki
  rezultat[0] := 0; rezultat[1] := 0;
  szukajRuchu := rezultat;

  for i1 := 0 to wymiaryP - 1 do
  begin
    for i2 := 0 to wymiaryP - 1 do
    begin
      pomocnicza[0] := i1; pomocnicza[1] := i2;
      if szukajOtoczenia(plansza, pomocnicza, wymiaryP) = 1 then
      begin
        szukajRuchu := pomocnicza;
        exit;
      end;
    end;
  end;
end;



//Funkcja do zarzadzania grafem




//Funkcja zmieniajaca stan planszy
function zmienP(plansza : planszaT; ruch : array of integer; ktoRuszyl : integer) : integer;
//var
begin
  plansza[ruch[0], ruch[1]] := ktoRuszyl;
end;

//Funkcja wypisujaca plansze
function wypiszP(plansza : planszaT; wymiar : integer) : integer;
var i1, i2 : integer;
begin
  clrscr;
  for i1 := 0 to wymiar - 1 do
  begin
    for i2 := 0 to wymiar - 1 do
    begin
      if plansza[i1, i2] = 0 then Write('.   ')
        else if plansza[i1, i2] = 1 then Write('O   ')
          else Write('X   ');
    end;
    //Pzejscie do nowej lini:
    Writeln();
  end;
end;



//Zmienne globalne:
var
  //Wymiar planszy:
  n, k : integer;
  //Zmienna na przechowywanie dycyzji gracza o jego ruchu:
  ruch : array[0..1] of integer;
  //Korzen drzewa - globalnie bo nie chcemy po kazdym ruchu ktorego z graczy tworzyc go od nowa
  korzen : WezelP;
  //Tablica na przechowywanie stanu gry:
  plansza : planszaT;


begin
  Writeln('Jakis tekst');
  n := 4;
  Setlength(plansza, n, n);

  //Zmienna 'k' do sterowaniu przebiegiem petli while
  k := 6;

  while k <> 0 do
  begin
    wypiszP(plansza, n);
    Writeln('Wygral ', SprawdzP(plansza, n, 3));
    ruch[0] := 0; ruch[1] := 0;
    Writeln('Szukamy ruchu: ', (szukajRuchu(plansza, ruch, n))[0], '  ', (szukajRuchu(plansza, ruch, n))[1]);
    Write('Podaj jaki ruch chcesz wykonac: ');
    Read(ruch[0], ruch[1]);
    zmienP(plansza, ruch, 1);

    k := k - 1;
  end;
end.




















