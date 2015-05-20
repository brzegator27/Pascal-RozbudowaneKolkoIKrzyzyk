program RozbudowaneKolkoIKrzyzyk;

uses CRT, Drzewo, ListaPodwojnieWiazana;

type planszaT = array of array of integer;
//Tablica jednowymiarowa
type tablicaJ = array[0..1] of integer;

////////////////////////////////////////////////////////////////////////////////
//Oznaczenia w tablicy zawierajacej stan gry:
//0 - pole puste; 1 - kolko; 2 - krzyzyk
////////////////////////////////////////////////////////////////////////////////


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
  Write('    ');
  //clrscr;
  for i1 := 0 to wymiar - 1 do
  begin
    if i1 > 9 then Write(i1, '  ') else Write(i1, '   ');
  end;
  Writeln(); Writeln();
  for i1 := 0 to wymiar - 1 do
  begin
    if i1 > 9 then Write(i1, '   ') else Write(' ', i1, '   ');
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


//Funkcja sprawdzajaca same przekatne
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
var i1, i2, i3 : integer;
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

Function czyRemis(plansza : planszaT; wymiaryP : integer) : integer;
var i, j : integer;
begin
  czyRemis := 1;
  for i := 0 to wymiaryP - 1 do
  begin
    for j := 0 to wymiaryP - 1 do
    begin
      if plansza[i, j] = 0 then czyRemis := -1;
    end;
  end;
end;

//Funkcja sprawdzajaca, czy w ototczeniu podanego punktu znajduja sie inne punkty
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
  //Jesli podany punkt znajduje sie poza tablica, to zwracamy blad czyli [-1, -1]
  //UWAGA nie uwzgledniamy wartosci ujemnych!!!
  if (ostatni[0] >= wymiaryP) or (ostatni[1] >= wymiaryP) then
  begin
    rezultat[0] := -1; rezultat[1] := -1;
    szukajRuchu := rezultat;
    exit;
  end;

  //Jesli jako ostatni zostal przekazany element o wspolzednych ujemnych to szukamy od pierwszego elementu,...
  //...a tym poza glowna petla musimy sprawdzic, czy pierwszy element nam odpowiada, jesli tak to konczymy sprawdzanie,...
  //...a jesli nie, to kontynujemy
  pomocnicza[0] := 0; pomocnicza[1] := 0;
  if (ostatni[0] < 0) or (ostatni[1] < 0) then
  begin
    if (szukajOtoczenia(plansza, pomocnicza, wymiaryP) = 1) and (plansza[pomocnicza[0], pomocnicza[1]] = 0) then
    begin
      rezultat[0] := 0; rezultat[1] := 0;
      szukajRuchu := rezultat;
      exit;
    end;
    //Po tej instrukcji if sprawdzamy dla wszystkich poza elementem [0, 0], ktory juz sprawdzilismy
    ostatni[0] := 0; ostatni[1] := 0;
  end;

  //Na poczatek jako zwracany element ustawiamy na element spoza planszy, na wypadek...
  //...gdybysmy nie znalexli takiego, ktoryby spelanial warunki, jest to rozumiane jako zwracanie bledu przez te funkcje
  rezultat[0] := -1; rezultat[1] := -1;
  szukajRuchu := rezultat;

  //Szukamy od wiersza, w ktorym znajduje sie ostatnio znaleziony element
  for i1 := ostatni[0] to wymiaryP - 1 do
  begin
    for i2 := 0 to wymiaryP - 1 do
    begin
      //Sprawdzamy, czy przypadkiem [i1, i2] nie wskazuje na element będący przed elementem 'ostatni', lub...
      //...na element 'ostatni':
      if not((i1 = ostatni[0]) and (i2 <= ostatni[1])) then
      begin
        pomocnicza[0] := i1; pomocnicza[1] := i2;
        //Do sprawdzenia:
        //Writeln('pomocnicza[0] := ', pomocnicza[0], '   pomocnicza[1] := ', pomocnicza[1]);
        if (szukajOtoczenia(plansza, pomocnicza, wymiaryP) = 1) and (plansza[pomocnicza[0], pomocnicza[1]] = 0) then
        begin
          //Write('Tutaj2   ');
          szukajRuchu := pomocnicza;
          exit;
        end;
      end;
    end;
  end;
end;

//Funkcja dodajaca podwezly i sprawdzajaca, czy ktorys jest wygrywajacy - bedzie rekurencyjna(prawdopodobnie spowoduje to duzy narzut pamieci)
//Opis zmiennych pobieranych przez funkcje:
//'plansza' - plansza gry; 'wymiaryP' - wymiary tej planszy; 'wezel' - wskaznik do naszego wezla; 'stopienZ' - stopien zagniezdzenia...
//...; 'kogoRuch' - mowi, kto ma teraz ruch; 'docelowySZ' - stopien zagniezdzenia, po ktorego osiagnieciu nie szukamy dalszych podwezlow...
//...; 'iloscW' - wymagana ilosc takich samych "piokow" w lini, by wygrac, potrzebne do ocenienia, czy wezel jest wygrywajacy
function SzukajRwP(plansza : planszaT; wymiaryP : integer; wezel : WezelP; stopienZ : integer; kogoRuch : integer; iloscW : integer) : WezelP;
//'stopienZ' - stopien zagniezdzenia
var i1, czyWygrywajacy, kogoNastepnyRuch : integer; ruch : array[0..1] of integer; nowyWezel : WezelP;
begin
  i1 := 1;
  //Szukamy od poczatku planszy:
  ruch[0] := -1; ruch[1] := -1;

  //if kogoRuch = 1 then kogoNastepnyRuch := 2 else kogoNastepnyRuch := 1;

  while i1 <> -1 do
  begin
    //szukajRuchu(plansza : planszaT; ostatni : array of integer; wymiaryP : integer) : tablicaJ;
    //Write('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1], ';     ');
    ruch := szukajRuchu(plansza, ruch, wymiaryP);
    //Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
    if (ruch[0] <> -1) and (ruch[1] <> -1) then
    begin
      //function dodajPW(wezel : WezelP; Nr : integer) : WezelP;
      nowyWezel := dodajPW(wezel, i1);
      //Zmieniamy plansze
      zmienP(plansza, ruch, kogoRuch);
      czyWygrywajacy := SprawdzP(plansza, wymiaryP, iloscW);

      //if czyWygrywajacy <> 0 then Writeln(czyWygrywajacy);
      //function inicjalizujDG(wezel : WezelP; stopien : integer; wartosc : integer; ruch : array of integer; kogoRuch : integer) : integer;
      inicjalizujDG(nowyWezel, stopienZ, czyWygrywajacy, ruch, kogoRuch);
      //Writeln('!!!!!!ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
      //Jesli oczekuje sie wiekszego zagniezdzenia wezlow szukamy podwezlow dla nowo znalezionego wezla:
      {
      if (stopienZ < docelowySZ) and (czyWygrywajacy = 0) then
      begin
        UzupelnijG(plansza, wymiaryP, nowyWezel, stopienZ + 1, kogoNastepnyRuch, docelowySZ, iloscW, kimNieGramy);
      end;
      }
      //Spowrotem zmieniamy plansze:
      zmienP(plansza, ruch, 0);
      //wypiszP(plansza, wymiaryP);
      //Writeln();

      i1 := i1 + 1;

      //Jesli ruch jest wygrywajacy dla ktoregos z graczy, to nie szukamy juz dalszych podwezlow, bo wybieramy wlasnie ten
      if czyWygrywajacy <> 0 then
      begin
        i1 := -1;
        szukajRwP := nowyWezel;
      end;

    end else
    begin
      i1 := -1;
      szukajRwP := NIL;
      exit;
    end;
  end;
end;

//Funkcja szukajaca ................... - bedzie rekurencyjna(prawdopodobnie spowoduje to duzy narzut pamieci)
//Opis zmiennych pobieranych przez funkcje:
//'plansza' - plansza gry; 'wymiaryP' - wymiary tej planszy; 'wezel' - wskaznik do naszego wezla; 'stopienZ' - stopien zagniezdzenia...
//...; 'kogoRuch' - mowi, kto ma teraz ruch; 'docelowySZ' - stopien zagniezdzenia, po ktorego osiagnieciu nie szukamy dalszych podwezlow...
//...; 'iloscW' - wymagana ilosc takich samych "piokow" w lini, by wygrac, potrzebne do ocenienia, czy wezel jest wygrywajacy
function SzukajWR(plansza : planszaT; wymiaryP, iloscW, kimGramy : integer; wezel : WezelP) : TablicaJ;
//'stopienZ' - stopien zagniezdzenia
var kogoNastepnyRuch : integer; ruch : array[0..1] of integer; nowyWezel : WezelP; pomE : ElementP;
begin
  if wezel^.DaneP^.KogoRuch = 1 then kogoNastepnyRuch := 2 else kogoNastepnyRuch := 1;
  ruch[0] := -1; ruch[1] := -1;

  //Sprawdzamy, czy dany wezel ma jakies podwezly:
  if wezel^.Podwezly = NIL then
  begin
    //SzukajRwP(plansza : planszaT; wymiaryP : integer; wezel : WezelP; stopienZ : integer; kogoRuch : integer; iloscW : integer) : WezelP;
    nowyWezel := SzukajRwP(plansza, wymiaryP, wezel, wezel^.DaneP^.Stopien + 1, kogoNastepnyRuch, iloscW);
    if nowyWezel <> NIL then
    begin
      SzukajWR := nowyWezel^.DaneP^.Ruch;
    end else
    begin
      SzukajWR := ruch;
      //Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
    end;
  end else
  begin
    pomE := wezel^.Podwezly;
    while pomE <> NIL do
    begin
      SzukajWR(plansza, wymiaryP, iloscW, kimGramy, pomE^.Wezel);
      pomE := pomE^.Nast;
    end;
  end;
end;

//Funkcja szukajaca najlepszego ruchu - bedzie rekurencyjna(prawdopodobnie spowoduje to duzy narzut pamieci)
//Opis zmiennych pobieranych przez funkcje:
//'plansza' - plansza gry; 'wymiaryP' - wymiary tej planszy; 'wezel' - wskaznik do naszego wezla; 'stopienZ' - stopien zagniezdzenia...
//...; 'kogoRuch' - mowi, kto ma teraz ruch; 'docelowySZ' - stopien zagniezdzenia, po ktorego osiagnieciu nie szukamy dalszych podwezlow...
//...; 'iloscW' - wymagana ilosc takich samych "piokow" w lini, by wygrac, potrzebne do ocenienia, czy wezel jest wygrywajacy
function SzukajR(plansza : planszaT; wymiaryP : integer; docelowySZ, iloscW, kimGramy : integer) : TablicaJ;
//'stopienZ' - stopien zagniezdzenia
var i1, i2, i3, czyWygrywajacy, kogoNastepnyRuch, stopienZ : integer; ruch, ruchNieDlaNas : array[0..1] of integer; korzen, nowyWezel, pomW: WezelP; pomE : ElementP;
begin
  //Poczatkowo ustawiamy na -1 -1:
  ruch[0] := -1; ruch[1] := -1;

  //Sprawdzamy, czy pierwszy ruch nie jest dla nas wygrywajacy:
  while i1 <> -1 do
  begin
    //szukajRuchu(plansza : planszaT; ostatni : array of integer; wymiaryP : integer) : tablicaJ;
    //Write('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1], ';     ');
    ruch := szukajRuchu(plansza, ruch, wymiaryP);
    //Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
    if (ruch[0] <> -1) and (ruch[1] <> -1) then
    begin
      //Zmieniamy plansze
      zmienP(plansza, ruch, kimGramy);
      czyWygrywajacy := SprawdzP(plansza, wymiaryP, iloscW);

      //Spowrotem zmieniamy plansze:
      zmienP(plansza, ruch, 0);

      //Jesli ruch jest wygrywajacy dla ktoregos z graczy, to nie szukamy juz dalszych podwezlow, bo wybieramy wlasnie ten
      if czyWygrywajacy = kimGramy then
      begin
        i1 := -1;
        SzukajR := ruch;
        exit;
      end;
    end else
    begin
      i1 := -1;
    end;
  end;

  //Jesli nie znalexlismy szukamy dalej w drzewie:

  korzen := dodajW();
  korzen^.Nr := 0;

  {ruch[0] := -1; ruch[1] := -1;}

  inicjalizujDG(korzen, 0, 0, ruch, kimGramy);

  i1 := 0;

  //SzukajWR(plansza : planszaT; wymiaryP, iloscW, kimGramy : integer, wezel : WezelP) : TablicaJ;
  while i1 < docelowySZ do
  begin
    ruch := SzukajWR(plansza, wymiaryP, iloscW, kimGramy, korzen);
    if (ruch[0] <> -1) and (ruch[1] <> -1) then
    begin
      i1 := docelowySZ;
      //Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
    end;
    i1 := i1 + 1;
    //Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
  end;

  if (ruch[0] <> -1) and (ruch[1] <> -1) then
  begin
    SzukajR := ruch;
  end else
  begin
    SzukajR := szukajRuchu(plansza, ruch, wymiaryP);
  end;
  //Writeln('ruch[0] := ', ruch[0], '   ruch[1] := ', ruch[1]);
end;

//Zmienne globalne:
var
  //Wymiar planszy, k - sterowaniem przebiegiem petli, l - ilosc potrzebnych tych samych znakow w lini by ktos wygral:
  //m - zmienna pomocnicza
  n, k, l, m, w, koniec: integer;
  //Zmienna do przechowywania, wartosci mowiacej o tym, kogo jest obecnie ruch
  b : integer;
  //Zmienna na przechowywanie dycyzji gracza o jego ruchu:
  ruch, ruch1 : array[0..1] of integer;
  //Korzen drzewa - globalnie bo nie chcemy po kazdym ruchu ktorego z graczy tworzyc go od nowa
  //'najlepszyRuch' - zmienna najprawdopodobniej tymczasowa:
  korzen, najlepszyRuch : WezelP;
  //Tablica na przechowywanie stanu gry:
  plansza : planszaT;


begin
  n := 3;

  //korzen := dodajW();

  l := 3;
  m := 3;
  //Zmienna 'k' do sterowaniu przebiegiem petli while
  k := 0;

  b := 1;

  koniec := 0;

  //Write('Podaj jakich wymiarow ma byc plansza: '); Readln(n);
  //Write('Podaj ile znakow potrzeba do wygranej: '); Readln(l);

  n := 3;
  m := 3;

  Setlength(plansza, n, n);

  clrscr();

  while k <> -1 do
  begin
    w := w + 1;
    k := SprawdzP(plansza, n, l);
    if (k = 0) or (k = 3) then
    begin

    ruch[0] := -1; ruch[1] := -1;
    //Sprawdzamy, czy jest remis:
    if koniec = 1 then
    begin
      clrscr();
      wypiszP(plansza, n); Writeln();
      //Mamy remis więc:
      Writeln('Remis :/'); k := -1;
    //Jesli ruch uzyszkodnika:
    end else if (w mod 2) = 1 then
    begin
      clrscr();
      wypiszP(plansza, n);
      //Writeln('Szukamy ruchu: ', (szukajRuchu(plansza, ruch, n))[0], '  ', (szukajRuchu(plansza, ruch, n))[1]);
      Write('Podaj jaki ruch chcesz wykonac: ');
      Read(ruch[0], ruch[1]);
      zmienP(plansza, ruch, b);
    end else
    begin
      //SzukajR(plansza : planszaT; wymiaryP : integer; docelowySZ, iloscW, kimGramy : integer) : TablicaJ;
      if czyRemis(plansza, n) <> 1 then
      begin
      ruch1 := SzukajR(plansza, n, 5, l, 2);
      //Writeln('Najlepszy ruch dla X to: ', ruch1[0], ', ', ruch1[1])
      zmienP(plansza, ruch1, 2);
      end else koniec := 1;
    end;
    end else
    begin
      clrscr();
      wypiszP(plansza, n); Writeln();
      Writeln('Wygral: ', k, '!');
      k := -1;
    end;
  end;
  Writeln('Wpisz dowolny znak, by zakonczyc... ');
  Read(k);
end.




















